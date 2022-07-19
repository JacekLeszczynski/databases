unit ramka_query;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Buttons, DBGrids,
  DBCtrls, Menus, SynEdit, SynHighlighterSQL, ZTransaction, ExtMessage, db,
  ZConnection, ZDataset, ZSqlProcessor;

type

  { TFRamkaQuery }

  TFRamkaQuery = class(TFrame)
    asql: TZQuery;
    cAutoFillCol: TCheckBox;
    cScript: TCheckBox;
    DBNavigator1: TDBNavigator;
    ds_asql: TDataSource;
    DBGrid1: TDBGrid;
    dziennik: TListBox;
    MenuItem1: TMenuItem;
    mess: TExtMessage;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    script: TZSQLProcessor;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel1: TPanel;
    sql: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    procedure asqlAfterOpen(DataSet: TDataSet);
    procedure cAutoFillColChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure sqlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
  private
    mem_col,mem_row: integer;
    procedure f9_open;
    procedure f9_script;
  public
    io_db: TZConnection;
    io_trans: TZTransaction;
    procedure init;
  end;

implementation

uses
  Types, LCLType, Clipbrd;

{$R *.lfm}

{ TFRamkaQuery }

procedure TFRamkaQuery.SpeedButton1Click(Sender: TObject);
begin
  if cscript.Checked then f9_script else f9_open;
end;

procedure TFRamkaQuery.cAutoFillColChange(Sender: TObject);
begin
  DBGrid1.AutoFillColumns:=cAutoFillCol.Checked;
end;

procedure TFRamkaQuery.asqlAfterOpen(DataSet: TDataSet);
var
  i: integer;
begin
  for i:=0 to DBGrid1.Columns.Count-1 do
  begin
    case DBGrid1.Columns[i].Field.DataType of
      ftDate: DBGrid1.Columns[i].DisplayFormat:='yyyy-mm-dd';
      ftTime: DBGrid1.Columns[i].DisplayFormat:='hh:nn:ss';
      ftDateTime: DBGrid1.Columns[i].DisplayFormat:='yyyy-mm-dd hh:nn:ss';
      else DBGrid1.Columns[i].DisplayFormat:='';
    end;
    case DBGrid1.Columns[i].Field.DataType of
      ftDate,ftTime,ftDateTime,ftTimeStamp: DBGrid1.Columns[i].Font.Name:='Droid Sans Mono';
      ftSmallint,ftInteger,ftWord,ftLargeint: DBGrid1.Columns[i].Font.Name:='Droid Sans Mono';
      ftFloat,ftCurrency: DBGrid1.Columns[i].Font.Name:='Droid Sans Mono';
      else DBGrid1.Columns[i].Font.Name:='Droid Sans';
    end;
    case DBGrid1.Columns[i].Field.DataType of
      ftDate,ftTime,ftDateTime,ftTimeStamp: DBGrid1.Columns[i].Font.Size:=9;
      ftSmallint,ftInteger,ftWord,ftLargeint: DBGrid1.Columns[i].Font.Size:=9;
      ftFloat,ftCurrency: DBGrid1.Columns[i].Font.Size:=9;
      else DBGrid1.Columns[i].Font.Size:=10;
    end;
  end;
end;

procedure TFRamkaQuery.SpeedButton2Click(Sender: TObject);
begin
  io_trans.StartTransaction;
  SpeedButton2.Enabled:=false;
  SpeedButton3.Enabled:=true;
  SpeedButton4.Enabled:=true;
end;

procedure TFRamkaQuery.SpeedButton3Click(Sender: TObject);
begin
  io_trans.Commit;
  SpeedButton2.Enabled:=true;
  SpeedButton3.Enabled:=false;
  SpeedButton4.Enabled:=false;
end;

procedure TFRamkaQuery.SpeedButton4Click(Sender: TObject);
begin
  io_trans.Rollback;
  SpeedButton2.Enabled:=true;
  SpeedButton3.Enabled:=false;
  SpeedButton4.Enabled:=false;
end;

procedure TFRamkaQuery.sqlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_F9 then SpeedButton1.Click;
end;

procedure TFRamkaQuery.f9_open;
var
  ss,s,wynik: string;
  a,b: integer;
begin
  if asql.Active then asql.Close;

  ss:=sql.Text;
  while true do
  begin
    wynik:='';
    a:=pos(';',ss);
    if a>0 then
    begin
      s:=trim(copy(ss,1,a));
      delete(ss,1,a);
    end else begin
      s:=trim(ss);
      ss:='';
    end;
    if s='' then break;
    asql.SQL.Clear;
    asql.SQL.AddText(s);
    try
      asql.Open;
      if asql.Fields.Count=0 then asql.Close;
    except
      on E: Exception do
      begin
        if E.Message='Can not open a Resultset' then
        begin
          wynik:='Polecenie wykonało się poprawnie.';
        end else begin
          wynik:=E.Message;
          mess.ShowError('Komunikat Błędu:^'+E.Message);
          break;
        end;
      end;
    end;
  end;

  if wynik<>'' then
  begin
    dziennik.Items.Add(wynik);
    dziennik.ItemIndex:=dziennik.Count-1;
  end;
end;

procedure TFRamkaQuery.f9_script;
begin
  if asql.Active then asql.Close;
  script.Script.Assign(sql.Lines);
  try
    script.Execute;
  except
    on E: Exception do
    begin
      dziennik.Items.Add(E.Message);
      dziennik.ItemIndex:=dziennik.Count-1;
      mess.ShowError('Komunikat Błędu:^'+E.Message);
    end;
  end;
end;

procedure TFRamkaQuery.init;
begin
  asql.Connection:=io_db;
  script.Connection:=io_db;
end;

end.

