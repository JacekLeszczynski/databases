unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, Menus, DBGrids, VirtualTrees,
  ZTransaction, ExtMessage, DBSchemaSync, db, memds, contNrs,
  ZConnection, ZDataset, ZSqlProcessor, Types, LCLType, XMLPropStorage;

type

  PTreeData = ^TTreeData;
  TTreeData = record
    nazwa: String;
    rodzic,dziecko: boolean;
    active,bold: boolean;
    data: string;
    db: TZConnection;
    trans: TZTransaction;
    schemaFile: string;
  end;

  TIdx = record
    index: integer;
    number: integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    schema: TDBSchemaSync;
    im_menu: TImageList;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    mess: TExtMessage;
    im_button: TImageList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PageControl1: TPageControl;
    PopupMenu4: TPopupMenu;
    PopupMenu5: TPopupMenu;
    PopupMenu6: TPopupMenu;
    PopupMenu7: TPopupMenu;
    TabPC: TPageControl;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    vst: TVirtualStringTree;
    script: TZSQLProcessor;
    propstorage: TXMLPropStorage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure _EDYTOR_SQL(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure _DWUKLIK_OBJEKTU(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure TabPCCloseTabClicked(Sender: TObject);
    procedure vstChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure vstFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure vstGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vstGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; const P: TPoint; var AskParent: Boolean;
      var APopupMenu: TPopupMenu);
    procedure vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure vstNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; const NewText: String);
    procedure vstNodeDblClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo
      );
    procedure vstPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
  private
    baza_db: TZConnection;
    baza_trans: TZTransaction;
    baza_nazwa: string;
    Frames: TFPObjectList;
    procedure ZakladkaFree(aTab: TTabSheet);
    procedure ZakladkiFreeAll;
    procedure TableOnApply(Sender: TObject; aOldName,aNewName: string; aOperation: integer);
    procedure ViewOnApply(Sender: TObject; aOldName,aNewName: string; aOperation: integer);
    procedure FunctionOnApply(Sender: TObject; aOldName,aNewName: string; aOperation: integer);
    procedure ProcedureOnApply(Sender: TObject; aOldName,aNewName: string; aOperation: integer);
    procedure initdb(StartNode: PVirtualNode; aCel: integer = 0);
    procedure initdb(aData: PTreeData);
    procedure BuildMem(var aMem: TMemDataset; aNo: integer);
    procedure freeall;
    procedure Add(aName,aData: string);
    function AddDziecko(aName,aData: string; StartNode: PVirtualNode = nil): PVirtualNode;
    procedure Edit(aName,aData: string);
    procedure Del;
    procedure vst_refresh;
    procedure Load;
    procedure Save;
    procedure DwuKlik(XNode: PVirtualNode; aExpanded: boolean = false);
    procedure DatabaseClose(XNode: PVirtualNode);
    function GetRodzic(StartNode: PVirtualNode): PVirtualNode;
    function GetDziecko(StartNode: PVirtualNode; aData,aNazwa: string): PVirtualNode;
    function GetDB(StartNode: PVirtualNode; var aDB: TZConnection; var aTrans: TZTransaction): boolean;
    function GetDefault(aStr: string): string;
  public
  end;

var
  Form1: TForm1;

implementation

uses
  ecode, serwis, editdb, ZCompatibility,
  ramka_table, ramka_query, ramka_view, ramka_function, ramka_procedure,
  ramka_exec;

{$R *.lfm}


var
  SQL_NO: integer = 0;

procedure StrToListItems(s:string;list:TStrings);
var
  i: integer;
  pom: string;
begin
  list.Clear;
  pom:='';
  for i:=1 to length(s) do
  begin
    if s[i]=#10 then
    begin
      list.Add(pom);
      pom:='';
      continue;
    end;
    if s[i]=#13 then continue;
    pom:=pom+s[i];
  end;
  if pom<>'' then list.Add(pom);
end;

function dodaj_po_przecinku(s,s2: string): string;
begin
  if s2='' then result:=trim(s) else
  if s='' then result:=trim(s2) else
  result:=trim(s)+','+trim(s2);
end;

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
begin
  //initdb;
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
var
  t: TTabSheet;
  r: TFRamkaFunction;
begin
  baza_nazwa:='';
  GetDB(vst.FocusedNode,baza_db,baza_trans);
  t:=TabPC.AddTabSheet;
  t.Caption:='[Nowa funkcja]';
  r:=TFRamkaFunction.Create(t);
  r.OnApply:=@FunctionOnApply;
  r.Parent:=t;
  r.Align:=alClient;
  r.io_db:=baza_db;
  r.io_trans:=baza_trans;
  r.io_tablename:=baza_nazwa;
  TabPC.ActivePage:=t;
  r.new_function;
end;

procedure TForm1.MenuItem16Click(Sender: TObject);
var
  q: TZQuery;
  Data: PTreeData;
