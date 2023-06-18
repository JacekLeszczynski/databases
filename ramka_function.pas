unit ramka_function;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, ComCtrls, DBCtrls,
  DBGrids, Buttons, SynEdit, SynHighlighterSQL,
  ZTransaction, db, memds, ZConnection, ZDataset, ZSqlProcessor;

type

  TRamkaFunctionOnApply = procedure(Sender: TObject; aOldTable,aNewTable: string; aOperation: integer) of object;

  { TFRamkaFunction }

  TFRamkaFunction = class(TFrame)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    DBGrid1: TDBGrid;
    dswejscie: TDataSource;
    Edit1: TEdit;
    Label1: TLabel;
    awejscie: TMemDataset;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SynSQLSyn1: TSynSQLSyn;
    vcreate: TSynEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure _BEFORE_CLOSE(DataSet: TDataSet);
    procedure dswejscieStateChange(Sender: TObject);
  private
    FOnApply: TRamkaFunctionOnApply;
    procedure ShowFunction(nazwa: string; cialo: TStrings);
    function GetParameters: string;
  public
    io_db: TZConnection;
    io_trans: TZTransaction;
    io_tablename: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure new_function;
    procedure load_function;
  published
    property OnApply: TRamkaFunctionOnApply read FOnApply write FOnApply;
  end;

implementation

uses
  serwis, ecode, updatesql;

{$R *.lfm}

{ TFRamkaFunction }

procedure TFRamkaFunction.dswejscieStateChange(Sender: TObject);
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

procedure TFRamkaFunction._BEFORE_CLOSE(DataSet: TDataSet);
begin
  while not Dataset.IsEmpty do Dataset.Delete;
end;

procedure TFRamkaFunction.SpeedButton1Click(Sender: TObject);
begin
  awejscie.Append;
end;

procedure TFRamkaFunction.BitBtn1Click(Sender: TObject);
begin
  load_function;
end;

procedure TFRamkaFunction.BitBtn2Click(Sender: TObject);
var
  vsql: TStrings;
  a: integer;
  s: string;
begin
  if awejscie.State in [dsEdit,dsInsert] then awejscie.Post;
  vsql:=TStringList.Create;
  try
    //if io_tablename<>'' then vsql.Add('DROP FUNCTION '+io_tablename+';');
    vsql.Add('DELIMITER //');
    vsql.Add('CREATE OR REPLACE FUNCTION '+Edit1.Text+' ('+GetParameters+')');
    vsql.Add('RETURNS '+ComboBox1.Text);
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
          if Assigned(FOnApply) then FOnApply(self,io_tablename,Edit1.Text,3);
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

procedure TFRamkaFunction.SpeedButton2Click(Sender: TObject);
begin
  awejscie.Edit;
end;

procedure TFRamkaFunction.SpeedButton3Click(Sender: TObject);
begin
  awejscie.Delete;
end;

procedure TFRamkaFunction.SpeedButton4Click(Sender: TObject);
begin
  awejscie.Post;
end;

procedure TFRamkaFunction.SpeedButton5Click(Sender: TObject);
begin
  awejscie.Cancel;
end;

procedure TFRamkaFunction.ShowFunction(nazwa: string; cialo: TStrings);
var
  q1: TZQuery;
begin
  cialo.Clear;
  q1:=TZQuery.Create(self);
  q1.Connection:=io_db;
  q1.SQL.Add('show create function '+nazwa);
  try
    q1.Open;
    cialo.Add(NormalizeCialoFunkcji(q1.FieldByName('Create Function').AsString));
    q1.Close;
  finally
    q1.Free;
  end;
end;

function TFRamkaFunction.GetParameters: string;
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
    if s='' then s:=awejscie.FieldByName('nazwa').AsString+' '+awejscie.FieldByName('typ').AsString else
    s:=s+', '+awejscie.FieldByName('nazwa').AsString+' '+awejscie.FieldByName('typ').AsString;
    awejscie.Next;
  end;
  awejscie.GotoBookmark(x);
  awejscie.EnableControls;
  result:=s;
end;

constructor TFRamkaFunction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFRamkaFunction.Destroy;
begin
  inherited Destroy;
end;

procedure TFRamkaFunction.new_function;
begin
  //vcreate.Lines.Add('BEGIN');
  //vcreate.Lines.Add('END');
  awejscie.Open;
  Edit1.SetFocus;
end;

procedure TFRamkaFunction.load_function;
var
  schema: TStrings;
  s,pom,pom2,s1,s2: string;
  a,i: integer;
begin //[rfReplaceAll,rfIgnoreCase]
  if awejscie.Active then awejscie.Close;
  awejscie.Open;
  schema:=TStringList.Create;
  try
    ShowFunction(io_tablename,schema);
    s:=schema.Text;
    s:=trim(StringReplace(s,'CREATE FUNCTION','',[rfIgnoreCase]));
    s:=StringReplace(s,'int(10)','int',[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'int(11)','int',[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'tinyint(4)','tinyint',[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'tinyint(5)','tinyint',[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'smallint(5)','smallint',[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'smallint(6)','smallint',[rfReplaceAll,rfIgnoreCase]);
    a:=pos('(',s);
    Edit1.Text:=copy(s,1,a-1);
    pom:=PoleToNazwa(s);
    i:=0;
    while true do
    begin
      inc(i);
      pom2:=trim(GetLineToStr(pom,i,','));
      if pos('NUMERIC(',pom2)>0 then
      begin
        inc(i);
        pom2:=pom2+','+trim(GetLineToStr(pom,i,','));
      end;
      if pom2='' then break;
      awejscie.Append;
      awejscie.FieldByName('nazwa').AsString:=GetLineToStr(pom2,1,' ');
      awejscie.FieldByName('typ').AsString:=upcase(GetLineToStr(pom2,2,' '));
      awejscie.Post;
    end;
    a:=pos(' RETURNS ',s);
    delete(s,1,a+8);
    a:=pos(#10,s);
    ComboBox1.Text:=upcase(copy(s,1,a-1));
    delete(s,1,a);
    vcreate.Lines.Clear;
    vcreate.Lines.AddText(s);
    if vcreate.Lines[0]='BEGIN' then vcreate.Lines.Delete(0);
    if vcreate.Lines[vcreate.Lines.Count-1]='END' then vcreate.Lines.Delete(vcreate.Lines.Count-1);
  finally
    schema.Free;
  end;
  awejscie.First;
end;

end.

