unit ramka_exec;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Spin, Buttons,
  EditBtn, ZDataset, ZConnection, ZTransaction, ExtMessage, memds, DB;

type

  { TFRamkaExec }

  TFRamkaExecType = (etFunction,etProcedure);
  TFRamkaExec = class(TFrame)
    asql: TZQuery;
    awejscie: TMemDataset;
    cExec: TBitBtn;
    dswejscie: TDataSource;
    mess: TExtMessage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    bsql: TZQuery;
    procedure awejscieBeforeClose(DataSet: TDataSet);
    procedure cExecClick(Sender: TObject);
  private
    typy,cc1,cc2: TStringList;
    list: TList;
    procedure ShowFunction(nazwa: string; cialo: TStrings);
    procedure ShowProcedure(nazwa: string; cialo: TStrings);
    function GetParameters: string;
    function GetConfValue(aParam: string): string;
    procedure SelectToItems(aSelect: string; aItems: TStrings);
    procedure dodaj_kontrolki;
    procedure usun_kontrolki;
  public
    io_type: TFRamkaExecType;
    io_db: TZConnection;
    io_trans: TZTransaction;
    io_tablename: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure init;
    procedure load_function;
    procedure load_procedure;
  end;

implementation

uses
  serwis, ecode, math;

{$R *.lfm}

{ TFRamkaExec }

procedure TFRamkaExec.cExecClick(Sender: TObject);
var
  s: string;
  i: integer;
begin
  if bsql.SQL.Count=0 then
  begin
    s:='';
    for i:=0 to list.Count-1 do
    begin
      if typy[i]='1' then continue;
      if s='' then s:=s+':param'+IntToStr(i) else s:=s+',:param'+IntToStr(i);
    end;
    s:='select '+io_tablename+'('+s+')';
    bsql.SQL.Add(s);
    bsql.Prepare;
  end;
  for i:=0 to list.Count-1 do
  begin
    case StrToInt(typy[i]) of
       1: continue;
       2: bsql.ParamByName('param'+IntToStr(i)).AsString:=TEdit(list[i]).Text;
       3: bsql.ParamByName('param'+IntToStr(i)).AsFloat:=TFloatSpinEdit(list[i]).Value;
       4: if TCheckBox(list[i]).Checked then bsql.ParamByName('param'+IntToStr(i)).AsInteger:=1 else bsql.ParamByName('param'+IntToStr(i)).AsInteger:=0;
       5: bsql.ParamByName('param'+IntToStr(i)).AsLargeInt:=Int64(TFloatSpinEdit(list[i]).Value);
       6: bsql.ParamByName('param'+IntToStr(i)).AsDate:=TDateEdit(list[i]).Date;
       7: bsql.ParamByName('param'+IntToStr(i)).AsTime:=TTimeEdit(list[i]).Time;
       8: bsql.ParamByName('param'+IntToStr(i)).AsLargeInt:=TSpinEdit(list[i]).Value;
       9: bsql.ParamByName('param'+IntToStr(i)).AsString:=TComboBox(list[i]).Text;
      10: bsql.ParamByName('param'+IntToStr(i)).AsFloat:=TCalcEdit(list[i]).AsFloat;
      11: bsql.ParamByName('param'+IntToStr(i)).AsLargeInt:=Int64(TCalcEdit(list[i]).AsFloat);
      12: bsql.ParamByName('param'+IntToStr(i)).AsLargeInt:=TCalcEdit(list[i]).AsInteger;
    end;
  end;
  try
    bsql.Open;
    Label5.Caption:=bsql.Fields[0].AsString;
    bsql.Close;
  except
    on E: Exception do mess.ShowError('Komunikat Błędu:^'+E.Message);
  end;
end;

procedure TFRamkaExec.awejscieBeforeClose(DataSet: TDataSet);
begin
  while not Dataset.IsEmpty do Dataset.Delete;
end;

procedure TFRamkaExec.ShowFunction(nazwa: string; cialo: TStrings);
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

procedure TFRamkaExec.ShowProcedure(nazwa: string; cialo: TStrings);
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

function TFRamkaExec.GetParameters: string;
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

function TFRamkaExec.GetConfValue(aParam: string): string;
var
  i: integer;
  s: string;
begin
  s:='';
  for i:=0 to cc1.Count-1 do
  begin
    if cc1[i]=aParam then
    begin
      s:=cc2[i];
      break;
    end;
  end;
  result:=s;
end;

procedure TFRamkaExec.SelectToItems(aSelect: string; aItems: TStrings);
var
  q: TZQuery;