begin
  Data:=vst.GetNodeData(vst.FocusedNode);
  if Data^.data<>'FUNCTION' then exit;
  if not mess.ShowConfirmationYesNo('Czy usunąć funkcję "'+Data^.nazwa+'"?') then exit;
  q:=TZQuery.Create(self);
  try
    GetDB(vst.FocusedNode,baza_db,baza_trans);
    q.Connection:=baza_db;
    q.SQL.Add('drop function '+Data^.nazwa);
    try
      q.ExecSQL;
      //if baza_nazwa=Data^.nazwa then FRamkaTable1.mem1.Close;
      vst.DeleteSelectedNodes;
    except
      on E: Exception do mess.ShowError('Usunięcie funkcji nie powiodło się, to komunikat błędu:^^'+E.Message);
    end;
  finally
    q.Free;
  end;
end;

procedure TForm1.MenuItem19Click(Sender: TObject);
var
  t: TTabSheet;
  r: TFRamkaProcedure;
begin
  baza_nazwa:='';
  GetDB(vst.FocusedNode,baza_db,baza_trans);
  t:=TabPC.AddTabSheet;
  t.Caption:='[Nowa procedura]';
  r:=TFRamkaProcedure.Create(t);
  r.OnApply:=@ProcedureOnApply;
  r.Parent:=t;
  r.Align:=alClient;
  r.io_db:=baza_db;
  r.io_trans:=baza_trans;
  r.io_tablename:=baza_nazwa;
  TabPC.ActivePage:=t;
  r.new_procedure;
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
var
  q: TZQuery;
  Data: PTreeData;
begin
  Data:=vst.GetNodeData(vst.FocusedNode);
  if Data^.data<>'PROCEDURE' then exit;
  if not mess.ShowConfirmationYesNo('Czy usunąć procedurę "'+Data^.nazwa+'"?') then exit;
  q:=TZQuery.Create(self);
  try
    GetDB(vst.FocusedNode,baza_db,baza_trans);
    q.Connection:=baza_db;
    q.SQL.Add('drop procedure '+Data^.nazwa);
    try
      q.ExecSQL;
      //if baza_nazwa=Data^.nazwa then FRamkaTable1.mem1.Close;
      vst.DeleteSelectedNodes;
    except
      on E: Exception do mess.ShowError('Usunięcie procedury nie powiodło się, to komunikat błędu:^^'+E.Message);
    end;
  finally
    q.Free;
  end;
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
var
  data: PTreeData;
  s,slow: string;
  i: integer;
begin
  Data:=vst.GetNodeData(vst.HotNode);
  if data^.rodzic and data^.bold then
  begin
    s:=trim(GetLineToStr(Data^.data,7,','));
    slow:=trim(GetLineToStr(Data^.data,8,','));
    slow:=StringReplace(slow,'{$1}',',',[rfReplaceAll]);
    if s='' then mess.ShowInformation('Najpierw wypełnij pole wzorca w konfiguracji bazy.') else
    begin
      schema.DB_Connection:=data^.db;
      schema.StructFileName:=s;
      schema.DictionaryTables.Clear;
      for i:=1 to GetLineCount(slow,',') do
      begin
        s:=GetLineToStr(slow,i,',');
        if s<>'' then schema.DictionaryTables.Add(s);
      end;
      schema.init;
      schema.SaveSchema;
      mess.ShowInformation('Wzorzec bazy wykonany.');
    end;
  end else mess.ShowInformation('Baza danych musi być otwarta.');
end;

procedure TForm1.MenuItem27Click(Sender: TObject);
var
  data: PTreeData;
  nazwa: string;
  t: TTabSheet;
  r: TFRamkaExec;
begin
  data:=vst.GetNodeData(vst.FocusedNode);
  nazwa:=data^.nazwa;
  GetDB(vst.FocusedNode,baza_db,baza_trans);
  t:=TabPC.AddTabSheet;
  t.Caption:=nazwa+' (EXEC)';
  t.Tag:=6;
  r:=TFRamkaExec.Create(t);
  r.io_type:=etFunction;
  r.Parent:=t;
  r.Align:=alClient;
  r.io_db:=baza_db;
  r.io_trans:=baza_trans;
  r.io_tablename:=nazwa;
  TabPC.ActivePage:=t;
  r.init;
  r.load_function;
end;

procedure TForm1.MenuItem28Click(Sender: TObject);
var
  data: PTreeData;
  nazwa: string;
  t: TTabSheet;
  r: TFRamkaExec;
begin
  data:=vst.GetNodeData(vst.FocusedNode);
  nazwa:=data^.nazwa;
  GetDB(vst.FocusedNode,baza_db,baza_trans);
  t:=TabPC.AddTabSheet;
  t.Caption:=nazwa+' (EXEC)';
  t.Tag:=6;
  r:=TFRamkaExec.Create(t);
  r.io_type:=etProcedure;
  r.Parent:=t;
  r.Align:=alClient;
  r.io_db:=baza_db;
  r.io_trans:=baza_trans;
  r.io_tablename:=nazwa;
  TabPC.ActivePage:=t;
  r.init;
  r.load_procedure;
