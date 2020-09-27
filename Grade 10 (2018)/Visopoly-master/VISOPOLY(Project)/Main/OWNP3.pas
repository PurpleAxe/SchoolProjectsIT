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
unit OWNP3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TP3STATS = class(TForm)
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
  P3STATS: TP3STATS;
  bal: integer;

implementation

uses ATM;

{$R *.dfm}

procedure TP3STATS.Button1Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP3STATS.Button2Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP3STATS.Button3Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP3STATS.Button4Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP3STATS.Button5Click(Sender: TObject);
begin
A_T_M.show;
ATM.P1 := False;
ATM.P2 := False;
ATM.P3 := True;
ATM.P4 := False;
end;

procedure TP3STATS.Timer1Timer(Sender: TObject);
begin
Bmemo.Clear;
Bmemo.Lines.Add('');
BMemo.Lines.add('BANK BALANCE - R'+inttostr(bal));
BMemo.Lines.add('CASH - R0');
BMemo.Lines.add ('CRYPTO RATES - '+inttostr(ATM.rate)+' %');

end;

end.
