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
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, Menus, ShellApi;

type
  TForm1 = class(TForm)
    Image1: TImage;
    btnplayer2: TButton;
    btnplayer3: TButton;
    btnplayer4: TButton;
    btnplayerc: TButton;
    MainMenu1: TMainMenu;
    Language1: TMenuItem;
    LanguageSettings1: TMenuItem;
    About1: TMenuItem;
    Credits1: TMenuItem;
    FAQ1: TMenuItem;
    Help1: TMenuItem;
    Rules1: TMenuItem;
    CD: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure LanguageSettings1Click(Sender: TObject);
    procedure FAQ1Click(Sender: TObject);
    procedure btnplayercClick(Sender: TObject);
    procedure btnplayer4Click(Sender: TObject);
    procedure Rules1Click(Sender: TObject);
    procedure btnplayer3Click(Sender: TObject);
    procedure Credits1Click(Sender: TObject);
    procedure btnplayer2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  sLang: string;
  n1,n2,n3,n4:string;

implementation

uses Unit3, ATM, OWNP1, OWNP2, OWNP3, OWNP4, OWNC, COMPUTERAI, COMPUTERP4, COMPUTERP3, COMPUTERP2;

{$R *.dfm}

procedure TForm1.btnplayer2Click(Sender: TObject);
var
Checker,c:boolean;
begin
C2.show;
Checker := False;
COMPUTERP2.c := 0;
OWNP1.bal := 1500;
OWNP2.bal := 1500;
while Checker = False do
  begin
    n1 := inputbox('VISOPOLY','Please enter a name, Player 1','');
    if length(n1) <= 8 then
      begin
        C2.smP1.Lines.Add(n1);
        CD.Execute;
        C2.P1.Brush.Color := CD.color;
        C2.Pl1.Brush.Color := CD.color;
        C2.btnP1.caption :='Show ' + n1 ;
        Checker := True;
      end;
    if Checker = False then
      begin
        showmessage('Your name is too long please type a shorter name');
      end;
  end;
while C = False do
  begin
    n2 := inputbox('VISOPOLY','Please enter a name, Player 2','');
    if length(n2) <= 8 then
      begin
        C2.smP2.Lines.Add(n2);
        CD.Execute;
        C2.P2.Brush.Color := CD.color;
        C2.Pl2.Brush.Color := CD.color;
        C2.btnP2.caption :='Show ' + n2 ;
        C := True;
      end;
    if C = False then
      begin
        showmessage('Your name is too long please type a shorter name');
      end;
  end;
end;

procedure TForm1.btnplayer3Click(Sender: TObject);
var
Checker,c,ch:boolean;
begin
C3.show;
Checker := False;
COMPUTERP3.c := 0;
OWNP1.bal := 1500;
OWNP2.bal := 1500;
OWNP3.bal := 1500;
while Checker = False do
  begin
    n1 := inputbox('VISOPOLY','Please enter a name, Player 1','');
    if length(n1) <= 8 then
      begin
        C3.smP1.Lines.Add(n1);
        CD.Execute;
        C3.P1.Brush.Color := CD.color;
        C3.Pl1.Brush.Color := CD.color;
        C3.btnP1.caption :='Show ' + n1 ;
        Checker := True;
      end;
    if Checker = False then
      begin
        showmessage('Your name is too long please type a shorter name');
      end;
  end;
while C = False do
  begin
    n2 := inputbox('VISOPOLY','Please enter a name, Player 2','');
    if length(n2) <= 8 then
      begin
        C3.smP2.Lines.Add(n2);
        CD.Execute;
        C3.P2.Brush.Color := CD.color;
        C3.Pl2.Brush.Color := CD.color;
        C3.btnP2.caption :='Show ' + n2 ;
        C := True;
      end;
    if C = False then
      begin
        showmessage('Your name is too long please type a shorter name');
      end;
  end;
while Ch = False do
  begin
    n3 := inputbox('VISOPOLY','Please enter a name, Player 3','');
    if length(n3) <= 8 then
      begin
        C3.smP3.Lines.Add(n3);
        CD.Execute;
        C3.P3.Brush.Color := CD.color;
        C3.Pl3.Brush.Color := CD.color;
        C3.btnP3.caption :='Show ' + n3 ;
        Ch := True;
      end;
    if Ch = False then
      begin
        showmessage('Your name is too long please type a shorter name');
      end;
  end;
end;