end;

procedure TForm1._EDYTOR_SQL(Sender: TObject);
var
  t: TTabSheet;
  r: TFRamkaQuery;
begin
  inc(SQL_NO);
  GetDB(vst.FocusedNode,baza_db,baza_trans);
  t:=TabPC.AddTabSheet;
  t.Caption:='SQL ('+IntToStr(SQL_NO)+')';
  t.Tag:=2;
  r:=TFRamkaQuery.Create(t);
  r.Parent:=t;
  r.Align:=alClient;
  r.io_db:=baza_db;
  r.io_trans:=baza_trans;
  TabPC.ActivePage:=t;
  r.init;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetConfDir('database-editor');
  propstorage.FileName:=MyConfDir('config.xml');
  propstorage.Active:=true;
  Load;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ZakladkiFreeAll;
  freeall;
  Save;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
var
  protokol: string;
  host,database,user,passw: string;
  port: word;
  ok: boolean;
  s,s2: string;
  sfile,slow: string;
begin
  FEditDB:=TFEditDB.Create(self);
  try
    FEditDB.ShowModal;
    ok:=FEditDB.io_ok;
    if ok then
    begin
      case FEditDB.ComboBox1.ItemIndex of
        0: protokol:='sqlite-3';
        1: protokol:='mysql';
        2: protokol:='MariaDB-5';
        3: protokol:='MariaDB-10';
      end;
      host:=FEditDB.Edit1.Text;
      port:=FEditDB.SpinEdit1.Value;
      database:=FEditDB.Edit2.Text;
      user:=FEditDB.Edit3.Text;
      passw:=FEditDB.Edit4.Text;
      sfile:=FEditDB.FileNameEdit1.FileName;
      slow:=FEditDB.Edit5.Text;
      slow:=StringReplace(slow,',','{$1}',[rfReplaceAll]);
    end;
  finally
    FEditDB.Free;
  end;
  if ok then
  begin
    s:=protokol+','+host+':'+IntToStr(port)+' ('+database+')';
    s2:=protokol+','+host+','+IntToStr(port)+','+database+','+user+','+passw+','+sfile+','+slow;
    Add(s,s2);
  end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
var
  Data: PTreeData;
  protokol,host,database,user,passw,slow: string;
  port: word;
  ok: boolean;
  s,s2: string;
  sfile: string;
begin
  Data:=vst.GetNodeData(vst.HotNode);
  FEditDB:=TFEditDB.Create(self);
  try
    protokol:=GetLineToStr(Data^.data,1,',');
    if protokol='sqlite-3' then FEditDB.ComboBox1.ItemIndex:=0 else
    if protokol='mysql' then FEditDB.ComboBox1.ItemIndex:=1 else
    if protokol='MariaDB-5' then FEditDB.ComboBox1.ItemIndex:=2 else
    if protokol='MariaDB-10' then FEditDB.ComboBox1.ItemIndex:=3;
    FEditDB.Edit1.Text:=GetLineToStr(Data^.data,2,',');
    FEditDB.SpinEdit1.Value:=StrToInt(GetLineToStr(Data^.data,3,','));
    FEditDB.Edit2.Text:=GetLineToStr(Data^.data,4,',');
    FEditDB.Edit3.Text:=GetLineToStr(Data^.data,5,',');
    FEditDB.Edit4.Text:=GetLineToStr(Data^.data,6,',');
    FEditDB.FileNameEdit1.FileName:=GetLineToStr(Data^.data,7,',');
    slow:=trim(GetLineToStr(Data^.data,8,','));
    slow:=StringReplace(slow,'{$1}',',',[rfReplaceAll]);
    FEditDB.Edit5.Text:=slow;
    FEditDB.ShowModal;
    ok:=FEditDB.io_ok;
    if ok then
    begin
      case FEditDB.ComboBox1.ItemIndex of
        0: protokol:='sqlite-3';
        1: protokol:='mysql';
        2: protokol:='MariaDB-5';
        3: protokol:='MariaDB-10';
      end;
      host:=FEditDB.Edit1.Text;
      port:=FEditDB.SpinEdit1.Value;
      database:=FEditDB.Edit2.Text;
      user:=FEditDB.Edit3.Text;
      passw:=FEditDB.Edit4.Text;
      sfile:=FEditDB.FileNameEdit1.FileName;
      slow:=FEditDB.Edit5.Text;
      slow:=StringReplace(slow,',','{$1}',[rfReplaceAll]);
    end;
  finally
    FEditDB.Free;
  end;
  if ok then
  begin
    s:=protokol+','+host+':'+IntToStr(port)+' ('+database+')';
    s2:=protokol+','+host+','+IntToStr(port)+','+database+','+user+','+passw+','+sfile+','+slow;
    Data^.nazwa:=s;
    Data^.data:=s2;
  end;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  DwuKlik(vst.FocusedNode,true);
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  DatabaseClose(VST.FocusedNode);
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
var
  t: TTabSheet;
  r: TFRamkaTable;
