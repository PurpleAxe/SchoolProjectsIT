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
unit ATM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TA_T_M = class(TForm)
    Label1: TLabel;
    AATM: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  A_T_M: TA_T_M;
  P1,P2,P3,P4: boolean;
  pBal, rate: integer;

implementation

uses OWNP1, OWNP2, OWNP3, OWNP4;

{$R *.dfm}
procedure getBalance();
begin
  if P1 = True then
    begin
      pBal := OWNP1.bal;
      showmessage('P1');
    end;
  if P2 = True then
    begin
      pBal := OWNP2.bal;
      showmessage('P2');
    end;
  if P3 = True then
    begin
      pBal := OWNP3.bal;
      showmessage('P3');
    end;
  if P4 = True then
    begin
      pbal := OWNP4.bal;
      showmessage('P4');
    end;
end;

procedure setBalance();
begin
  if P1 = True then
    begin
      OWNP1.bal := pBal;
      showmessage('P1');
    end;
  if P2 = True then
    begin
      OWNP2.bal := pBal;
      showmessage('P2');
    end;
  if P3 = True then
    begin
      OWNP3.bal := pbal;;
      showmessage('P3');
    end;
  if P4 = True then
    begin
      OWNP4.bal := pbal;;
      showmessage('P4');
    end;
end;

procedure TA_T_M.Button1Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TA_T_M.Button2Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TA_T_M.Button3Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TA_T_M.Button4Click(Sender: TObject);
begin
AATM.clear;
getBalance();
AATM.Lines.add('BANK BALANCE - R '+inttostr(pBal));
end;

end.
