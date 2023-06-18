unit editdb;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  Buttons, EditBtn;

type

  { TFEditDB }

  TFEditDB = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpinEdit1: TSpinEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
  public
    io_ok: boolean;
  end;

var
  FEditDB: TFEditDB;

implementation

{$R *.lfm}

{ TFEditDB }

procedure TFEditDB.BitBtn1Click(Sender: TObject);
begin
  io_ok:=true;
  close;
end;

procedure TFEditDB.BitBtn2Click(Sender: TObject);
begin
  io_ok:=false;
  close;
end;

end.