begin
  baza_nazwa:='';
  GetDB(vst.FocusedNode,baza_db,baza_trans);
  t:=TabPC.AddTabSheet;
  t.Caption:='[Nowa tabela]';
  r:=TFRamkaTable.Create(t);
  r.OnApply:=@TableOnApply;
  r.Parent:=t;
  r.Align:=alClient;
  r.io_db:=baza_db;
  r.io_trans:=baza_trans;
  r.io_tablename:=baza_nazwa;
  TabPC.ActivePage:=t;
  r.new_table;
end;

procedure TForm1._DWUKLIK_OBJEKTU(Sender: TObject);
begin
  DwuKlik(vst.FocusedNode);
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
var
  q: TZQuery;
  Data: PTreeData;
begin
  Data:=vst.GetNodeData(vst.FocusedNode);
  if Data^.data<>'TABLE' then exit;
  if not mess.ShowConfirmationYesNo('Czy usunąć tabelę "'+Data^.nazwa+'"?') then exit;
  q:=TZQuery.Create(self);
  try
    GetDB(vst.FocusedNode,baza_db,baza_trans);
    q.Connection:=baza_db;
    q.SQL.Add('drop table '+Data^.nazwa);
    try
      q.ExecSQL;
      //if baza_nazwa=Data^.nazwa then FRamkaTable1.mem1.Close;
      vst.DeleteSelectedNodes;
    except
      on E: Exception do mess.ShowError('Usunięcie tabeli nie powiodło się, to komunikat błędu:^^'+E.Message);
    end;
  finally
    q.Free;
  end;
end;

procedure TForm1.TabPCCloseTabClicked(Sender: TObject);
begin
  ZakladkaFree(TTabSheet(Sender));
  TTabSheet(Sender).Free;
end;

procedure TForm1.vstChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  vst_refresh;
end;

procedure TForm1.vstFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex);
begin
  vst_refresh;
end;

procedure TForm1.vstFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PTreeData;
begin
  Data:=VST.GetNodeData(Node);
  if Assigned(Data) then begin
    Data^.nazwa:='';
  end;
end;

procedure TForm1.vstGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
  var ImageIndex: Integer);
var
  Data: PTreeData;
begin
  if Kind in [ikNormal , ikSelected] then
  begin
    Data:=VST.GetNodeData(Node);
    if Data^.rodzic then ImageIndex:=0;
  end;
end;

procedure TForm1.vstGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize:=SizeOf(TTreeData);
end;

procedure TForm1.vstGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; const P: TPoint; var AskParent: Boolean;
  var APopupMenu: TPopupMenu);
var
  Data: PTreeData;
begin
  AskParent:=false;
  Data:=vst.GetNodeData(Node);
  //if Data<>nil then writeln('Data=',Data^.data,', Nazwa=',Data^.nazwa);
  if Data=nil then APopupMenu:=PopupMenu1 else
  if Data^.rodzic then APopupMenu:=PopupMenu1 else
  if Data^.data='Group' then
  begin
    if Data^.nazwa='Tabele' then APopupMenu:=PopupMenu2 else
    if Data^.nazwa='Funkcje' then APopupMenu:=PopupMenu4 else
    if Data^.nazwa='Procedury' then APopupMenu:=PopupMenu6;
  end else
  if Data^.data='TABLE' then APopupMenu:=PopupMenu3 else
  if Data^.data='FUNCTION' then APopupMenu:=PopupMenu5 else
  if Data^.data='PROCEDURE' then APopupMenu:=PopupMenu7;
end;

procedure TForm1.vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PTreeData;
begin
  Data:=VST.GetNodeData(Node);
  CellText:=Data^.nazwa;
end;

procedure TForm1.vstNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; const NewText: String);
var
  Data: PTreeData;
begin
  Data:=VST.GetNodeData(Node);
  Data^.nazwa:=NewText;
end;

procedure TForm1.vstNodeDblClick(Sender: TBaseVirtualTree;
  const HitInfo: THitInfo);
begin
  if not Assigned(Sender.FocusedNode) then Exit;
  DwuKlik(Sender.FocusedNode);
end;

procedure TForm1.vstPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PTreeData;
begin
  Data:=VST.GetNodeData(Node);
  if Data^.bold then TargetCanvas.Font.Style:=[fsBold] else TargetCanvas.Font.Style:=[];
end;

