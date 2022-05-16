unit serwis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZTransaction, db, ZConnection, ZDataset;

type

  { Tdm }

  Tdm = class(TDataModule)
    db: TZConnection;
    list_views: TZQuery;
    trans: TZTransaction;
    list_tables: TZQuery;
  private
  public
  end;

var
  dm: Tdm;

function UsunJedenPoziomNawiasow(s: string): string;
procedure StrToListItems(s:string;list:TStrings);
function GetDefault(aStr: string): string;
function dodaj_po_przecinku(s,s2: string): string;
function NormalizeCialoFunkcji(cialo:string):string;
function NormalizeCialoProcedury(cialo:string):string;
function PoleToNazwa(aValue: string): string;
procedure NormalizeCialo(aBody: TStrings);

implementation

uses
  ecode;

{$R *.lfm}

function UsunJedenPoziomNawiasow(s: string): string;
var
  i,a: integer;
begin
  a:=0;
  for i:=1 to length(s) do
  begin
    if s[i]='(' then inc(a);
    if (s[i]='(') and (a=1) then s[i]:='$';
    if s[i]=')' then dec(a);
    if (s[i]=')') and (a=0) then s[i]:='$';
  end;
  s:=StringReplace(s,'$','',[rfReplaceAll]);
  result:=s;
end;

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

function GetDefault(aStr: string): string;
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

function dodaj_po_przecinku(s,s2: string): string;
begin
  if s2='' then result:=trim(s) else
  if s='' then result:=trim(s2) else
  result:=trim(s)+','+trim(s2);
end;

function NormalizeCialoFunkcji(cialo:string):string;
var
  s: string;
  a,b,c: integer;
begin
  s:=StringReplace(cialo,'`','',[rfReplaceAll]);
  a:=pos('CREATE DEFINER=',s);
  if a>0 then
  begin
    b:=pos(' FUNCTION ',s);
    delete(s,a+6,b-a-6);
  end;
  a:=pos(' CHARSET ',s);
  if a>0 then
  begin
    b:=pos(#10,s);
    c:=pos(#13,s);
    if (b=0) and (c>0) then b:=c;
    if (b<>c) and (b>0) and (c>0) then if b>c then b:=c;
    if b>0 then delete(s,a,b-a);
  end;
  result:=s;
end;

function NormalizeCialoProcedury(cialo:string):string;
var
  s: string;
  a,b,c: integer;
begin
  s:=StringReplace(cialo,'`','',[rfReplaceAll]);
  a:=pos('CREATE DEFINER=',s);
  if a>0 then
  begin
    b:=pos(' PROCEDURE ',s);
    delete(s,a+6,b-a-6);
  end;
  result:=s;
end;

function ZakodujWewnetrzneNawiasy(aValue: string): string;
var
  i,a: integer;
  s: string;
begin
  a:=0;
  s:=aValue;
  for i:=1 to length(s) do
  begin
    if s[i]='(' then inc(a);
    if (s[i]='(') and (a>1) then s[i]:='$';
    if s[i]=')' then dec(a);
    if (s[i]=')') and (a>0) then s[i]:='%';
  end;
  result:=s;
end;

function OdkodujWewnetrzneNawiasy(aValue: string): string;
var
  s: string;
begin
  s:=StringReplace(aValue,'$','(',[rfReplaceAll]);
  result:=StringReplace(s,'%',')',[rfReplaceAll]);
end;

function PoleToNazwa(aValue: string): string;
var
  s: string;
  a: integer;
begin
  s:=ZakodujWewnetrzneNawiasy(aValue);
  a:=pos('(',s);
  if a>0 then
  begin
    delete(s,1,a);
    a:=pos(')',s);
    if a>0 then delete(s,a,maxint);
  end;
  result:=OdkodujWewnetrzneNawiasy(s);
end;

procedure NormalizeCialo(aBody: TStrings);
var
  i,j,a: integer;
  s: string;
begin
  a:=0;
  for i:=0 to aBody.Count-1 do
  begin
    s:=trim(aBody[i]);
    if (upcase(s)='END') or (upcase(s)='END;') then dec(a);
    aBody.Delete(i);
    if a>0 then for j:=1 to a do s:='  '+s;
    aBody.Insert(i,s);
    if upcase(s)='BEGIN' then inc(a);
  end;
end;

{ Tdm }

end.

