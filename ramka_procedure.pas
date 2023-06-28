unit ramka_procedure;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, DBGrids, SynEdit,
  SynHighlighterSQL, ZTransaction, db, memds, ZConnection, ZDataset,
  ZSqlProcessor;

type

  TRamkaProcedureOnApply = procedure(Sender: TObject; aOldTable,aNewTable: string; aOperation: integer) of object;

  { TFRamkaProcedure }

  TFRamkaProcedure = class(TFrame)
    awejscie: TMemDataset;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGrid1: TDBGrid;
    dswejscie: TDataSource;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SynSQLSyn1: TSynSQLSyn;
    vcreate: TSynEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure dswejscieStateChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure _BEFORE_CLOSE(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
  private
    FOnApply: TRamkaProcedureOnApply;
    procedure ShowProcedure(nazwa: string; cialo: TStrings);
    function GetParameters: string;
  public
    io_db: TZConnection;
    io_trans: TZTransaction;
    io_tablename: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure new_procedure;
    procedure load_procedure;
  published
    property OnApply: TRamkaProcedureOnApply read FOnApply write FOnApply;
  end;

implementation

uses
  ecode, serwis, updatesql;

{$R *.lfm}

{ TFRamkaProcedure }

procedure TFRamkaProcedure.BitBtn1Click(Sender: TObject);
begin
  load_procedure;
end;

procedure TFRamkaProcedure._BEFORE_CLOSE(DataSet: TDataSet);
begin
  while not Dataset.IsEmpty do Dataset.Delete;
end;

procedure TFRamkaProcedure.dswejscieStateChange(Sender: TObject);
var
  a,ne,e: boolean;
begin
  io_trans.State(dswejscie,a,ne,e);
  SpeedButton1.Enabled:=a;
  SpeedButton2.Enabled:=ne;
  SpeedButton3.Enabled:=ne;
  SpeedButton4.Enabled:=e;
  SpeedButton5.Enabled:=e;
end;

procedure TFRamkaProcedure.BitBtn2Click(Sender: TObject);
var
  vsql: TStrings;
  a: integer;
  s: string;
begin
  if awejscie.State in [dsEdit,dsInsert] then awejscie.Post;
  vsql:=TStringList.Create;
  try
    //if io_tablename<>'' then vsql.Add('DROP PROCEDURE '+io_tablename+';');
    vsql.Add('DELIMITER //');
    vsql.Add('CREATE OR REPLACE PROCEDURE '+Edit1.Text+' ('+GetParameters+')');
    vsql.Add('BEGIN');
    vsql.AddText(vcreate.Lines.Text);
    vsql.Add('END');
    a:=vsql.Count-1;
    s:=vsql[a];
    vsql.Delete(a);
    if s[length(s)]=';' then delete(s,length(s),1);
    vsql.Add(s+' //');
    vsql.Add('DELIMITER ;');
    if vsql.Count>0 then
    begin
      FUpdateSQL:=TFUpdateSQL.Create(self);
      try
        FUpdateSQL.io_db:=io_db;
        FUpdateSQL.io_trans:=io_trans;
        FUpdateSQL.io_tablename:=io_tablename;
        FUpdateSQL.sql.Lines.Assign(vsql);
        FUpdateSQL.ShowModal;
        if FUpdateSQL.io_ok then
        begin
          if Assigned(FOnApply) then FOnApply(self,io_tablename,Edit1.Text,4);
          io_tablename:=Edit1.Text;
          BitBtn1.Click;
        end;
      finally
        FUpdateSQL.Free;
      end;
    end;
  finally
    vsql.Free;
  end;
end;

procedure TFRamkaProcedure.SpeedButton1Click(Sender: TObject);
begin
  awejscie.Append;
end;

procedure TFRamkaProcedure.SpeedButton2Click(Sender: TObject);
begin
  awejscie.Edit;
end;

procedure TFRamkaProcedure.SpeedButton3Click(Sender: TObject);
begin
  awejscie.Delete;
end;

procedure TFRamkaProcedure.SpeedButton4Click(Sender: TObject);
begin
  awejscie.Post;
end;

procedure TFRamkaProcedure.SpeedButton5Click(Sender: TObject);
begin
  awejscie.Cancel;
end;

procedure TFRamkaProcedure.ShowProcedure(nazwa: string; cialo: TStrings);
var
  q1: TZQuery;
begin
  cialo.Clear;
  q1:=TZQuery.Create(self);
  q1.Connection:=io_db;
  q1.SQL.Add('show create procedure '+nazwa);
  try
    q1.Open;
    cialo.Add(NormalizeCialoProcedury(q1.FieldByName('Create Procedure').AsString));
    q1.Close;
  finally
    q1.Free;
  end;
end;

function TFRamkaProcedure.GetParameters: string;
var
  x: TBookmark;
  s: string;
begin
  s:='';
  awejscie.DisableControls;
  x:=awejscie.GetBookmark;
  awejscie.First;
  while not awejscie.EOF do
  begin
    if s='' then s:=awejscie.FieldByName('oper').AsString+' '+awejscie.FieldByName('nazwa').AsString+' '+awejscie.FieldByName('typ').AsString else
    s:=s+', '+awejscie.FieldByName('oper').AsString+' '+awejscie.FieldByName('nazwa').AsString+' '+awejscie.FieldByName('typ').AsString;
    awejscie.Next;
  end;
  awejscie.GotoBookmark(x);
  awejscie.EnableControls;
  result:=s;
end;

constructor TFRamkaProcedure.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFRamkaProcedure.Destroy;
begin
  inherited Destroy;
end;

procedure TFRamkaProcedure.new_procedure;
begin
  awejscie.Open;
  Edit1.SetFocus;
end;

procedure TFRamkaProcedure.load_procedure;
var
  schema: TStrings;
  s,pom,pom2: string;
  a,i: integer;
begin //[rfReplaceAll,rfIgnoreCase]
  if awejscie.Active then awejscie.Close;
  awejscie.Open;
  schema:=TStringList.Create;
  try
    ShowProcedure(io_tablename,schema);
    s:=schema.Text;
    s:=trim(StringReplace(s,'CREATE PROCEDURE','',[rfIgnoreCase]));
    //s:=StringReplace(s,'int(10)','int',[rfReplaceAll,rfIgnoreCase]);
    //s:=StringReplace(s,'int(11)','int',[rfReplaceAll,rfIgnoreCase]);
    //s:=StringReplace(s,'tinyint(4)','tinyint',[rfReplaceAll,rfIgnoreCase]);
    //s:=StringReplace(s,'tinyint(5)','tinyint',[rfReplaceAll,rfIgnoreCase]);
    //s:=StringReplace(s,'smallint(5)','smallint',[rfReplaceAll,rfIgnoreCase]);
    //s:=StringReplace(s,'smallint(6)','smallint',[rfReplaceAll,rfIgnoreCase]);
    a:=pos('(',s);
    Edit1.Text:=copy(s,1,a-1);
    pom:=PoleToNazwa(s);
    i:=0;
    while true do
    begin
      inc(i);
      pom2:=trim(GetLineToStr(pom,i,','));
      if pom2='' then break;
      awejscie.Append;
      awejscie.FieldByName('nazwa').AsString:=GetLineToStr(pom2,2,' ');
      awejscie.FieldByName('oper').AsString:=upcase(GetLineToStr(pom2,1,' '));
      awejscie.FieldByName('typ').AsString:=trim(upcase(GetLineToStr(pom2,3,' '))+' '+upcase(GetLineToStr(pom2,4,' ')));
      awejscie.Post;
    end;
    a:=pos('BEGIN',s);
    delete(s,1,a-1);
    //s:=StringReplace(s,'BEGIN','BEGIN'#10,[rfIgnoreCase]);
    //s:=StringReplace(s,';',';'#10,[rfReplaceAll]);
    vcreate.Lines.Clear;
    vcreate.Lines.AddText(s);
    //NormalizeCialo(vcreate.Lines);
    if vcreate.Lines[0]='BEGIN' then vcreate.Lines.Delete(0);
    if vcreate.Lines[vcreate.Lines.Count-1]='END' then vcreate.Lines.Delete(vcreate.Lines.Count-1);
  finally
    schema.Free;
  end;
  awejscie.First;
end;

end.