procedure TForm1.ZakladkaFree(aTab: TTabSheet);
begin
  (* DEFINICJE ZWALNIANIA RAMEK *)
  case aTab.Tag of
    1: TFRamkaTable(aTab.Components[0]).Free;
    2: TFRamkaQuery(aTab.Components[0]).Free;
    3: TFRamkaView(aTab.Components[0]).Free;
    4: TFRamkaFunction(aTab.Components[0]).Free;
    5: TFRamkaProcedure(aTab.Components[0]).Free;
    6: TFRamkaExec(aTab.Components[0]).Free;
  end;
end;

procedure TForm1.ZakladkiFreeAll;
var
  i: integer;
begin
  for i:=TabPC.PageCount-1 downto 0 do
  begin
    ZakladkaFree(TabPC.Pages[i]);
    TabPC.Pages[i].Free;
  end;
end;

procedure TForm1.TableOnApply(Sender: TObject; aOldName, aNewName: string;
  aOperation: integer);
var
  StartNode,XNode: PVirtualNode;
  Data: PTreeData;
  b: boolean;
  s: string;
begin
  if aOldName=aNewName then exit;
  StartNode:=vst.FocusedNode;
  Data:=vst.GetNodeData(StartNode);
  b:=(Data^.data='TABLE');
  if Data^.nazwa=aOldName then s:=aNewName else s:=Data^.nazwa;
  XNode:=GetRodzic(StartNode);
  initdb(XNode,aOperation);
  vst.Expanded[Xnode]:=true;
  if b then StartNode:=GetDziecko(GetDziecko(XNode,'Group','Tabele'),'TABLE',s);
  vst.FocusedNode:=StartNode;
  vst.Selected[StartNode]:=true;
  TTabSheet(TFRamkaTable(Sender).Owner).Caption:=aNewName;
end;

procedure TForm1.ViewOnApply(Sender: TObject; aOldName, aNewName: string;
  aOperation: integer);
begin

end;

procedure TForm1.FunctionOnApply(Sender: TObject; aOldName, aNewName: string;
  aOperation: integer);
var
  StartNode,XNode: PVirtualNode;
  Data: PTreeData;
  b: boolean;
  s: string;
begin
  if aOldName=aNewName then exit;
  StartNode:=vst.FocusedNode;
  Data:=vst.GetNodeData(StartNode);
  b:=(Data^.data='FUNCTION');
  if Data^.nazwa=aOldName then s:=aNewName else s:=Data^.nazwa;
  XNode:=GetRodzic(StartNode);
  initdb(XNode,aOperation);
  vst.Expanded[Xnode]:=true;
  if b then StartNode:=GetDziecko(GetDziecko(XNode,'Group','Funkcje'),'FUNCTION',s);
  vst.FocusedNode:=StartNode;
  vst.Selected[StartNode]:=true;
  TTabSheet(TFRamkaFunction(Sender).Owner).Caption:=aNewName;
end;

procedure TForm1.ProcedureOnApply(Sender: TObject; aOldName, aNewName: string;
  aOperation: integer);
var
  StartNode,XNode: PVirtualNode;
  Data: PTreeData;
  b: boolean;
  s: string;
begin
  if aOldName=aNewName then exit;
  StartNode:=vst.FocusedNode;
  Data:=vst.GetNodeData(StartNode);
  b:=(Data^.data='PROCEDURE');
  if Data^.nazwa=aOldName then s:=aNewName else s:=Data^.nazwa;
  XNode:=GetRodzic(StartNode);
  initdb(XNode,aOperation);
  vst.Expanded[Xnode]:=true;
  if b then StartNode:=GetDziecko(GetDziecko(XNode,'Group','Procedury'),'PROCEDURE',s);
  vst.FocusedNode:=StartNode;
  vst.Selected[StartNode]:=true;
  TTabSheet(TFRamkaFunction(Sender).Owner).Caption:=aNewName;
end;

procedure TForm1.initdb(StartNode: PVirtualNode; aCel: integer);
var
  a: PVirtualNode;
  q: TZQuery;
