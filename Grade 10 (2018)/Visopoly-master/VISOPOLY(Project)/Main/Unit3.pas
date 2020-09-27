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
unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, unit1;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  po1,po2, po3, c1, c2, c3:string;
implementation

{$R *.dfm}
uses COMPUTERP4, COMPUTERP3,COMPUTERP2;

procedure TForm3.Button1Click(Sender: TObject);
begin
showmessage('You have selected English');
po1 := 'Pay tax as you dorve past the e-toll';
po2 := 'Pay the Ubuntu Circle as the university burnt down';
po3 := 'Get R20 from each player';
c1 := 'Its your birthday collect money in the Ubuntu Circle';
c2 := 'You must pay R100 to build schools in Soweto';
c3 := 'You got caught dealing with the Ruptis pay for fraud';
form1.btnplayer2.Caption := '2 Players';
form1.btnplayer3.Caption := '3 Players';
form1.btnplayer4.Caption := '4 Players';
form1.btnplayerc.Caption := 'Computer';
form1.Language1.Caption := 'Language';
form1.LanguageSettings1.Caption := 'Language Settings';
COMPUTERP4.prop := 'Would you like to buy ';
COMPUTERP4.p := 'Pay ';
COMPUTERP4.j := 'Our jails are on strike currently but we will take R50 for tax';
COMPUTERP3.prop := 'Would you like to buy ';
COMPUTERP3.p := 'Pay ';
COMPUTERP3.j := 'Our jails are on strike currently but we will take R50 for tax';
COMPUTERP2.prop := 'Would you like to buy ';
COMPUTERP2.p := 'Pay ';
COMPUTERP2.j := 'Our jails are on strike currently but we will take R50 for tax';
form3.Close;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
showmessage('ukhetse siSwati');
po1 := 'Badala intelo ngobe ushayele wandlula ie-toll';
po2 := 'Badala Ubuntu Circle ngobe inyuvesi ishisiwe';
po3 := 'Tfola uR20 kubo bonkhe badlali';
c1 := 'lilanga lakho lwekutalwa kwelega imali kule Ubuntu Circle';
c2 := 'kumele ubadala kusita kwakha tikolo eSoweto';
c3 := 'ubanjwe usebentisana nemaRuptis badala ngenca yebutsotsi';
form1.btnplayer2.Caption := '2 Umdlali';
form1.btnplayer3.Caption := '3 Umdlali';
form1.btnplayer4.Caption := '4 Umdlali';
form1.btnplayerc.Caption := 'Ncondvomshini';
form1.Language1.Caption := 'Lulwimi';
form1.Languagesettings1.caption := 'Emasethini Elulwimi';
COMPUTERP4.prop := 'Ungatsandza kutsenga i-';
COMPUTERP4.p := 'Badala ';
COMPUTERP4.j := 'AmaJele ethu asavaliwe okwamanje ngenca yeStrike kodwa sizothatha uR50 owe nkokelo';
COMPUTERP3.prop := 'Ungatsandza kutsenga i-';
COMPUTERP3.p := 'Badala ';
COMPUTERP3.j := 'AmaJele ethu asavaliwe okwamanje ngenca yeStrike kodwa sizothatha uR50 owe nkokelo';
COMPUTERP2.prop := 'Ungatsandza kutsenga i-';
COMPUTERP2.p := 'Badala ';
COMPUTERP2.j := 'AmaJele ethu asavaliwe okwamanje ngenca yeStrike kodwa sizothatha uR50 owe nkokelo';
form3.Close;
end;

end.