procedure TForm1.btnplayer4Click(Sender: TObject);
var
Checker,c,ch,che:boolean;
begin
C4.show;
Checker := False;
COMPUTERP4.c := 0;
OWNP1.bal := 1500;
OWNP2.bal := 1500;
OWNP3.bal := 1500;
OWNP4.bal := 1500;
while Checker = False do
  begin
    n1 := inputbox('VISOPOLY','Please enter a name, Player 1','');
    if length(n1) <= 8 then
      begin
        C4.smP1.Lines.Add(n1);
        CD.Execute;
        C4.P1.Brush.Color := CD.color;
        C4.Pl1.Brush.Color := CD.color;
        C4.btnP1.caption :='Show ' + n1 ;
        Checker := True;
      end;
    if Checker = False then
      begin
        showmessage('Your name is too long please type a shorter name');
      end;
  end;
while C = False do
  begin
    n2 := inputbox('VISOPOLY','Please enter a name, Player 2','');
    if length(n2) <= 8 then
      begin
        C4.smP2.Lines.Add(n2);
        CD.Execute;
        C4.P2.Brush.Color := CD.color;
        C4.Pl2.Brush.Color := CD.color;
        C4.btnP2.caption :='Show ' + n2 ;
        C := True;
      end;
    if C = False then
      begin
        showmessage('Your name is too long please type a shorter name');
      end;
  end;
while Ch = False do
  begin
    n3 := inputbox('VISOPOLY','Please enter a name, Player 3','');
    if length(n3) <= 8 then
      begin
        C4.smP3.Lines.Add(n3);
        CD.Execute;
        C4.P3.Brush.Color := CD.color;
        C4.Pl3.Brush.Color := CD.color;
        C4.btnP3.caption :='Show ' + n3 ;
        Ch := True;
      end;
    if Ch = False then
      begin
        showmessage('Your name is too long please type a shorter name');
      end;
  end;
while Che = False do
  begin
    n4 := inputbox('VISOPOLY','Please enter a name, Player 4','');
    if length(n4) <= 8 then
      begin
        C4.smP4.Lines.Add(n4);
        CD.Execute;
        C4.P4.Brush.Color := CD.color;
        C4.Pl4.Brush.Color := CD.color;
        C4.btnP4.caption :='Show ' + n4 ;
        Che := True;
      end;
    if Che = False then
      begin
        showmessage('Your name is too long please type a shorter name');
      end;
  end;
end;

procedure TForm1.btnplayercClick(Sender: TObject);
begin
showmessage('Our AI is too young to play VISOPOLY come back in 2020 when our AI has developed a brain');
end;

procedure TForm1.Credits1Click(Sender: TObject);
begin
showmessage('Andreas Visagie - designed and wrote VISOPOLY '#13#10'Emmarencia Nkosi - Translated English to siSwati');
end;

procedure TForm1.FAQ1Click(Sender: TObject);
begin
shellexecute(handle, 'open', 'WEB\FAQ.html',nil,nil,0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
// Form
form1.position := podesktopcenter;
COMPUTERP4.prop := 'would you like to buy ';
COMPUTERP4.p := 'Pay ';
COMPUTERP4.j := 'Our jails are on strike currently but we will take R50 for tax';
COMPUTERP3.prop := 'Would you like to buy ';
COMPUTERP3.p := 'Pay ';
COMPUTERP3.j := 'Our jails are on strike currently but we will take R50 for tax';
COMPUTERP2.prop := 'Would you like to buy ';
COMPUTERP2.p := 'Pay ';
COMPUTERP2.j := 'Our jails are on strike currently but we will take R50 for tax';
Unit3.po1 := 'Pay tax as you dorve past the e-toll';
Unit3.po2 := 'Pay the Ubuntu Circle as the university burnt down';
Unit3.po3 := 'Get R20 from each player';
Unit3.c1 := 'Its your birthday collect money in the Ubuntu Circle';
Unit3.c2 := 'You must pay R100 to build schools in Soweto';
unit3.c3 := 'You got caught dealing with the Ruptis pay for fraud';
end;

procedure TForm1.LanguageSettings1Click(Sender: TObject);
var
Langfile:textfile;
begin
form3.show;
end;

procedure TForm1.Rules1Click(Sender: TObject);
begin
showmessage('VISOPOLY is still undergoing development for improvements'#13#10'Rules are simple play until a player doesnt have any money left'#13#10'When done playing please restart the application as our gamerules are still undergoing development');
end;

end.