begin
  q:=TZQuery.Create(self);
  q.Connection:=baza_db;
  try
    if (aCel=0) or (aCel=1) then
    begin
      (* tabele *)
      a:=GetDziecko(StartNode,'Group','Tabele');
      vst.DeleteChildren(a);
      q.SQL.Add('show tables');
      q.Open;
      while not q.EOF do
      begin
        AddDziecko(q.Fields[0].AsString,'TABLE',a);
        q.Next;
      end;
      q.Close;
      if aCel=1 then vst.Expanded[a]:=true;
    end;
    if (aCel=0) or (aCel=2) then
    begin
      (* widoki *)
      a:=GetDziecko(StartNode,'Group','Widoki');
      vst.DeleteChildren(a);
      q.SQL.Clear;
      q.SQL.Add('SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA=database() AND TABLE_TYPE LIKE ''VIEW''');
      q.Open;
      while not q.EOF do
      begin
        AddDziecko(q.Fields[0].AsString,'TABLE',a);
        q.Next;
      end;
      q.Close;
      if aCel=2 then vst.Expanded[a]:=true;
    end;
    if (aCel=0) or (aCel=3) then
    begin
      (* funkcje *)
      a:=GetDziecko(StartNode,'Group','Funkcje');
      vst.DeleteChildren(a);
      q.SQL.Clear;
      q.SQL.Add('show function status where db=database()');
      q.Open;
      while not q.EOF do
      begin
        AddDziecko(q.FieldByName('Name').AsString,'FUNCTION',a);
        q.Next;
      end;
      q.Close;
      if aCel=3 then vst.Expanded[a]:=true;
    end;
    if (aCel=0) or (aCel=4) then
    begin
      (* procedury *)
      a:=GetDziecko(StartNode,'Group','Procedury');
      vst.DeleteChildren(a);
      q.SQL.Clear;
      q.SQL.Add('show procedure status where db=database()');
      q.Open;
      while not q.EOF do
      begin
        AddDziecko(q.FieldByName('Name').AsString,'PROCEDURE',a);
        q.Next;
      end;
      q.Close;
      if aCel=4 then vst.Expanded[a]:=true;
    end;
  finally
    q.Free;
  end;
end;

procedure TForm1.initdb(aData: PTreeData);
var
  a: PVirtualNode;
  Data: PTreeData;
  q: TZQuery;
begin
  q:=TZQuery.Create(self);
  q.Connection:=aData^.db;
  try
    (* tabele *)
    a:=AddDziecko('Tabele','Group');
    q.SQL.Add('SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA=database() AND TABLE_TYPE LIKE ''BASE TABLE'' order by TABLE_NAME');
    q.Open;
    while not q.EOF do
    begin
      AddDziecko(q.Fields[0].AsString,'TABLE',a);
      q.Next;
    end;
    q.Close;
    (* widoki *)
    a:=AddDziecko('Widoki','Group');
    q.SQL.Clear;
    q.SQL.Add('SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA=database() AND TABLE_TYPE LIKE ''VIEW'' order by TABLE_NAME');
    q.Open;
    while not q.EOF do
    begin
      AddDziecko(q.Fields[0].AsString,'VIEW',a);
      q.Next;
    end;
    q.Close;
    (* funkcje *)
    a:=AddDziecko('Funkcje','Group');
    q.SQL.Clear;
    q.SQL.Add('show function status where db=database()');
    q.Open;
    while not q.EOF do
    begin
      AddDziecko(q.FieldByName('Name').AsString,'FUNCTION',a);
      q.Next;
    end;
    q.Close;
    (* procedury *)
    a:=AddDziecko('Procedury','Group');
    q.SQL.Clear;
    q.SQL.Add('show procedure status where db=database()');
    q.Open;
    while not q.EOF do
    begin
      AddDziecko(q.FieldByName('Name').AsString,'PROCEDURE',a);
      q.Next;
    end;
    q.Close;
  finally
    q.Free;
  end;
end;

procedure TForm1.BuildMem(var aMem: TMemDataset; aNo: integer);
begin
  aMem.FieldDefs.Clear;
  if aNo=1 then aMem.FieldDefs.Add('status',ftString,1);
  if aNo=1 then aMem.FieldDefs.Add('origin',ftString,255);
  aMem.FieldDefs.Add('pole',ftString,255);
  aMem.FieldDefs.Add('typ',ftString,255);
  aMem.FieldDefs.Add('ai',ftBoolean);
  aMem.FieldDefs.Add('pk',ftBoolean);
  aMem.FieldDefs.Add('unsigned',ftBoolean);
  aMem.FieldDefs.Add('notnull',ftBoolean);
  aMem.FieldDefs.Add('default',ftString,255);
end;

procedure TForm1.freeall;
var
  XNode: PVirtualNode;
  Data: PTreeData;
begin
  if VST.GetFirst=nil then Exit;
  XNode:=nil;
  repeat
    if XNode=nil then XNode:=VST.GetFirst else XNode:=VST.GetNext(XNode);
    Data:=VST.GetNodeData(XNode);
    if Data^.rodzic then
    begin
      if Data^.active then
      begin
        Data^.active:=false;
        Data^.bold:=false;
        Data^.trans.Free;
        Data^.db.Free;
      end;
    end;
  until XNode=VST.GetLast();
end;

procedure TForm1.Add(aName, aData: string);
var
  Data: PTreeData;
  XNode: PVirtualNode;
begin
  XNode:=VST.AddChild(nil);
  if VST.AbsoluteIndex(XNode)>-1 then
  begin
    Data:=VST.GetNodeData(Xnode);
    Data^.nazwa:=aName;
    Data^.rodzic:=true;
    Data^.dziecko:=false;
    Data^.active:=false;
    Data^.bold:=false;
    Data^.data:=aData;
  end;
end;

function TForm1.AddDziecko(aName, aData: string; StartNode: PVirtualNode
  ): PVirtualNode;
