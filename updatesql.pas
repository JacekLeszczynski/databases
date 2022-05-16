unit updatesql;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ZTransaction, ExtMessage, ZSqlProcessor, ZConnection, SynEdit,
  SynHighlighterSQL;

type

  { TFUpdateSQL }

  TFUpdateSQL = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    mess: TExtMessage;
    Panel1: TPanel;
    script: TZSQLProcessor;
    sql: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
  public
    io_db: TZConnection;
    io_trans: TZTransaction;
    io_tablename: string;
    io_ok: boolean;
  end;

var
  FUpdateSQL: TFUpdateSQL;

implementation

{$R *.lfm}

{ TFUpdateSQL }

procedure TFUpdateSQL.BitBtn2Click(Sender: TObject);
begin
  script.Connection:=io_db;
  script.Script.Assign(sql.Lines);
  try
    io_trans.StartTransaction;
    script.Execute;
    io_trans.Commit;
    io_ok:=true;
    close;
  except
    on E: Exception do
    begin
      io_trans.Rollback;
      mess.ShowError('Wykonanie skryptu:^'+script.Script.Text+'^^Komunikat Błędu:^'+E.Message);
    end;
  end;
end;

procedure TFUpdateSQL.BitBtn1Click(Sender: TObject);
begin
  io_ok:=false;
  close;
end;

end.