begin
  q:=TZQuery.Create(nil);
  q.Connection:=io_db;
  q.SQL.Add(aSelect);
  try
    q.Open;
    while not q.EOF do
    begin
      aItems.Add(q.Fields[0].AsString);
      q.Next;
    end;
    q.Close;
  finally
    q.Free;
  end;
end;

procedure GetNumericMinMaxDecimalPlaces(aDeclare: string; var aMin,aMax: double; var aDecimalPlaces: integer);
var
  s: string;
  i,a,b: integer;
  f: double;
  u: boolean;
  fs: TFormatSettings;
begin
  //NUMERIC(12,2)
  a:=pos('(',aDeclare);
  b:=pos(')',aDeclare);
  u:=pos('UNSIGNED',aDeclare)>0;
  s:=copy(aDeclare,a+1,b-a-1);
  a:=StrToInt(GetLineToStr(s,1,','));
  b:=StrToInt(GetLineToStr(s,2,','));
  s:='';
  for i:=1 to a do s:=s+'9';
  if b>0 then s:=s+'.';
  for i:=1 to b do s:=s+'9';
  fs.DecimalSeparator:='.';
  f:=StrToFloat(s,fs);
  if u then aMin:=0 else aMin:=f*(-1);
  aMax:=f;
  aDecimalPlaces:=b;
end;

procedure GetIntMinMax(aDeclare: string; var aMin,aMax: extended);
var
  u: boolean;
begin
  u:=pos('UNSIGNED',aDeclare)>0;
  if pos('TINYINT',aDeclare)>0 then
  begin
    if u then
    begin
      aMax:=127;
      aMin:=-128;
    end else begin
      aMax:=255;
      aMin:=0;
    end;
  end else
  if pos('SMALLINT',aDeclare)>0 then
  begin
    if u then
    begin
      aMax:=32767;
      aMin:=-32768;
    end else begin
      aMax:=65535;
      aMin:=0;
    end;
  end else
  if pos('MEDIUMINT',aDeclare)>0 then
  begin
    if u then
    begin
      aMax:=8388607;
      aMin:=-8388608;
    end else begin
      aMax:=16777215;
      aMin:=0;
    end;
  end else
  if pos('INT',aDeclare)>0 then
  begin
    if u then
    begin
      aMax:=2147483647;
      aMin:=-2147483648;
    end else begin
      aMax:=4294967295;
      aMin:=0;
    end;
  end else
  if pos('BIGINT',aDeclare)>0 then
  begin
    if u then
    begin
      aMax:=9223372036854775807;
      aMin:=-9223372036854775808;
    end else begin
      aMax:=18446744073709551616;
      aMin:=0;
    end;
  end;
end;

procedure TFRamkaExec.dodaj_kontrolki;
const
  C_DLUGOSC = 150;
  C_WYSOKOSC = 60;
var
  dlugosc_max: integer;
  s1,s2,s3,rodzaj: string;
  r,n1,n2: integer;
  vMin,vMax: double;
  vMin2,vMax2: extended;
  vDecimalPlaces: integer;
  wc: TWinControl;
  cl: TLabel;
  ce: TEdit;
  ci: TSpinEdit;
  cf: TFloatSpinEdit;
  cb: TCheckBox;
  cd: TDateEdit;
  ct: TTimeEdit;
  ccb: TComboBox;
  calc: TCalcEdit;