var
  Data: PTreeData;
  XNode: PVirtualNode;
begin
  if StartNode=nil then
  begin
    if not Assigned(VST.FocusedNode) then exit;
    XNode:=VST.AddChild(VST.FocusedNode);
  end else begin
    if not Assigned(StartNode) then exit;
    XNode:=VST.AddChild(StartNode);
  end;
  Data:=VST.GetNodeData(Xnode);
  Data^.nazwa:=aName;
  Data^.rodzic:=false;
  Data^.dziecko:=true;
  Data^.active:=false;
  Data^.bold:=false;
  Data^.data:=aData;
  VST.Expanded[VST.FocusedNode]:=true;
  result:=XNode;
end;

procedure TForm1.Edit(aName, aData: string);
begin

end;

procedure TForm1.Del;
begin
  vst.DeleteSelectedNodes;
end;

procedure TForm1.vst_refresh;
begin
  vst.Refresh;
end;

procedure TForm1.Load;
var
  s,s2: string;
  f: textfile;
begin
  s:=MyConfDir('config.dat');
  if not FileExists(s) then exit;
  assignfile(f,s);
  reset(f);
  while not eof(f) do
  begin
    readln(f,s2);
    s:=GetLineToStr(s2,1,',')+':'+GetLineToStr(s2,2,',')+':'+GetLineToStr(s2,3,',')+' ('+GetLineToStr(s2,4,',')+')';
    Add(s,s2);
  end;
  closefile(f);
end;

procedure TForm1.Save;
var
  XNode: PVirtualNode;
  Data: PTreeData;
var
  i: integer;
  f: textfile;
  s: string;
begin
  if VST.GetFirst=nil then Exit;
  XNode:=nil;
  assignfile(f,MyConfDir('config.dat'));
  rewrite(f);
  repeat
    if XNode=nil then XNode:=VST.GetFirst else XNode:=VST.GetNext(XNode);
    Data:=VST.GetNodeData(XNode);
    if Data^.rodzic then writeln(f,Data^.data);
  until XNode=VST.GetLast();
  closefile(f);
end;

procedure TForm1.DwuKlik(XNode: PVirtualNode; aExpanded: boolean);
var
  data: PTreeData;
  t: TTabSheet;
  r: TFRamkaTable;
  v: TFRamkaView;
  f: TFRamkaFunction;
  p: TFRamkaProcedure;
begin
  if (not Assigned(XNode)) or (XNode=nil) then Exit;
  data:=vst.GetNodeData(XNode);
  if data^.rodzic and (not data^.bold) then
  begin
    data^.bold:=true;
    data^.db:=TZConnection.Create(self);
    data^.db.ControlsCodePage:=cCP_UTF8;
    data^.trans:=TZTransaction.Create(self);
    data^.trans.Database:=data^.db;
    data^.db.Protocol:=GetLineToStr(data^.data,1,',');
    if data^.db.Protocol='sqlite-3' then data^.db.ClientCodepage:='UTF-8' else data^.db.ClientCodepage:='utf8mb4';
    data^.db.HostName:=GetLineToStr(data^.data,2,',');
    data^.db.Port:=StrToInt(GetLineToStr(data^.data,3,','));
    data^.db.Database:=GetLineToStr(data^.data,4,',');
    data^.db.User:=GetLineToStr(data^.data,5,',');
    data^.db.Password:=GetLineToStr(data^.data,6,',');
    data^.db.Connect;
    data^.active:=true;
    initdb(data);
    if aExpanded then vst.Expanded[Xnode]:=true else vst.FullCollapse(XNode);
  end else
  if data^.dziecko and (data^.data='TABLE') then
  begin
    baza_nazwa:=data^.nazwa;
    GetDB(XNode,baza_db,baza_trans);
    t:=TabPC.AddTabSheet;
    t.Caption:=data^.nazwa;
    t.Tag:=1;
    r:=TFRamkaTable.Create(t);
    r.OnApply:=@TableOnApply;
    r.Parent:=t;
    r.Align:=alClient;
    r.io_db:=baza_db;
    r.io_trans:=baza_trans;
    r.io_tablename:=baza_nazwa;
    TabPC.ActivePage:=t;
    r.load_table;
  end else
  if data^.dziecko and (data^.data='VIEW') then
  begin
    baza_nazwa:=data^.nazwa;
    GetDB(XNode,baza_db,baza_trans);
    t:=TabPC.AddTabSheet;
    t.Caption:=data^.nazwa;
    t.Tag:=3;
    v:=TFRamkaView.Create(t);
    v.OnApply:=@ViewOnApply;
    v.Parent:=t;
    v.Align:=alClient;
    v.io_db:=baza_db;
    v.io_trans:=baza_trans;
    v.io_tablename:=baza_nazwa;
    TabPC.ActivePage:=t;
    v.load_view;
  end else
  if data^.dziecko and (data^.data='FUNCTION') then
  begin
    baza_nazwa:=data^.nazwa;
    GetDB(XNode,baza_db,baza_trans);
    t:=TabPC.AddTabSheet;
    t.Caption:=data^.nazwa;
    t.Tag:=4;
    f:=TFRamkaFunction.Create(t);
    f.OnApply:=@FunctionOnApply;
    f.Parent:=t;
    f.Align:=alClient;
    f.io_db:=baza_db;
    f.io_trans:=baza_trans;
    f.io_tablename:=baza_nazwa;
    TabPC.ActivePage:=t;
    f.load_function;
  end else
  if data^.dziecko and (data^.data='PROCEDURE') then
  begin
    baza_nazwa:=data^.nazwa;
    GetDB(XNode,baza_db,baza_trans);
    t:=TabPC.AddTabSheet;
    t.Caption:=data^.nazwa;
    t.Tag:=5;
    p:=TFRamkaProcedure.Create(t);
    p.OnApply:=@ProcedureOnApply;
    p.Parent:=t;
    p.Align:=alClient;
    p.io_db:=baza_db;
    p.io_trans:=baza_trans;
    p.io_tablename:=baza_nazwa;
    TabPC.ActivePage:=t;
    p.load_procedure;
  end;
