{
    Visopoly a bilingual monopoly game
    Copyright (C) 2018  Andreas Visagie

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}
unit OWNP1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TP1STATS = class(TForm)
    BMemo: TMemo;
    PMemo: TMemo;
    CMemo: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Timer1: TTimer;
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  P1STATS: TP1STATS;
  bal: integer;

implementation

uses ATM;

{$R *.dfm}

procedure TP1STATS.Button1Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP1STATS.Button2Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP1STATS.Button3Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP1STATS.Button4Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP1STATS.Button5Click(Sender: TObject);
begin
A_T_M.show;
ATM.P1 := True;
ATM.P2 := False;
ATM.P3 := False;
ATM.P4 := False;
end;

procedure TP1STATS.Timer1Timer(Sender: TObject);
begin
Bmemo.Clear;
Bmemo.Lines.Add('');
BMemo.Lines.add('BANK BALANCE - R'+inttostr(bal));
BMemo.Lines.add('CASH - R0');
BMemo.Lines.add ('CRYPTO RATES - '+inttostr(ATM.rate)+' %');

end;

end.