begin
  dlugosc_max:=Panel1.Width;
  n1:=0;
  n2:=0;
  awejscie.First;
  while not awejscie.EOF do
  begin
    s1:=awejscie.Fields[0].AsString; //nazwa pola
    if io_type=etProcedure then rodzaj:=awejscie.Fields[1].AsString else rodzaj:='IN'; //IN,OUT,INOUT
    s2:=awejscie.Fields[2].AsString; //typ pola
    s3:=GetConfValue(s1);
    (*
       rodzaj: 0 - [brak informacji]
               1 - IN
               2 - INOUT
               3 - OUT
       IN  = <3
       OUT = >1
    *)
    if rodzaj='IN' then r:=1 else
    if rodzaj='INOUT' then r:=2 else
    if rodzaj='OUT' then r:=3 else r:=0;
    if s2='TEXT' then
    begin
      (* TLabel *)
      typy.Add('1');
      cl:=TLabel.Create(Panel1);
      cl.Parent:=Panel1;
      cl.Left:=24+(n1*C_DLUGOSC);
      cl.Top:=24+(n2*C_WYSOKOSC);
      cl.Caption:=s1+':';
      list.Add(cl);
      if s3='CALC' then s3:='';
      if s3='' then
      begin
        (* TEdit *)
        typy.Add('2');
        ce:=TEdit.Create(Panel1);
        ce.Tag:=r;
        ce.Parent:=Panel1;
        ce.Left:=24+(n1*C_DLUGOSC);
        ce.Top:=44+(n2*C_WYSOKOSC);
        ce.Caption:='';
        ce.Width:=C_DLUGOSC-10;
        list.Add(ce);
        (* LICZNIK *)
        if (n1=0) and (n2=0) then wc:=ce;
      end else begin
        (* TEdit *)
        typy.Add('9');
        ccb:=TComboBox.Create(Panel1);
        ccb.Tag:=r;
        ccb.Parent:=Panel1;
        ccb.Left:=24+(n1*C_DLUGOSC);
        ccb.Top:=44+(n2*C_WYSOKOSC);
        ccb.Width:=C_DLUGOSC-10;
        ccb.Style:=csDropDownList;
        SelectToItems(s3,ccb.Items);
        list.Add(ccb);
        (* LICZNIK *)
        if (n1=0) and (n2=0) then wc:=ccb;
      end;
      inc(n1);
    end else
    if pos('NUMERIC',s2)>0 then
    begin
      (* TLabel *)
      typy.Add('1');
      cl:=TLabel.Create(Panel1);
      cl.Parent:=Panel1;
      cl.Left:=24+(n1*C_DLUGOSC);
      cl.Top:=24+(n2*C_WYSOKOSC);
      cl.Caption:=s1+':';
      list.Add(cl);
      if s3<>'CALC' then s3:='';
      if s3='' then
      begin
        (* TFloatSpinEdit *)
        typy.Add('3');
        cf:=TFloatSpinEdit.Create(Panel1);
        cf.Tag:=r;
        cf.Parent:=Panel1;
        cf.Left:=24+(n1*C_DLUGOSC);
        cf.Top:=44+(n2*C_WYSOKOSC);
        GetNumericMinMaxDecimalPlaces(s2,vMin,vMax,vDecimalPlaces);
        cf.MinValue:=vMin;
        cf.MaxValue:=vMax;
        cf.DecimalPlaces:=vDecimalPlaces;
        cf.Width:=C_DLUGOSC-10;
        list.Add(cf);
        if (n1=0) and (n2=0) then wc:=cf;
      end else begin
        (* TFloatSpinEdit *)
        typy.Add('10');
        calc:=TCalcEdit.Create(Panel1);
        calc.Tag:=r;
        calc.Parent:=Panel1;
        calc.Left:=24+(n1*C_DLUGOSC);
        calc.Top:=44+(n2*C_WYSOKOSC);
        calc.Width:=C_DLUGOSC-10;
        calc.Flat:=true;
        list.Add(calc);
        if (n1=0) and (n2=0) then wc:=calc;
      end;
      (* LICZNIK *)
      inc(n1);
    end else
    if s2='BOOLEAN' then
    begin
      (* TLabel *)
      typy.Add('1');
      cl:=TLabel.Create(Panel1);
      cl.Parent:=Panel1;
      cl.Left:=24+(n1*C_DLUGOSC);
      cl.Top:=24+(n2*C_WYSOKOSC);
      cl.Caption:=s1+':';
      list.Add(cl);
      (* TCheckBox *)
      typy.Add('4');
      cb:=TCheckBox.Create(Panel1);
      cb.Tag:=r;
      cb.Parent:=Panel1;
      cb.Left:=24+(n1*C_DLUGOSC);
      cb.Top:=44+(n2*C_WYSOKOSC);
      cb.Caption:='';
      cb.Width:=C_DLUGOSC-10;
      cb.Checked:=false;
      list.Add(cb);
      (* LICZNIK *)
      if (n1=0) and (n2=0) then wc:=cb;
      inc(n1);
    end else
    if pos('BIGINT',s2)>0 then
    begin
      (* TLabel *)
      typy.Add('1');
      cl:=TLabel.Create(Panel1);
      cl.Parent:=Panel1;
      cl.Left:=24+(n1*C_DLUGOSC);
      cl.Top:=24+(n2*C_WYSOKOSC);
      cl.Caption:=s1+':';
      list.Add(cl);
      if s3<>'CALC' then s3:='';
      if s3='' then
      begin
        (* TFloatSpinEdit - BIGINT *)
        typy.Add('5');
        cf:=TFloatSpinEdit.Create(Panel1);
        cf.Tag:=r;
        cf.Parent:=Panel1;
        cf.Left:=24+(n1*C_DLUGOSC);
        cf.Top:=44+(n2*C_WYSOKOSC);
        GetIntMinMax(s2,vMin2,vMax2);
        cf.MinValue:=vMin2;
        cf.MaxValue:=vMax2;
        cf.DecimalPlaces:=0;
        cf.Width:=C_DLUGOSC-10;
        list.Add(cf);
        if (n1=0) and (n2=0) then wc:=cf;
      end else begin
        (* TFloatSpinEdit *)
        typy.Add('11');
        calc:=TCalcEdit.Create(Panel1);
        calc.Tag:=r;
        calc.Parent:=Panel1;
        calc.Left:=24+(n1*C_DLUGOSC);
        calc.Top:=44+(n2*C_WYSOKOSC);
        calc.Width:=C_DLUGOSC-10;
        calc.Flat:=true;
        list.Add(calc);
        if (n1=0) and (n2=0) then wc:=calc;
      end;
      (* LICZNIK *)
      inc(n1);
    end else
    if pos('INT',s2)>0 then
    begin
      (* TLabel *)
      typy.Add('1');
      cl:=TLabel.Create(Panel1);
      cl.Parent:=Panel1;
      cl.Left:=24+(n1*C_DLUGOSC);
      cl.Top:=24+(n2*C_WYSOKOSC);
      cl.Caption:=s1+':';
      list.Add(cl);
      if s3<>'CALC' then s3:='';
      if s3='' then
      begin
        (* TSpinEdit *)
        typy.Add('8');
        ci:=TSpinEdit.Create(Panel1);
        ci.Tag:=r;
        ci.Parent:=Panel1;
        ci.Left:=24+(n1*C_DLUGOSC);
        ci.Top:=44+(n2*C_WYSOKOSC);
        GetIntMinMax(s2,vMin2,vMax2);
        ci.MinValue:=vMin2;
        ci.MaxValue:=vMax2;
        ci.Width:=C_DLUGOSC-10;
        list.Add(ci);
        if (n1=0) and (n2=0) then wc:=ci;
      end else begin
        (* TFloatSpinEdit *)
        typy.Add('12');
        calc:=TCalcEdit.Create(Panel1);
        calc.Tag:=r;
        calc.Parent:=Panel1;
        calc.Left:=24+(n1*C_DLUGOSC);
        calc.Top:=44+(n2*C_WYSOKOSC);
        calc.Width:=C_DLUGOSC-10;
        calc.Flat:=true;
        list.Add(calc);
        if (n1=0) and (n2=0) then wc:=calc;
      end;
      (* LICZNIK *)
      inc(n1);
    end else
    if s2='DATE' then
    begin
      (* TLabel *)
      typy.Add('1');
      cl:=TLabel.Create(Panel1);
      cl.Parent:=Panel1;
      cl.Left:=24+(n1*C_DLUGOSC);
      cl.Top:=24+(n2*C_WYSOKOSC);
      cl.Caption:=s1+':';
      list.Add(cl);
      (* TDateEdit *)
      typy.Add('6');
      cd:=TDateEdit.Create(Panel1);
      cd.Tag:=r;
      cd.Parent:=Panel1;
      cd.Left:=24+(n1*C_DLUGOSC);
      cd.Top:=44+(n2*C_WYSOKOSC);
      cd.DateFormat:='yyyy-mm-dd';
      cd.Date:=date;
      cd.Width:=C_DLUGOSC-10;
      list.Add(cd);
      (* LICZNIK *)
      if (n1=0) and (n2=0) then wc:=cd;
      inc(n1);
    end else
    if s2='TIME' then
    begin
      (* TLabel *)
      typy.Add('1');
      cl:=TLabel.Create(Panel1);
      cl.Parent:=Panel1;
      cl.Left:=24+(n1*C_DLUGOSC);
      cl.Top:=24+(n2*C_WYSOKOSC);
      cl.Caption:=s1+':';
      list.Add(cl);
      (* TTimeEdit *)
      typy.Add('7');
      ct:=TTimeEdit.Create(Panel1);
      ct.Tag:=r;
      ct.Parent:=Panel1;
      ct.Left:=24+(n1*C_DLUGOSC);
      ct.Top:=44+(n2*C_WYSOKOSC);
      ct.Time:=time;
      ct.Width:=C_DLUGOSC-10;
      list.Add(ct);
      (* LICZNIK *)
      if (n1=0) and (n2=0) then wc:=ct;
      inc(n1);
    end;
    awejscie.Next;
  end;
  n1:=0;
  inc(n2);
  cExec.Left:=24+(n1*C_DLUGOSC);
  cExec.Top:=24+(n2*C_WYSOKOSC);
  Panel1.Height:=cExec.Top+cExec.Height+10;
  wc.SetFocus;
