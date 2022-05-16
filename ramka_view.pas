unit ramka_view;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, ComCtrls, Buttons,
  DBCtrls, DBGrids, SynEdit, SynHighlighterSQL, ZTransaction, db, ZConnection,
  ZDataset, ZSqlProcessor, Graphics;

type

  TRamkaViewOnApply = procedure(Sender: TObject; aOldTable,aNewTable: string; aOperation: integer) of object;

  { TFRamkaView }

  TFRamkaView = class(TFrame)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGrid5: TDBGrid;
    DBNavigator1: TDBNavigator;
    dsqdata: TDataSource;
    Edit1: TEdit;
    Label1: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    qdata: TZQuery;
    TabSheet2: TTabSheet;
    timer_data: TTimer;
    vcreate: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    TabSheet1: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure qdataAfterClose(DataSet: TDataSet);
    procedure timer_dataTimer(Sender: TObject);
  private
    FOnApply: TRamkaViewOnApply;
    procedure ShowCreateTable(table: string; schema: TStrings);
    procedure DataRefresh;
    procedure gen_zmiany(aScript: TStrings);
  public
    io_db: TZConnection;
    io_trans: TZTransaction;
    io_tablename: string;
    constructor Create(AOwner: TComponent); override;
    procedure load_view(aRefresh: boolean = false);
  published
    property OnApply: TRamkaViewOnApply read FOnApply write FOnApply;
  end;

implementation

uses
  serwis, ecode, updatesql;

{$R *.lfm}

{ TFRamkaView }

procedure TFRamkaView.BitBtn1Click(Sender: TObject);
begin
  load_view(true);
end;

procedure TFRamkaView.BitBtn2Click(Sender: TObject);
var
  vsql: TStrings;
begin
  vsql:=TStringList.Create;
  try
    gen_zmiany(vsql);
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
          if Assigned(FOnApply) then FOnApply(self,io_tablename,Edit1.Text,1);
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

procedure TFRamkaView.Edit1Change(Sender: TObject);
begin
  if Edit1.Text<>io_tablename then Edit1.Color:=clYellow else Edit1.Color:=clDefault;
end;

procedure TFRamkaView.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage.Tag=1 then timer_data.Enabled:=true;
end;

procedure TFRamkaView.qdataAfterClose(DataSet: TDataSet);
begin
  Panel9.Visible:=not DataSet.Active;
end;

procedure TFRamkaView.timer_dataTimer(Sender: TObject);
begin
  timer_data.Enabled:=false;
  DataRefresh;
end;

procedure TFRamkaView.ShowCreateTable(table: string; schema: TStrings);
var
  q1: TZQuery;
  s: string;
  a,b: integer;
begin
  q1:=TZQuery.Create(self);
  q1.Connection:=io_db;
  q1.SQL.Add('show create table '+table);
  try
    try
      q1.Open;
      if q1.IsEmpty then s:='' else s:=q1.Fields[1].AsString;
    except
      s:='';
    end;
    q1.Close;
    if s='' then
    begin
      schema.Clear;
      exit;
    end;
    s:=StringReplace(s,'`','',[rfReplaceAll]);
    s:=StringReplace(s,'int(10)','int',[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'int(11)','int',[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'tinyint(4)','tinyint',[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'tinyint(5)','tinyint',[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'smallint(5)','smallint',[rfReplaceAll,rfIgnoreCase]);
    s:=StringReplace(s,'smallint(6)','smallint',[rfReplaceAll,rfIgnoreCase]);
  //  s:=StringReplace(s,'null default null','null',[rfReplaceAll,rfIgnoreCase]);
  //  s:=StringReplace(s,'default null','null',[rfReplaceAll,rfIgnoreCase]);
    a:=pos('CREATE ALGORITHM=',s);
    if a>0 then
    begin
      b:=pos(' VIEW ',s);
      delete(s,a+6,b-a-6);
    end;
    StrToListItems(s,schema);
    if pos(') ENGINE=',schema[schema.Count-1])>0 then
    begin
      schema.Delete(schema.Count-1);
      schema.Add(')');
    end;
  finally
    q1.Free;
  end;
end;

procedure TFRamkaView.DataRefresh;
begin
  qdata.Connection:=io_db;
  if not qdata.Active then
  begin
    qdata.SQL.Clear;
    qdata.SQL.Add('select * from '+io_tablename);
    qdata.Open;
  end;
end;

procedure TFRamkaView.gen_zmiany(aScript: TStrings);
var
  a: integer;
  s: string;
begin
  if io_tablename<>Edit1.Text then aScript.Add('DROP VIEW '+io_tablename+';');
  aScript.Add('CREATE OR REPLACE VIEW '+Edit1.Text+' AS');
  aScript.AddText(vcreate.Text);
  a:=aScript.Count-1;
  s:=aScript[a];
  if s[length(s)]<>';' then
  begin
    aScript.Delete(a);
    s:=s+';';
    aScript.Add(s);
  end;
end;

constructor TFRamkaView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  PageControl1.ActivePageIndex:=0;
end;

procedure TFRamkaView.load_view(aRefresh: boolean);
var
  schema: TStrings;
  s: string;
  a: integer;
begin
  schema:=TStringList.Create;
  try
    (* wczytanie struktury *)
    ShowCreateTable(io_tablename,schema);
    s:=schema.Text;
    a:=pos('AS SELECT',upcase(s));
    if a>0 then delete(s,1,a+2);
    s:=StringReplace(s,' AS ',' as ',[rfReplaceAll]);
    s:=StringReplace(s,',',','#10'    ',[rfReplaceAll]);
    s:=StringReplace(s,' from',#10'from',[rfReplaceAll]);
    s:=StringReplace(s,'on(','on (',[rfReplaceAll]);
    while pos('from (',s)>0 do s:=UsunJedenPoziomNawiasow(s);
    s:=UsunJedenPoziomNawiasow(s);
    s:=StringReplace(s,' join',#10'join',[rfReplaceAll]);
    s:=StringReplace(s,' order',#10'order',[rfReplaceAll]);
    vcreate.Clear;
    vcreate.Lines.AddText(s);
  finally
    schema.Free;
  end;
  Edit1.Text:=io_tablename;
  Edit1Change(nil);
end;

end.