end;

procedure TForm1.DatabaseClose(XNode: PVirtualNode);
var
  data: PTreeData;
  i: integer;
  t: TTabSheet;
begin
  if (not Assigned(XNode)) or (XNode=nil) then Exit;
  data:=vst.GetNodeData(XNode);
  for i:=TabPC.PageCount-1 downto 0 do
  begin
    t:=TabPC.Pages[i];
    if TFRamkaTable(TabPC.Pages[i].Components[0]).io_db=data^.db then
    begin
      ZakladkaFree(TabPC.Pages[i]);
      TabPC.Pages[i].Free;
    end;
  end;
  if data^.rodzic and data^.bold then
  begin
    data^.bold:=false;
    data^.trans.Free;
    data^.db.Free;
    data^.active:=false;
    vst.DeleteChildren(XNode);
  end;
end;

function TForm1.GetRodzic(StartNode: PVirtualNode): PVirtualNode;
var
  Data: PTreeData;
  XNode: PVirtualNode;
begin
  result:=nil;
  if not Assigned(StartNode) then Exit;
  if StartNode=nil then exit;
  XNode:=StartNode;
  while true do
  begin
    XNode:=XNode^.Parent;
    data:=vst.GetNodeData(XNode);
    if data^.rodzic then
    begin
      result:=XNode;
      break;
    end;
  end;
end;

function TForm1.GetDziecko(StartNode: PVirtualNode; aData, aNazwa: string
  ): PVirtualNode;
var
  Data: PTreeData;
  XNode: PVirtualNode;
begin
  result:=nil;
  XNode:=StartNode;
  Data:=vst.GetNodeData(XNode);
  if Data^.rodzic then vst.Expanded[XNode];
  while true do
  begin
    XNode:=vst.GetNext(XNode);
    if XNode=nil then break;
    if (aNazwa='Tabele') and (Data^.Data='Group') and (Data^.Nazwa='Tabele') then vst.Expanded[XNode] else
    if (aNazwa='Funkcje') and (Data^.Data='Group') and (Data^.Nazwa='Funkcje') then vst.Expanded[XNode] else
    if (aNazwa='Procedury') and (Data^.Data='Group') and (Data^.Nazwa='Procedury') then vst.Expanded[XNode];
    Data:=vst.GetNodeData(XNode);
    //writeln('Znaleziono ("'+aData+'"/"'+aNazwa+'"): ',Data^.data,' (',Data^.nazwa,')');
    if (Data^.data=aData) and (Data^.nazwa=aNazwa) then
    begin
      result:=XNode;
      break;
    end;
  end;
end;

function TForm1.GetDB(StartNode: PVirtualNode; var aDB: TZConnection;
  var aTrans: TZTransaction): boolean;
var
  Data: PTreeData;
  XNode: PVirtualNode;
begin
  result:=false;
  if not Assigned(StartNode) then Exit;
  if StartNode=nil then exit;
  XNode:=StartNode;
  while true do
  begin
    XNode:=XNode^.Parent;
    data:=vst.GetNodeData(XNode);
    if data^.rodzic then
    begin
      aDB:=data^.db;
      aTrans:=data^.trans;
      result:=true;
      break;
    end;
  end;
end;

function TForm1.GetDefault(aStr: string): string;
var
  a: integer;
  s: string;
begin
  s:=trim(StringReplace(aStr,',','',[]));
  a:=pos('DEFAULT',s);
  if a=0 then result:='' else
  begin
    delete(s,1,a);
    TextSeparator:='''';
    result:=GetLineToStr(s,2,' ');
    TextSeparator:='"';
    if result='NULL' then result:='';
  end;
end;

end.