end;

procedure TFRamkaExec.usun_kontrolki;
var
  i,a: integer;
begin
  for i:=0 to list.Count-1 do
  begin
    a:=StrToInt(typy[i]);
    case a of
       1: TLabel(list[i]).Free;
       2: TEdit(list[i]).Free;
       3: TFloatSpinEdit(list[i]).Free;
       4: TCheckBox(list[i]).Free;
       5: TFloatSpinEdit(list[i]).Free;
       6: TDateEdit(list[i]).Free;
       7: TTimeEdit(list[i]).Free;
       8: TSpinEdit(list[i]).Free;
       9: TComboBox(list[i]).Free;
      10: TCalcEdit(list[i]).Free;
      11: TCalcEdit(list[i]).Free;
      12: TCalcEdit(list[i]).Free;
    end;
  end;
end;

constructor TFRamkaExec.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  typy:=TStringList.Create;
  list:=TList.Create;
  cc1:=TStringList.Create;
  cc2:=TStringList.Create;
end;

destructor TFRamkaExec.Destroy;
begin
  usun_kontrolki;
  typy.Free;
  list.Free;
  cc1.Free;
  cc2.Free;
  inherited Destroy;
end;

procedure TFRamkaExec.init;
begin
  asql.Connection:=io_db;
  bsql.Connection:=io_db;
  Label4.Visible:=io_type=etFunction;
  Label5.Visible:=Label4.Visible;
