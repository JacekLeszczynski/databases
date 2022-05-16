unit ramka_table;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, memds, db, Forms, Controls, ComCtrls, ExtCtrls, Buttons,
  StdCtrls, DBGrids, CheckLst, DBCtrls, Spin, SynEdit, SynHighlighterSQL,
  ZTransaction, ExtMessage, DBGridPlus, ZConnection, ZDataset, ZSqlProcessor,
  Types;

type

  TRamkaTableOnApply = procedure(Sender: TObject; aOldTable,aNewTable: string; aOperation: integer) of object;

  { TFRamkaTable }

  TFRamkaTable = class(TFrame)
    apola: TCheckListBox;
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    DBGrid1: TDBGridPlus;
    DBGrid2: TDBGridPlus;
    DBGrid3: TDBGridPlus;
    dsqdata: TDataSource;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    DBNavigator1: TDBNavigator;
    ds_mem1: TDataSource;
    ds_mem3: TDataSource;
    ds_mem5: TDataSource;
    ds_mem7: TDataSource;
    Edit1: TEdit;
    im_button: TImageList;
    Label2: TLabel;
    list_tables: TZQuery;
    mem3: TMemDataset;
    mem4: TMemDataset;
    mem5: TMemDataset;
    mem6: TMemDataset;
    mem7: TMemDataset;
    mem8: TMemDataset;
    mess: TExtMessage;
    Label1: TLabel;
    mem1: TMemDataset;
    mem2: TMemDataset;
    PageControl2: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    script: TZSQLProcessor;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpinEdit1: TSpinEdit;
    Splitter1: TSplitter;
    TabSheet5: TTabSheet;
    timer_data: TTimer;
    trigger: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    qdata: TZQuery;
    procedure apolaClickCheck(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1SelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure DBGrid3CellClick(Column: TColumn);
    procedure DBGrid3EditingDone(Sender: TObject);
    procedure DBGrid3SelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure Edit1Change(Sender: TObject);
    procedure mem1AfterClose(DataSet: TDataSet);
    procedure mem1AfterDelete(DataSet: TDataSet);
    procedure mem1AfterInsert(DataSet: TDataSet);
    procedure mem1AfterOpen(DataSet: TDataSet);
    procedure mem1AfterPost(DataSet: TDataSet);
    procedure mem1BeforeDelete(DataSet: TDataSet);
    procedure mem1BeforeEdit(DataSet: TDataSet);
    procedure mem3AfterInsert(DataSet: TDataSet);
    procedure mem3AfterScroll(DataSet: TDataSet);
    procedure mem3BeforePost(DataSet: TDataSet);
    procedure mem5AfterInsert(DataSet: TDataSet);
    procedure mem5AfterScroll(DataSet: TDataSet);
    procedure mem5BeforePost(DataSet: TDataSet);
    procedure mem7AfterInsert(DataSet: TDataSet);
    procedure mem7AfterScroll(DataSet: TDataSet);
    procedure mem7BeforePost(DataSet: TDataSet);
    procedure PageControl2Change(Sender: TObject);
    procedure qdataAfterInsert(DataSet: TDataSet);
    procedure qdataAfterOpen(DataSet: TDataSet);
    procedure qdataAfterRefresh(DataSet: TDataSet);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure timer_dataTimer(Sender: TObject);
    procedure triggerExit(Sender: TObject);
    procedure _BEFORE_CLOSE(DataSet: TDataSet);
    procedure mem1BeforePost(DataSet: TDataSet);
  private
    FOnAfterClose: TNotifyEvent;
    FOnAfterOpen: TNotifyEvent;
    FOnApply: TRamkaTableOnApply;
    FOnRefresh: TNotifyEvent;
    V_KOLUMNA,V_KOLUMNA2: string;
    oldstatus,oldpole,oldorigin: string;
    procedure init;
    procedure mem1test;
    procedure warunki(kolumna: string = '');
    procedure kopia_mem1;
    procedure kopia_mem3;
    procedure kopia_mem5;
    procedure kopia_mem7;
    procedure gen_create(var aCreate: TStrings; aMem2: boolean = false);
    procedure stworz_tabele(aScript: TStrings);
    procedure gen_zmiany(aScript: TStrings);
    procedure ShowCreateTable(table: string; schema: TStrings);
    procedure ShowTablePool(table: string; aPool: TStrings);
    function GetPrimaryKey(aMem2: boolean = false): string;
    function GetIndexList(aStr: string): string;
    function GetOnDelete(aStr: string): string;
    function GetOnUpdate(aStr: string): string;
    procedure pola_indeksy_obce(aRodzaj: integer = 0; aValue: string = '');
    function PoleToIndexPola(aValue: string): integer;
    function PolaToStr: string;
    procedure sync_delete(aScript: TStrings);
    procedure sync_table(aScript: TStrings);
    procedure sync_event(aScript: TStrings);
    function TestPol(aValue: string): string;
    procedure DataRefresh;
    procedure GetAutoIncrement;
  public
    V_NOTEST: boolean;
    io_db: TZConnection;
    io_trans: TZTransaction;
    io_tablename: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure new_table;
    procedure load_table(aRefresh: boolean = false);
  published
    property OnRefresh: TNotifyEvent read FOnRefresh write FOnRefresh;
    property OnApply: TRamkaTableOnApply read FOnApply write FOnApply;
    property OnAfterOpen: TNotifyEvent read FOnAfterOpen write FOnAfterOpen;
    property OnAfterClose: TNotifyEvent read FOnAfterClose write FOnAfterClose;
  end;

implementation

uses
  ecode, serwis, LCLType, Graphics, updatesql;

{$R *.lfm}

{ TFRamkaTable }

procedure TFRamkaTable.BitBtn4Click(Sender: TObject);
begin
  mem1.Append;
end;

procedure TFRamkaTable.BitBtn7Click(Sender: TObject);
begin
  if mem3.FieldByName('status').AsString='N' then mem3.Delete else
  begin
    mem3.Edit;
    if mem3.FieldByName('status').AsString='D' then mem3.FieldByName('status').Clear else mem3.FieldByName('status').AsString:='D';
    mem3.Post;
  end;
end;

procedure TFRamkaTable.BitBtn8Click(Sender: TObject);
begin
  mem3.Append;
end;

procedure TFRamkaTable.DBGrid1CellClick(Column: TColumn);
begin
  V_KOLUMNA:=Column.FieldName;
end;

procedure TFRamkaTable.DBGrid1SelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
begin
  V_KOLUMNA:=Column.FieldName;
end;

procedure TFRamkaTable.DBGrid3CellClick(Column: TColumn);
begin
  V_KOLUMNA2:=Column.FieldName;
end;

procedure TFRamkaTable.DBGrid3EditingDone(Sender: TObject);
begin
  if V_KOLUMNA2='table' then pola_indeksy_obce(1,mem5.FieldByName('table').AsString);
end;

procedure TFRamkaTable.DBGrid3SelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
begin
  V_KOLUMNA2:=Column.FieldName;
end;

procedure TFRamkaTable.Edit1Change(Sender: TObject);
begin
  if Edit1.Text<>io_tablename then Edit1.Color:=clYellow else Edit1.Color:=clDefault;
end;

procedure TFRamkaTable.mem1AfterClose(DataSet: TDataSet);
begin
  Mem2.Close;
  Mem3.Close;
  Mem4.Close;
  Mem5.Close;
  Mem6.Close;
  Mem7.Close;
  Mem8.Close;
  Edit1.Text:='';
  if Assigned(FOnAfterClose) then FOnAfterClose(self);
end;

procedure TFRamkaTable.mem1AfterDelete(DataSet: TDataSet);
var
  i: integer;
begin
  i:=PoleToIndexPola(oldpole);
  if i>-1 then apola.Items.Delete(i);
end;

procedure TFRamkaTable.mem1AfterInsert(DataSet: TDataSet);
begin
  mem1.FieldByName('status').AsString:='N';
  mem1.FieldByName('ai').AsBoolean:=false;
  mem1.FieldByName('pk').AsBoolean:=false;
  mem1.FieldByName('unsigned').AsBoolean:=false;
  mem1.FieldByName('notnull').AsBoolean:=false;
end;

procedure TFRamkaTable.mem1AfterOpen(DataSet: TDataSet);
begin
  Mem2.Open;
  Mem3.Open;
  Mem4.Open;
  Mem5.Open;
  Mem6.Open;
  Mem7.Open;
  Mem8.Open;
  Edit1.Text:=io_tablename;
  if Assigned(FOnAfterOpen) then FOnAfterOpen(self);
end;

procedure TFRamkaTable.mem1AfterPost(DataSet: TDataSet);
var
  status,pole,origin: string;
  i: integer;
begin
  status:=mem1.FieldByName('status').AsString;
  pole:=mem1.FieldByName('pole').AsString;
  origin:=mem1.FieldByName('origin').AsString;
  if status='N' then apola.Items.Add(pole) else
  if status='D' then
  begin
    i:=PoleToIndexPola(origin);
    apola.Items.Delete(i);
  end else
  if (status='') and (oldstatus='D') then
  begin
    i:=PoleToIndexPola(origin);
    if i=-1 then apola.Items.Add(origin);
  end else
  if (status='E') or ((status='') and (oldstatus='E')) then
  begin
    i:=PoleToIndexPola(origin);
    if i>-1 then apola.Items.Delete(i);
    if pole=origin then apola.Items.Insert(i,origin) else apola.Items.Insert(i,origin+' ('+pole+')');
    mem3AfterScroll(mem3);
  end;
end;

procedure TFRamkaTable.mem1BeforeDelete(DataSet: TDataSet);
begin
  oldstatus:=mem1.FieldByName('status').AsString;
  oldpole:=mem1.FieldByName('pole').AsString;
  oldorigin:=mem1.FieldByName('origin').AsString;
end;

procedure TFRamkaTable.mem1BeforeEdit(DataSet: TDataSet);
begin
  oldstatus:=mem1.FieldByName('status').AsString;
  oldpole:=mem1.FieldByName('pole').AsString;
  oldorigin:=mem1.FieldByName('origin').AsString;
end;

procedure TFRamkaTable.mem3AfterInsert(DataSet: TDataSet);
begin
  mem3.FieldByName('status').AsString:='N';
  mem3.FieldByName('nazwa').AsString:='idx_'+Edit1.Text+'_';
  mem3.FieldByName('rodzaj').AsString:='INDEX';
end;

procedure TFRamkaTable.mem3AfterScroll(DataSet: TDataSet);
var
  s,s1: string;
  i,a: integer;
begin
  i:=0;
  apola.CheckAll(cbUnchecked);
  s:=mem3.FieldByName('pola').AsString;
  while true do
  begin
    inc(i);
    s1:=GetLineToStr(s,i,',');
    if s1='' then break;
    a:=PoleToIndexPola(s1);
    if a>-1 then apola.Checked[a]:=true;
  end;
end;

procedure TFRamkaTable.mem3BeforePost(DataSet: TDataSet);
var
  b,b1,b2,b3: boolean;
  origin: string;
begin
  origin:=mem3.FieldByName('origin').AsString;
  mem4.First;
  b:=mem4.Locate('nazwa',origin,[loCaseInsensitive]);
  if b then
  begin
    if mem3.FieldByName('status').AsString='D' then exit;
    b1:=mem3.FieldByName('nazwa').AsString=mem4.FieldByName('nazwa').AsString;
    b2:=mem3.FieldByName('rodzaj').AsString=mem4.FieldByName('rodzaj').AsString;
    b3:=mem3.FieldByName('pola').AsString=mem4.FieldByName('pola').AsString;
    if b1 and b2 and b3 then mem3.FieldByName('status').Clear else
    if mem3.FieldByName('pola').AsString='' then mem3.FieldByName('status').AsString:='d' else mem3.FieldByName('status').AsString:='E';
  end;
end;

procedure TFRamkaTable.mem5AfterInsert(DataSet: TDataSet);
begin
  mem5.FieldByName('status').AsString:='N';
  mem5.FieldByName('nazwa').AsString:='fk_'+Edit1.Text+'_';
  mem5.FieldByName('ondelete').AsString:='NO ACTION';
  mem5.FieldByName('onupdate').AsString:='NO ACTION';
end;

procedure TFRamkaTable.mem5AfterScroll(DataSet: TDataSet);
begin
  (* klucze tabeli *)
  DBGrid3.Columns[3].PickList.Clear;
  ShowTablePool(mem5.FieldByName('table').AsString,DBGrid3.Columns[3].PickList);
end;

procedure TFRamkaTable.mem5BeforePost(DataSet: TDataSet);
var
  b,b1,b2,b3,b4,b5,b6: boolean;
  origin: string;
begin
  origin:=mem5.FieldByName('origin').AsString;
  mem6.First;
  b:=mem6.Locate('nazwa',origin,[loCaseInsensitive]);
  if b then
  begin
    if mem5.FieldByName('status').AsString='D' then exit;
    b1:=mem5.FieldByName('nazwa').AsString=mem6.FieldByName('nazwa').AsString;
    b2:=mem5.FieldByName('keys').AsString=mem6.FieldByName('keys').AsString;
    b3:=mem5.FieldByName('table').AsString=mem6.FieldByName('table').AsString;
    b4:=mem5.FieldByName('table_keys').AsString=mem6.FieldByName('table_keys').AsString;
    b5:=mem5.FieldByName('ondelete').AsString=mem6.FieldByName('ondelete').AsString;
    b6:=mem5.FieldByName('onupdate').AsString=mem6.FieldByName('onupdate').AsString;
    if b1 and b2 and b3 and b4 and b5 and b6 then mem5.FieldByName('status').Clear else
    mem5.FieldByName('status').AsString:='E';
  end;
end;

procedure TFRamkaTable.mem7AfterInsert(DataSet: TDataSet);
begin
  mem7.FieldByName('status').AsString:='N';
  mem7.FieldByName('nazwa').AsString:='tr_'+Edit1.Text+'_';
end;

procedure TFRamkaTable.mem7AfterScroll(DataSet: TDataSet);
begin
  trigger.Clear;
  trigger.Lines.AddText(mem7.FieldByName('cialo').AsString);
end;

procedure TFRamkaTable.mem7BeforePost(DataSet: TDataSet);
var
  b,b1,b2,b3,b4: boolean;
  origin: string;
begin
  origin:=mem7.FieldByName('origin').AsString;
  mem8.First;
  b:=mem8.Locate('nazwa',origin,[loCaseInsensitive]);
  if b then
  begin
    if mem7.FieldByName('status').AsString='D' then exit;
    b1:=mem7.FieldByName('nazwa').AsString=mem8.FieldByName('nazwa').AsString;
    b2:=mem7.FieldByName('zdarzenie').AsString=mem8.FieldByName('zdarzenie').AsString;
    b3:=mem7.FieldByName('wykonanie').AsString=mem8.FieldByName('wykonanie').AsString;
    b4:=mem7.FieldByName('cialo').AsString=mem8.FieldByName('cialo').AsString;
    if b1 and b2 and b3 and b4 then mem7.FieldByName('status').Clear else
    mem7.FieldByName('status').AsString:='E';
  end;
end;

procedure TFRamkaTable.PageControl2Change(Sender: TObject);
begin
  if PageControl2.ActivePage.Tag=1 then timer_data.Enabled:=true else init;
end;

procedure TFRamkaTable.qdataAfterInsert(DataSet: TDataSet);
begin
  GetAutoIncrement;
end;

procedure TFRamkaTable.qdataAfterOpen(DataSet: TDataSet);
var
  i: integer;
begin
  Panel9.Visible:=not DataSet.Active;
  if DataSet.Active then for i:=0 to DBGrid5.Columns.Count-1 do
  begin
    case DBGrid5.Columns[i].Field.DataType of
      ftDate: DBGrid5.Columns[i].DisplayFormat:='yyyy-mm-dd';
      ftTime: DBGrid5.Columns[i].DisplayFormat:='hh:nn:ss';
      ftDateTime: DBGrid5.Columns[i].DisplayFormat:='yyyy-mm-dd hh:nn:ss';
      else DBGrid5.Columns[i].DisplayFormat:='';
    end;
    case DBGrid5.Columns[i].Field.DataType of
      ftDate,ftTime,ftDateTime,ftTimeStamp: DBGrid5.Columns[i].Font.Name:='Droid Sans Mono';
      ftSmallint,ftInteger,ftWord,ftLargeint: DBGrid5.Columns[i].Font.Name:='Droid Sans Mono';
      ftFloat,ftCurrency: DBGrid5.Columns[i].Font.Name:='Droid Sans Mono';
      else DBGrid5.Columns[i].Font.Name:='Droid Sans';
    end;
    case DBGrid5.Columns[i].Field.DataType of
      ftDate,ftTime,ftDateTime,ftTimeStamp: DBGrid5.Columns[i].Font.Size:=9;
      ftSmallint,ftInteger,ftWord,ftLargeint: DBGrid5.Columns[i].Font.Size:=9;
      ftFloat,ftCurrency: DBGrid5.Columns[i].Font.Size:=9;
      else DBGrid5.Columns[i].Font.Size:=10;
    end;
  end;
  if DataSet.Active then GetAutoIncrement;
end;

procedure TFRamkaTable.qdataAfterRefresh(DataSet: TDataSet);
begin
  GetAutoIncrement;
end;

procedure TFRamkaTable.SpeedButton1Click(Sender: TObject);
begin
  io_trans.StartTransaction;
  SpeedButton1.Enabled:=not io_db.InTransaction;
  SpeedButton2.Enabled:=not SpeedButton1.Enabled;
  SpeedButton3.Enabled:=not SpeedButton1.Enabled;
  SpeedButton4.Enabled:=false;
end;

procedure TFRamkaTable.SpeedButton2Click(Sender: TObject);
begin
  io_trans.Commit;
  SpeedButton1.Enabled:=not io_db.InTransaction;
  SpeedButton2.Enabled:=not SpeedButton1.Enabled;
  SpeedButton3.Enabled:=not SpeedButton1.Enabled;
  SpeedButton4.Enabled:=true;
end;

procedure TFRamkaTable.SpeedButton3Click(Sender: TObject);
begin
  io_trans.Rollback;
  qdata.Refresh;
  SpeedButton1.Enabled:=not io_db.InTransaction;
  SpeedButton2.Enabled:=not SpeedButton1.Enabled;
  SpeedButton3.Enabled:=not SpeedButton1.Enabled;
  SpeedButton4.Enabled:=true;
end;

procedure TFRamkaTable.SpeedButton4Click(Sender: TObject);
var
  q: TZQuery;
begin
  q:=TZQuery.Create(self);
  q.Connection:=qdata.Connection;
  q.SQL.Add('ALTER TABLE '+io_tablename+' AUTO_INCREMENT=:ai');
  q.ParamByName('ai').AsLargeInt:=SpinEdit1.Value;
  try
    try
      q.ExecSQL;
    except
      mess.ShowInformation('Ustawienie odrzucone z powodu błędu.');
      GetAutoIncrement;
    end;
  finally
    q.Free;
  end;
end;

procedure TFRamkaTable.timer_dataTimer(Sender: TObject);
begin
  timer_data.Enabled:=false;
  DataRefresh;
end;

procedure TFRamkaTable.triggerExit(Sender: TObject);
begin
  if mem7.FieldByName('cialo').AsString<>trigger.Lines.Text then
  begin
    mem7.Edit;
    mem7.FieldByName('cialo').AsString:=trigger.Lines.Text;
    mem7.Post;
    writeln('zmiany zapisane');
  end;
end;

procedure TFRamkaTable._BEFORE_CLOSE(DataSet: TDataSet);
begin
  while not Dataset.IsEmpty do Dataset.Delete;
end;

procedure TFRamkaTable.mem1BeforePost(DataSet: TDataSet);
begin
  if Mem1.FieldByName('typ').AsString='CHAR' then Mem1.FieldByName('typ').AsString:='CHAR(45)' else
  if Mem1.FieldByName('typ').AsString='VARCHAR' then Mem1.FieldByName('typ').AsString:='VARCHAR(45)';
  warunki;
  if mem2.Active then mem1test;
end;

procedure TFRamkaTable.init;
begin

end;

procedure TFRamkaTable.mem1test;
var
  pole: string;
  i: integer;
begin
  if V_NOTEST then exit;
  pole:=mem1.FieldByName('origin').AsString;
  mem2.First;
  if mem2.Locate('pole',pole,[]) then
  begin
    if mem1.FieldByName('status').AsString='D' then exit;
    mem1.FieldByName('status').AsString:='';
    for i:=0 to mem2.Fields.Count-1 do
    begin
      if mem2.Fields[i].Value<>mem1.FieldByName(mem2.Fields[i].FieldName).Value then
      begin
        mem1.FieldByName('status').AsString:='E';
        break;
      end;
    end;
  end else begin
    mem1.FieldByName('status').AsString:='N';
  end;
end;

procedure TFRamkaTable.warunki(kolumna: string);
var
  tint: boolean;
begin
  tint:=mem1.FieldByName('typ').AsString='INT';
  if kolumna='' then kolumna:=V_KOLUMNA;
  (* kolumna jest znana *)
  if (kolumna='ai') and mem1.FieldByName('ai').AsBoolean then
  begin
    if not tint then mem1.FieldByName('ai').AsBoolean:=false else
    begin
      mem1.FieldByName('pk').AsBoolean:=true;
      mem1.FieldByName('notnull').AsBoolean:=true;
    end;
  end else
  if (kolumna='pk') and (not mem1.FieldByName('pk').AsBoolean) then
  begin
    mem1.FieldByName('ai').AsBoolean:=false;
  end else
  if (kolumna='unsigned') and mem1.FieldByName('unsigned').AsBoolean then
  begin
    if not tint then mem1.FieldByName('unsigned').AsBoolean:=false;
  end;
  (* ogólna zasada *)
  if not tint then
  begin
    mem1.FieldByName('ai').AsBoolean:=false;
    mem1.FieldByName('unsigned').AsBoolean:=false;
    mem1test;
  end;
  {if kolumna='typ' then
  begin
    if not tint then
    begin
      mem1.FieldByName('ai').AsBoolean:=false;
      mem1.FieldByName('unsigned').AsBoolean:=false;
      mem1test;
    end;
  end;}
end;

procedure TFRamkaTable.kopia_mem1;
var
  i: integer;
begin
  if not mem2.Active then mem2.Open;
  while not mem2.IsEmpty do mem2.Delete;
  mem1.First;
  while not mem1.EOF do
  begin
    mem2.Append;
    for i:=0 to mem2.Fields.Count-1 do mem2.Fields[i].Value:=mem1.FieldByName(mem2.Fields[i].FieldName).Value;
    mem2.Post;
    mem1.Next;
  end;
end;

procedure TFRamkaTable.kopia_mem3;
var
  i: integer;
begin
  if not mem4.Active then mem4.Open;
  while not mem4.IsEmpty do mem4.Delete;
  mem3.First;
  while not mem3.EOF do
  begin
    mem4.Append;
    for i:=0 to mem4.Fields.Count-1 do mem4.Fields[i].Value:=mem3.FieldByName(mem4.Fields[i].FieldName).Value;
    mem4.Post;
    mem3.Next;
  end;
end;

procedure TFRamkaTable.kopia_mem5;
var
  i: integer;
begin
  if not mem6.Active then mem6.Open;
  while not mem6.IsEmpty do mem6.Delete;
  mem5.First;
  while not mem5.EOF do
  begin
    mem6.Append;
    for i:=0 to mem6.Fields.Count-1 do mem6.Fields[i].Value:=mem5.FieldByName(mem6.Fields[i].FieldName).Value;
    mem6.Post;
    mem5.Next;
  end;
end;

procedure TFRamkaTable.kopia_mem7;
var
  i: integer;
begin
  if not mem8.Active then mem8.Open;
  while not mem8.IsEmpty do mem8.Delete;
  mem7.First;
  while not mem7.EOF do
  begin
    mem8.Append;
    for i:=0 to mem8.Fields.Count-1 do mem8.Fields[i].Value:=mem7.FieldByName(mem8.Fields[i].FieldName).Value;
    mem8.Post;
    mem7.Next;
  end;
end;

procedure TFRamkaTable.gen_create(var aCreate: TStrings; aMem2: boolean);
var
  x,x2,x3,x4: TBookmark;
  i: integer;
  tabelka,s,s_unsigned,s_notnull,s_ai,s_default,indeks: string;
  mem,idx,fk,trig: TMemDataset;
begin
  if aMem2 then
  begin
    mem:=mem2;
    idx:=mem4;
    fk:=mem6;
    trig:=mem8;
  end else begin
    mem:=mem1;
    idx:=mem3;
    fk:=mem5;
    trig:=mem7;
  end;
  tabelka:=Edit1.Text;
  mem.DisableControls;
  idx.DisableControls;
  fk.DisableControls;
  trig.DisableControls;
  x:=mem.GetBookmark;
  x2:=idx.GetBookmark;
  x3:=fk.GetBookmark;
  x4:=trig.GetBookmark;
  try
    aCreate.Clear;
    aCreate.Add('CREATE TABLE '+tabelka+' (');
    (* pola *)
    mem.First;
    while not mem1.EOF do
    begin
      if mem.FieldByName('unsigned').AsBoolean then s_unsigned:=' unsigned' else s_unsigned:='';
      if mem.FieldByName('notnull').AsBoolean then s_notnull:=' NOT NULL' else s_notnull:=' NULL';
      if mem.FieldByName('ai').AsBoolean then s_ai:=' AUTO_INCREMENT' else s_ai:='';
      if mem.FieldByName('default').AsString='' then s_default:='' else s_default:=' DEFAULT '+mem.FieldByName('default').AsString;
      aCreate.Add('  '+mem1.FieldByName('pole').AsString+' '+mem1.FieldByName('typ').AsString+s_unsigned+s_notnull+s_ai+s_default+',');
      mem1.Next;
    end;
    (* indeksy *)
    idx.First;
    while not idx.EOF do
    begin
      if idx.FieldByName('pola').AsString='' then continue;
      if idx.FieldByName('rodzaj').AsString='INDEX' then
        indeks:='KEY '+idx.FieldByName('nazwa').AsString+' ('+idx.FieldByName('pola').AsString+'),' else
      if idx.FieldByName('rodzaj').AsString='UNIQUE' then
        indeks:='UNIQUE KEY '+idx.FieldByName('nazwa').AsString+' ('+idx.FieldByName('pola').AsString+'),' else
      if idx.FieldByName('rodzaj').AsString='FULLTEXT' then
        indeks:='FULLTEXT KEY '+idx.FieldByName('nazwa').AsString+' ('+idx.FieldByName('pola').AsString+'),';
      aCreate.Add('  '+indeks);
      idx.Next;
    end;
    (* primary key *)
    s:=GetPrimaryKey;
    if s<>'' then aCreate.Add('PRIMARY KEY ('+s+'),');
    (* indeksy obce *)
    fk.First;
    while not fk.EOF do
    begin
      indeks:='CONSTRAINT '+fk.FieldByName('nazwa').AsString+' FOREIGN KEY ('+fk.FieldByName('keys').AsString+') REFERENCES '+fk.FieldByName('table').AsString+' ('+fk.FieldByName('table_keys').AsString+') ON DELETE '+fk.FieldByName('ondelete').AsString+' ON UPDATE '+fk.FieldByName('onupdate').AsString+',';
      aCreate.Add('  '+indeks);
      fk.Next;
    end;
    (* usuwam ostatni przecinek *)
    i:=aCreate.Count-1;
    s:=aCreate[i];
    delete(s,length(s),1);
    aCreate.Delete(i);
    aCreate.Add(s);
    (* kończę zapytanie nawiasem zamykającym *)
    aCreate.Add(');');
    (* wyzwalacze *)
    if not trig.IsEmpty then aCreate.Add('');
    trig.First;
    while not trig.EOF do
    begin
      aCreate.Add('CREATE TRIGGER '+trig.FieldByName('nazwa').AsString+' '+trig.FieldByName('wykonanie').AsString+' '+trig.FieldByName('zdarzenie').AsString+' ON '+Edit1.Text+' FOR EACH ROW');
      aCreate.Add(trig.FieldByName('cialo').AsString+';');
      trig.Next;
    end;
  finally
    try mem.GotoBookmark(x); except end;
    mem.EnableControls;
    try idx.GotoBookmark(x2); except end;
    idx.EnableControls;
    try fk.GotoBookmark(x3); except end;
    fk.EnableControls;
    try trig.GotoBookmark(x3); except end;
    trig.EnableControls;
  end;
end;

procedure TFRamkaTable.stworz_tabele(aScript: TStrings);
begin
  if mem1.IsEmpty then exit;
  gen_create(aScript);
end;

procedure TFRamkaTable.gen_zmiany(aScript: TStrings);
begin
  sync_delete(aScript);
  sync_table(aScript);
  sync_event(aScript);
end;

procedure TFRamkaTable.ShowCreateTable(table: string; schema: TStrings);
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

procedure TFRamkaTable.ShowTablePool(table: string; aPool: TStrings);
var
  i: integer;
  s,s1: string;
  schema: TStrings;
begin
  aPool.Clear;
  schema:=TStringList.Create;
  try
    ShowCreateTable(table,schema);
    for i:=1 to schema.Count-1 do
    begin
      s:=schema[i];
      if s=')' then continue;
      if pos('PRIMARY KEY',trim(s))=1 then continue;
      if (pos('KEY ',trim(s))=1) or (pos('UNIQUE KEY ',trim(s))=1) or (pos('FULLTEXT KEY ',trim(s))=1) then continue;
      if (pos('CONSTRAINT',trim(s))=1) and (pos('FOREIGN KEY',s)>0) then continue;
      aPool.Add(GetLineToStr(trim(s),1,' '));
    end;
  finally
    schema.Free;
  end;
end;

function TFRamkaTable.GetPrimaryKey(aMem2: boolean): string;
var
  s: string;
begin
  s:='';
  if aMem2 then
  begin
    mem2.First;
    while not mem2.EOF do
    begin
      if mem2.FieldByName('pk').AsBoolean then s:=dodaj_po_przecinku(s,mem2.FieldByName('pole').AsString);
      mem2.Next;
    end;
  end else begin
    mem1.First;
    while not mem1.EOF do
    begin
      if mem1.FieldByName('pk').AsBoolean then s:=dodaj_po_przecinku(s,mem1.FieldByName('pole').AsString);
      mem1.Next;
    end;
  end;
  result:=trim(s);
end;

function TFRamkaTable.GetIndexList(aStr: string): string;
var
  s: string;
  a: integer;
begin
  s:=aStr;
  a:=pos('(',s);
  delete(s,1,a);
  a:=pos(')',s);
  delete(s,a,maxint);
  result:=s;
end;

function TFRamkaTable.GetOnDelete(aStr: string): string;
var
  s: string;
  a,b: integer;
begin
  s:=aStr;
  a:=pos('ON DELETE ',s);
  delete(s,1,a+9);
  b:=pos('ON',s);
  if b=0 then b:=pos(',',s);
  if b>1 then delete(s,b,maxint);
  result:=trim(s);
end;

function TFRamkaTable.GetOnUpdate(aStr: string): string;
var
  s: string;
  a,b: integer;
begin
  s:=aStr;
  a:=pos('ON UPDATE ',s);
  delete(s,1,a+9);
  b:=pos('ON',s);
  if b=0 then b:=pos(',',s);
  if b>1 then delete(s,b,maxint);
  result:=trim(s);
end;

procedure TFRamkaTable.pola_indeksy_obce(aRodzaj: integer; aValue: string);
var
  s: string;
begin
  if aRodzaj=0 then
  begin
    (* klucze *)
    DBGrid3.Columns[1].PickList.Clear;
    mem1.First;
    while not mem1.EOF do
    begin
      DBGrid3.Columns[1].PickList.Add(mem1.FieldByName('pole').AsString);
      mem1.Next;
    end;
    (* tabele *)
    DBGrid3.Columns[2].PickList.Clear;
    list_tables.Connection:=io_db;
    list_tables.Open;
    while not list_tables.EOF do
    begin
      s:=list_tables.Fields[0].AsString;
      if s<>Edit1.Text then DBGrid3.Columns[2].PickList.Add(s);
      list_tables.Next;
    end;
    list_tables.Close;
    (* klucze tabeli *)
    DBGrid3.Columns[3].PickList.Clear;
    ShowTablePool(mem5.FieldByName('table').AsString,DBGrid3.Columns[3].PickList);
  end;
  if aRodzaj=1 then
  begin
    DBGrid3.Columns[3].PickList.Clear;
    ShowTablePool(aValue,DBGrid3.Columns[3].PickList);
  end;
end;

function TFRamkaTable.PoleToIndexPola(aValue: string): integer;
var
  i,a: integer;
  s: string;
begin
  a:=-1;
  for i:=0 to apola.Count-1 do
  begin
    s:=apola.Items[i];
    if (pos(aValue+' ',s)=1) or (aValue=s) then
    begin
      a:=i;
      break;
    end;
  end;
  result:=a;
end;

function TFRamkaTable.PolaToStr: string;
var
  i: integer;
  s: string;
begin
  s:='';
  for i:=0 to apola.Count-1 do if apola.Checked[i] then s:=s+','+apola.Items[i];
  if s<>'' then delete(s,1,1);
  result:=s;
end;

procedure TFRamkaTable.sync_delete(aScript: TStrings);
var
  x: TBookmark;
  stat: string[1];
begin
  mem7.DisableControls;
  x:=mem7.GetBookmark;
  try
    mem7.First;
    while not mem7.EOF do
    begin
      stat:=mem7.FieldByName('status').AsString;
      if (upcase(stat)='D') or (stat='E') then aScript.Add('DROP TRIGGER IF EXISTS '+mem7.FieldByName('nazwa').AsString+';');
      mem7.Next;
    end;
  finally
    try mem7.GotoBookmark(x) except end;
    mem7.EnableControls;
  end;
end;

procedure TFRamkaTable.sync_table(aScript: TStrings);
var
  x1,x3,x5: TBookmark;
  stat: string[1];
  origin,nazwa,pom,pom2,s,s2,ip1,ip2: string;
  b,bb,b1,b2,b3,b4,b5,b6: boolean;
  s_unsigned,s_notnull,s_ai,s_default: string;
begin
  ip1:=GetPrimaryKey;
  ip2:=GetPrimaryKey(true);
  mem1.DisableControls;
  mem3.DisableControls;
  mem5.DisableControls;
  x1:=mem1.GetBookmark;
  x3:=mem3.GetBookmark;
  x5:=mem5.GetBookmark;
  try
    (* usuwam klucze obce *)
    mem5.First;
    while not mem5.EOF do
    begin
      stat:=mem5.FieldByName('status').AsString;
      if (upcase(stat)='D') or (stat='E') then aScript.Add('ALTER TABLE '+io_tablename+' DROP FOREIGN KEY '+mem5.FieldByName('origin').AsString+';');
      mem5.Next;
    end;
    (* usuwam indeksy *)
    mem3.First;
    while not mem3.EOF do
    begin
      stat:=mem3.FieldByName('status').AsString;
      if (upcase(stat)='D') or (stat='E') then aScript.Add('ALTER TABLE '+io_tablename+' DROP INDEX '+mem3.FieldByName('origin').AsString+';');
      mem3.Next;
    end;
    (* usuwam indeks pierwszy *)
    if ip1<>ip2 then aScript.Add('ALTER TABLE '+io_tablename+' DROP PRIMARY KEY;');
    (* usuwam pola tabeli *)
    mem1.First;
    while not mem1.EOF do
    begin
      stat:=mem1.FieldByName('status').AsString;
      if upcase(stat)='D' then aScript.Add('ALTER TABLE '+io_tablename+' DROP COLUMN '+mem1.FieldByName('origin').AsString+';');
      mem1.Next;
    end;
    (* dodaję nowe pola tabeli *)
    pom:='';
    mem1.First;
    while not mem1.EOF do
    begin
      stat:=mem1.FieldByName('status').AsString;
      origin:=mem1.FieldByName('origin').AsString;
      nazwa:=mem1.FieldByName('pole').AsString;
      if upcase(stat)='N' then
      begin
        if mem1.FieldByName('unsigned').AsBoolean then s_unsigned:=' unsigned' else s_unsigned:='';
        if mem1.FieldByName('notnull').AsBoolean then s_notnull:=' NOT NULL' else s_notnull:='';
        if mem1.FieldByName('ai').AsBoolean then s_ai:=' AUTO_INCREMENT' else s_ai:='';
        if mem1.FieldByName('default').AsString='' then s_default:='' else s_default:=' DEFAULT '+mem1.FieldByName('default').AsString;
        if pom='' then s:='ALTER TABLE '+io_tablename+' ADD COLUMN '+nazwa+' '+mem1.FieldByName('typ').AsString+s_unsigned+s_notnull+s_ai+s_default+' FIRST;'
                  else s:='ALTER TABLE '+io_tablename+' ADD COLUMN '+nazwa+' '+mem1.FieldByName('typ').AsString+s_unsigned+s_notnull+s_ai+s_default+' AFTER '+pom+';';
        aScript.Add(s);
      end;
      if origin='' then pom:=nazwa else pom:=origin;
      mem1.Next;
    end;
    (* aktualizuję istniejące pola tabeli *)
    pom:='';
    mem1.First;
    while not mem1.EOF do
    begin
      stat:=mem1.FieldByName('status').AsString;
      origin:=mem1.FieldByName('origin').AsString;
      nazwa:=mem1.FieldByName('pole').AsString;
      if origin=nazwa then s2:=origin else s2:=origin+' '+nazwa;
      if upcase(stat)='E' then
      begin
        mem2.First;
        b:=mem2.Locate('pole',origin,[loCaseInsensitive]);
        if b then
        begin
          b1:=mem1.FieldByName('typ').AsString=mem2.FieldByName('typ').AsString;
          b2:=mem1.FieldByName('ai').AsBoolean=mem2.FieldByName('ai').AsBoolean;
          b3:=mem1.FieldByName('unsigned').AsBoolean=mem2.FieldByName('unsigned').AsBoolean;
          b4:=mem1.FieldByName('notnull').AsBoolean=mem2.FieldByName('notnull').AsBoolean;
          b5:=mem1.FieldByName('default').AsString=mem2.FieldByName('default').AsString;
          b6:=origin=nazwa;
          bb:=b1 and b2 and b3 and b4 and b5 and b6;
          if not bb then
          begin
            if mem1.FieldByName('unsigned').AsBoolean then s_unsigned:=' unsigned' else s_unsigned:='';
            if mem1.FieldByName('notnull').AsBoolean then s_notnull:=' NOT NULL' else s_notnull:='';
            if mem1.FieldByName('ai').AsBoolean then s_ai:=' AUTO_INCREMENT' else s_ai:='';
            if mem1.FieldByName('default').AsString='' then s_default:='' else s_default:=' DEFAULT '+mem1.FieldByName('default').AsString;
            if origin<>nazwa then pom2:=' '+nazwa else pom2:='';
            if pom2='' then
            begin
              if pom='' then s:='ALTER TABLE '+io_tablename+' MODIFY COLUMN '+s2+' '+mem1.FieldByName('typ').AsString+s_unsigned+s_notnull+s_ai+s_default+' FIRST;'
                        else s:='ALTER TABLE '+io_tablename+' MODIFY COLUMN '+s2+' '+mem1.FieldByName('typ').AsString+s_unsigned+s_notnull+s_ai+s_default+' AFTER '+pom+';';
            end else begin
              if pom='' then s:='ALTER TABLE '+io_tablename+' CHANGE COLUMN '+s2+' '+mem1.FieldByName('typ').AsString+s_unsigned+s_notnull+s_ai+s_default+' FIRST;'
                        else s:='ALTER TABLE '+io_tablename+' CHANGE COLUMN '+s2+' '+mem1.FieldByName('typ').AsString+s_unsigned+s_notnull+s_ai+s_default+' AFTER '+pom+';';
            end;
            aScript.Add(s);
          end;
        end;
      end;
      if origin='' then pom:=nazwa else pom:=origin;
      mem1.Next;
    end;
    (* aktualizuję kolejność pól tabeli *)
    (* zmieniam nazwy pól jeśli się różnią *)
    {mem1.First;
    while not mem1.EOF do
    begin
      stat:=mem1.FieldByName('status').AsString;
      origin:=mem1.FieldByName('origin').AsString;
      nazwa:=mem1.FieldByName('pole').AsString;
      if (upcase(stat)='E') and (origin<>nazwa) then aScript.Add('ALTER TABLE '+io_tablename+' RENAME COLUMN '+origin+' TO '+nazwa+';');
      mem1.Next;
    end;}
    (* zmieniam nazwę tabeli jeśli jest inna *)
    if io_tablename<>Edit1.Text then aScript.Add('ALTER TABLE '+io_tablename+' RENAME TO '+Edit1.Text+';');
    (* dodaję indeks pierwszy *)
    if (ip1<>ip2) and (ip1<>'') then aScript.Add('ALTER TABLE '+Edit1.Text+' ADD PRIMARY KEY ('+ip1+');');
    (* dodaję indeksy *)
    mem3.First;
    while not mem3.EOF do
    begin
      stat:=mem3.FieldByName('status').AsString;
      pom:=mem3.FieldByName('pola').AsString;
      if (pom<>'') and ((upcase(stat)='N') or (stat='E')) then
      begin
        if mem3.FieldByName('rodzaj').AsString='INDEX' then
          aScript.Add('ALTER TABLE '+Edit1.Text+' ADD INDEX '+mem3.FieldByName('nazwa').AsString+' ('+TestPol(pom)+');') else
        if mem3.FieldByName('rodzaj').AsString='UNIQUE' then
          aScript.Add('ALTER TABLE '+Edit1.Text+' ADD UNIQUE INDEX '+mem3.FieldByName('nazwa').AsString+' ('+TestPol(pom)+');') else
        if mem3.FieldByName('rodzaj').AsString='FULLTEXT' then
          aScript.Add('ALTER TABLE '+Edit1.Text+' ADD FULLTEXT INDEX '+mem3.FieldByName('nazwa').AsString+' ('+TestPol(pom)+');');
      end;
      mem3.Next;
    end;
    (* dodaję klucze obce *)
    mem5.First;
    while not mem5.EOF do
    begin
      stat:=mem5.FieldByName('status').AsString;
      if (upcase(stat)='N') or (stat='E') then
        aScript.Add('ALTER TABLE '+Edit1.Text+' ADD CONSTRAINT '+mem5.FieldByName('nazwa').AsString+' FOREIGN KEY ('+TestPol(mem5.FieldByName('keys').AsString)+') REFERENCES '+mem5.FieldByName('table').AsString+' ('+mem5.FieldByName('table_keys').AsString+') ON DELETE '+mem5.FieldByName('ondelete').AsString+' ON UPDATE '+mem5.FieldByName('onupdate').AsString+';');
      mem5.Next;
    end;
  finally
    try mem1.GotoBookmark(x1); except end;
    mem1.EnableControls;
    try mem3.GotoBookmark(x3); except end;
    mem3.EnableControls;
    try mem5.GotoBookmark(x5); except end;
    mem5.EnableControls;
  end;
end;

procedure TFRamkaTable.sync_event(aScript: TStrings);
var
  x: TBookmark;
  stat: string[1];
  b: boolean;
  a: integer;
  s: string;
begin
  mem7.DisableControls;
  x:=mem7.GetBookmark;
  try
    b:=false;
    mem7.First;
    while not mem7.EOF do
    begin
      stat:=mem7.FieldByName('status').AsString;
      if (stat='N') or (stat='E') then
      begin
        if not b then
        begin
          aScript.Add('DELIMITER //');
          b:=true;
        end;
        aScript.Add('CREATE TRIGGER '+mem7.FieldByName('nazwa').AsString+' '+mem7.FieldByName('wykonanie').AsString+' '+mem7.FieldByName('zdarzenie').AsString+' ON '+Edit1.Text+' FOR EACH ROW');
        aScript.AddText(mem7.FieldByName('cialo').AsString);
        a:=aScript.Count-1;
        s:=aScript[a];
        aScript.Delete(a);
        aScript.Add(s+' //');
      end;
      mem7.Next;
    end;
    if b then aScript.Add('DELIMITER ;');
  finally
    try mem7.GotoBookmark(x); except end;
    mem7.EnableControls;
  end;
end;

function TFRamkaTable.TestPol(aValue: string): string;
var
  s,s1,s2: string;
  i: integer;
begin
  s:=aValue;
  i:=0;
  s2:='';
  while true do
  begin
    inc(i);
    s1:=GetLineToStr(s,i,',');
    if s1='' then break;
    s2:=s2+','+PoleToNazwa(apola.Items[PoleToIndexPola(s1)]);
  end;
  if s2<>'' then delete(s2,1,1);
  result:=s2;
end;

procedure TFRamkaTable.DataRefresh;
begin
  qdata.Connection:=io_db;
  if not qdata.Active then
  begin
    qdata.SQL.Clear;
    qdata.SQL.Add('select * from '+io_tablename);
    qdata.Open;
  end;
end;

procedure TFRamkaTable.GetAutoIncrement;
var
  q: TZQuery;
begin
  q:=TZQuery.Create(self);
  q.Connection:=io_db;
  q.SQL.Add('SELECT AUTO_INCREMENT FROM INFORMATION_SCHEMA.TABLES');
  q.SQL.Add('WHERE TABLE_SCHEMA = '''+io_db.Database+'''');
  q.SQL.Add('  AND TABLE_NAME = '''+io_tablename+'''');
  try
    try
      q.open;
      SpinEdit1.Value:=q.Fields[0].AsLargeInt;
      q.Close;
    except
      SpinEdit1.Value:=0;
    end;
  finally
    q.Free;
  end;
end;

constructor TFRamkaTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  PageControl2.ActivePageIndex:=0;
end;

destructor TFRamkaTable.Destroy;
begin
  if io_db.InTransaction then io_trans.Rollback;
  inherited Destroy;
end;

procedure TFRamkaTable.new_table;
begin
  mem1.Open;
  Edit1.SetFocus;
end;

procedure TFRamkaTable.load_table(aRefresh: boolean);
var
  q1: TZQuery;
  s,s1,s2: string;
  i,a,b: integer;
  schema: TStrings;
  x: TBookmark;
  b1,b2: boolean;
begin
  schema:=TStringList.Create;
  q1:=TZQuery.Create(self);
  q1.Connection:=io_db;
  V_NOTEST:=true;
  apola.Clear;
  try
    (* wczytanie struktury *)
    ShowCreateTable(io_tablename,schema);
    (* wczytanie kolumn *)
    mem1.DisableControls;
    if aRefresh then x:=mem1.GetBookmark;
    mem1.Close;
    mem1.Open;
    while not mem1.IsEmpty do mem1.Delete;
    for i:=1 to schema.Count-1 do
    begin
      s:=schema[i];
      if s=')' then continue;
      if pos('PRIMARY KEY',trim(s))=1 then
      begin
        s1:=trim(StringReplace(s,'PRIMARY KEY','',[]));
        s1:=trim(StringReplace(s1,'(','',[]));
        s1:=trim(StringReplace(s1,')','',[]));
        a:=0;
        while true do
        begin
          inc(a);
          s2:=trim(GetLineToStr(s1,a,','));
          if s2='' then break;
          mem1.First;
          if mem1.Locate('pole',s2,[]) then
          begin
            mem1.Edit;
            mem1.FieldByName('pk').AsBoolean:=true;
            mem1.Post;
          end;
        end;
        continue;
      end;
      if (pos('KEY ',trim(s))=1) or (pos('UNIQUE KEY ',trim(s))=1) or (pos('FULLTEXT KEY ',trim(s))=1) then
      begin
        b1:=pos('UNIQUE KEY ',trim(s))=1;
        b2:=pos('FULLTEXT KEY ',trim(s))=1;
        if b1 or b2 then s1:=GetLineToStr(trim(s),3,' ') else s1:=GetLineToStr(trim(s),2,' ');
        mem3.Append;
        mem3.FieldByName('status').AsString:='';
        mem3.FieldByName('origin').AsString:=s1;
        mem3.FieldByName('nazwa').AsString:=s1;
        if b1 then mem3.FieldByName('rodzaj').AsString:='UNIQUE' else
        if b2 then mem3.FieldByName('rodzaj').AsString:='FULLTEXT' else
        mem3.FieldByName('rodzaj').AsString:='INDEX';
        mem3.FieldByName('pola').AsString:=GetIndexList(s);
        mem3.Post;
        continue;
      end;
      if (pos('CONSTRAINT',trim(s))=1) and (pos('FOREIGN KEY',s)>0) then
      begin
        //CONSTRAINT fk_wersety_ksiega FOREIGN KEY (ksiega_id) REFERENCES ksiegi (id) ON DELETE CASCADE ON UPDATE CASCADE
        s1:=GetLineToStr(trim(s),2,' ');
        mem5.Append;
        mem5.FieldByName('status').AsString:='';
        mem5.FieldByName('origin').AsString:=s1;
        mem5.FieldByName('nazwa').AsString:=s1;
        mem5.FieldByName('keys').AsString:=GetIndexList(GetLineToStr(trim(s),5,' '));
        mem5.FieldByName('table').AsString:=GetLineToStr(trim(s),7,' ');
        mem5.FieldByName('table_keys').AsString:=GetIndexList(GetLineToStr(trim(s),8,' '));
        mem5.FieldByName('ondelete').AsString:=GetOnDelete(s);
        mem5.FieldByName('onupdate').AsString:=GetOnUpdate(s);
        mem5.Post;
        continue;
      end;
      s:=StringReplace(s,'NOT NULL','NOT_NULL',[rfReplaceAll,rfIgnoreCase]);
      s1:=GetLineToStr(trim(s),1,' ');
      apola.Items.Add(s1);
      mem1.Append;
      mem1.FieldByName('status').AsString:='';
      mem1.FieldByName('origin').AsString:=s1;
      mem1.FieldByName('pole').AsString:=s1;
      mem1.FieldByName('typ').AsString:=upcase(GetLineToStr(trim(s),2,' '));
      mem1.FieldByName('pk').AsBoolean:=false;
      mem1.FieldByName('unsigned').AsBoolean:=pos('unsigned',s)>0;
      mem1.FieldByName('ai').AsBoolean:=pos('AUTO_INCREMENT',s)>0;
      mem1.FieldByName('notnull').AsBoolean:=pos('NOT_NULL',s)>0;
      mem1.FieldByName('default').AsString:=GetDefault(s);
      mem1.Post;
    end;
    kopia_mem1;
    kopia_mem3;
    kopia_mem5;
    pola_indeksy_obce;
    (* wczytanie wyzwalaczy *)
    q1.SQL.Clear;
    q1.SQL.Add('show triggers');
    q1.Open;
    while not q1.EOF do
    begin
      if q1.FieldByName('table').AsString=io_tablename then
      begin
        mem7.Append;
        mem7.FieldByName('status').AsString:='';
        mem7.FieldByName('nazwa').AsString:=q1.FieldByName('Trigger').AsString;
        mem7.FieldByName('zdarzenie').AsString:=q1.FieldByName('Event').AsString;
        mem7.FieldByName('wykonanie').AsString:=q1.FieldByName('Timing').AsString;
        mem7.FieldByName('cialo').AsString:=q1.FieldByName('Statement').AsString;
        mem7.Post;
      end;
      q1.Next;
    end;
    q1.Close;
    kopia_mem7;
  finally
    q1.Free;
    schema.Free;
    if aRefresh then
    begin
      try mem1.GotoBookmark(x); except end;
      mem3.First;
      mem5.First;
      mem7.First;
    end else begin
      mem1.First;
      mem3.First;
      mem5.First;
      mem7.First;
    end;
    mem1.EnableControls;
    V_NOTEST:=false;
  end;
  TabSheet5.TabVisible:=io_tablename<>'';
end;

procedure TFRamkaTable.BitBtn3Click(Sender: TObject);
begin
  if mem1.IsEmpty then exit;
  if mem1.FieldByName('status').AsString='N' then
  begin
    mem1.Delete;
    exit;
  end;
  mem1.Edit;
  if mem1.FieldByName('status').AsString='D' then
    mem1.FieldByName('status').AsString:=''
  else
    mem1.FieldByName('status').AsString:='D';
  mem1.Post;
  mem1test;
end;

procedure TFRamkaTable.BitBtn1Click(Sender: TObject);
begin
  load_table(true);
  if Assigned(FOnRefresh) then FOnRefresh(self);
end;

procedure TFRamkaTable.apolaClickCheck(Sender: TObject);
begin
  mem3.Edit;
  mem3.FieldByName('pola').AsString:=PolaToStr;
  mem3.Post;
end;

procedure TFRamkaTable.BitBtn11Click(Sender: TObject);
begin
  if mem5.FieldByName('status').AsString='N' then mem5.Delete else
  begin
    mem5.Edit;
    if mem5.FieldByName('status').AsString='D' then mem5.FieldByName('status').Clear else mem5.FieldByName('status').AsString:='D';
    mem5.Post;
  end;
end;

procedure TFRamkaTable.BitBtn12Click(Sender: TObject);
begin
  mem5.Append;
end;

procedure TFRamkaTable.BitBtn15Click(Sender: TObject);
begin
  if mem7.FieldByName('status').AsString='N' then mem7.Delete else
  begin
    mem7.Edit;
    if mem7.FieldByName('status').AsString='D' then mem7.FieldByName('status').Clear else mem7.FieldByName('status').AsString:='D';
    mem7.Post;
  end;
end;

procedure TFRamkaTable.BitBtn16Click(Sender: TObject);
begin
  mem7.Append;
end;

procedure TFRamkaTable.BitBtn2Click(Sender: TObject);
var
  vsql: TStrings;
begin
  if mem1.State in [dsEdit,dsInsert] then mem1.Post;
  if mem3.State in [dsEdit,dsInsert] then mem3.Post;
  if mem5.State in [dsEdit,dsInsert] then mem5.Post;
  if mem7.State in [dsEdit,dsInsert] then mem7.Post;
  vsql:=TStringList.Create;
  try
    if io_tablename='' then stworz_tabele(vsql) else gen_zmiany(vsql);
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

end.