end;

procedure TFRamkaExec.load_function;
var
  schema,ss: TStrings;
  s,pom,pom2: string;
  a,i: integer;
  s1,s2: string;
begin //[rfReplaceAll,rfIgnoreCase]
  if awejscie.Active then awejscie.Close;
  awejscie.Open;
  schema:=TStringList.Create;
  try
    (* pobranie nazwy funkcji i parametrów *)
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
    s1:=copy(s,1,a-1); //nazwa funkcji
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
      awejscie.FieldByName('oper').AsString:='IN';
      awejscie.FieldByName('typ').AsString:=upcase(GetLineToStr(pom2,2,' '));
      awejscie.Post;
    end;
    a:=pos(' RETURNS ',s);
    delete(s,1,a+8);
    a:=pos(#10,s);
    s2:=upcase(copy(s,1,a-1)); //typ zwracanej wartosci przez funkcję
    delete(s,1,a);
    Label2.Caption:=' '+s2+' = '+s1+'('+pom+') ';
    (* pobranie konfiguracji pól - jeśli istnieją *)
    ss:=TStringList.Create;
    try
      ss.AddText(schema.Text);
      for i:=0 to ss.Count-1 do
      begin
        s:=trim(ss[i]);
        a:=pos('-- $',s);
        if a>0 then
        begin
          s:=GetLineToStr(s,2,'$');
          s1:=trim(GetLineToStr(s,1,'='));
          s2:=trim(GetLineToStr(s,2,'='));
          if (s1<>'') and (s2<>'') then
          begin
            cc1.Add(s1);
            cc2.Add(s2);
          end;
        end;
      end;
    finally
      ss.Free
    end;
  finally
    schema.Free;
  end;
  dodaj_kontrolki;
end;

procedure TFRamkaExec.load_procedure;
var
  schema,ss: TStrings;
  s,s1,s2,pom,pom2: string;
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
    s1:=copy(s,1,a-1); //Nazwa procedury
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
    a:=pos(#10,s);
    delete(s,a,maxint);
    Label2.Caption:='call '+s;
    (* pobranie konfiguracji pól - jeśli istnieją *)
    ss:=TStringList.Create;
    try
      ss.AddText(schema.Text);
      for i:=0 to ss.Count-1 do
      begin
        s:=trim(ss[i]);
        a:=pos('-- $',s);
        if a>0 then
        begin
          s:=GetLineToStr(s,2,'$');
          s1:=trim(GetLineToStr(s,1,'='));
          s2:=trim(GetLineToStr(s,2,'='));
          if (s1<>'') and (s2<>'') then
          begin
            cc1.Add(s1);
            cc2.Add(s2);
          end;
        end;
      end;
    finally
      ss.Free
    end;
  finally
    schema.Free;
  end;
  dodaj_kontrolki;
end;

end.

