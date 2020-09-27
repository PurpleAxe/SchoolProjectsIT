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
unit COMPUTERP2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, math;

type
  TC2 = class(TForm)
    Image1: TImage;
    btnRD: TButton;
    btnP1: TButton;
    btnP2: TButton;
    smP1: TMemo;
    P1: TShape;
    P2: TShape;
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    smP2: TMemo;
    Label3: TLabel;
    Pl1: TShape;
    Pl2: TShape;
    procedure btnP1Click(Sender: TObject);
    procedure btnP2Click(Sender: TObject);
    procedure btnRDClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  {     PROPERTY LIST
    1-PIENAAR
    2-HAZY VIEW
    3-JOBURG TAXI RANK
    4-WHITE RIVER
    5-NELSPRUIT
    6-HERMANUS
    7-KIMBERLY
    8-POLOKWANE
    9-ELECTRICITY
    10-PHALABORWA
    11-SOWETO TAXI RANK
    12-GRASKOP
    13-WELKOM
    14-VEREENIGING
    15-WORCESTER
    16-PORT ALFRED
    17-KNYSNA
    18-CAPE TOWN TAXI RANK
    19-RUSTENBURG
    20-SOWETO
    21-WATER
    22-GEORGE
    23-BLOEMFONTEIN
    24-DURBAN
    25-CAPE TOWN
    26-DURBAN TAXI RANK
    27-PRETORIA
    28-JOBURG
  }

var
  C2: TC2;
  prop,p,j: string;
  properties: array[1..28]of string;
  uName: string;
  PIENAAR,HAZYVIEW,JTR,WHITERIVER,NELSPRUIT,HERMANUS,KIMBERLY,POLOKWANE,ELECTRICITY,PHALABORWA,STR,GRASKOP,WELKOM,VEREENIGING,WORCESTER,PORTALFRED,KNYSNA,CTTR,RUSTENBURG,SOWETO,WATER,GEORGE,BLOEMFONTEIN,DURBAN,CAPETOWN,DTR,PRETORIA,JOBURG: boolean;
  p1XY,P2XY,P3XY, UC, c, rand: integer;
  {PLAYER POSITION FOR BOARD ALONG X-AXIS}
  p1Xpos: array[1..40] of integer=(8, 72, 136, 200, 264, 328, 392, 456, 520, 584, 648, 648, 648, 648, 648, 648, 648, 648, 648, 648, 648, 584, 520, 456, 392, 328, 264, 200, 136, 72, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8);
  {PLAYER POSITION FOR BOARD ALONG Y-AXIS}
  p1Ypos: array[1..40] of integer=(8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 72, 136, 200, 264, 328, 392, 456, 520, 584, 648, 648, 648, 648, 648, 648, 648, 648, 648, 648, 648, 584, 520, 456, 392, 328, 264, 200, 136, 72);

implementation

uses OWNP1, OWNP2, OWNP3, OWNP4, Unit1, Unit3;

{$R *.dfm}


procedure ptax(pName:string);
begin
      if (pName = 'P1') and (OWNP1.bal > 0) then
      begin
        UC := UC + 50;
        OWNP1.bal := OWNP1.bal - 50;
      end;
    if (pName = 'P2') and (OWNP2.bal > 0) then
      begin
        UC := UC + 50;
        OWNP2.bal := OWNP2.bal - 50;
      end;

end;

procedure spay(player: string; amt: integer);
begin
if player = 'P1' then
  begin
    OWNP1.bal := OWNP1.bal + amt;
  end;
if player = 'P2' then
  begin
    OWNP2.bal := OWNP2.bal + amt;
  end;


end;

procedure payP(p: string; amt: integer; r: string);
begin
if p = 'P1' then
  begin
    OWNP1.bal := OWNP1.bal - amt;
  end;
if p = 'P2' then
  begin
    OWNP2.bal := OWNP2.bal - amt;
  end;
if r = 'P1' then
  begin
    OWNP1.bal := OWNP1.bal + amt;
  end;
if r = 'P2' then
  begin
    OWNP2.bal := OWNP2.bal + amt;
  end;

end;

function buyP(player: string; amt: integer):integer;
var
bal: integer;
begin
if player = 'P1' then
  begin
    bal := OWNP1.bal;
  end;
if player = 'P2' then
  begin
    bal := OWNP2.bal;
  end;
if amt <= bal then
  begin
    bal := bal - amt;
    Result := 0;
  end;
if amt > bal then
  begin
    showmessage('Insufficent Funds');
    Result := 1;
  end;
if player = 'P1' then
  begin
    OWNP1.bal := bal;
  end;
if player = 'P2' then
  begin
    OWNP2.bal := bal;
  end;
end;

{GET USER NAME Function}
function getUser(Name: string):string;
var
usrName: string;
begin
  if Name = 'P1' then
    begin
      usrName := Unit1.n1;
    end;
  if Name = 'P2' then
    begin
      usrName := Unit1.n2;
    end;
  result := usrName;
end;

{SET OWNER OF PROPERTY}
procedure setOwner (Name: string; Index: integer; Place: string);
begin
if Name = 'P1' then
  begin
    P1STATS.PMemo.Lines.Add(Place);
    properties[Index] := 'P1';
  end;
if Name = 'P2' then
  begin
    P2STATS.PMemo.Lines.Add(Place);
    properties[Index] := 'P2';
  end;
end;

procedure placement(XYPOS: integer; player: TShape);
var
pName, Owner: string;
move, press: integer;
begin
{setup}
move := XYPOS;
pName := player.name;
{PIENAAR - 2}
if XYPOS = 2 then
  begin
    if PIENAAR = False then
      begin
        press := messagedlg(prop+'Pienaar ?',mtCustom, mbYesNo, 0);
        if (press = mrYes) and (buyP(pName, 80)= 0) then
          begin
            showmessage(getUser(pName)+' now owns Pienaar');
            setOwner(pname, 1, 'Pienaar');
            PIENAAR := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (PIENAAR = True) and (properties[1] <> pName) then
      begin
        Showmessage(p+getUser(properties[1])+' R10');
        payP(pName, 10, properties[1]);
      end;
  end;

{HAZY VIEW - 4}
if XYPOS = 4 then
  begin
    if HAZYVIEW = False  then
      begin
        press := messagedlg(prop+'Hazy View ?',mtCustom, mbYesNo, 0);
        if (press = mrYes) and (buyP(pName, 100) = 0) then
          begin
            showmessage(getUser(pName)+' now owns Hazy View');
            setOwner(pname, 2, 'Hazy View');
            HAZYVIEW := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (HAZYVIEW = True) and (properties[2] <> pName) then
      begin
        Showmessage(p+getUser(properties[2])+' R20');
        payP(pName, 20, properties[2]);
      end;
  end;

{JOBURG TAXI RANK - 6}
if XYPOS = 6 then
  begin
    if JTR = False then
      begin
        press := messagedlg(prop+'Joburg Taxi Rank ?',mtCustom, mbYesNo, 0);
        if (press = mrYes) and (buyP(pName, 150)= 0) then
          begin
            showmessage(getUser(pName)+' now owns the Joburg Taxi Rank');
            setOwner(pname, 3, 'Joburg Taxi Rank');
            JTR := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (JTR = True) and (properties[3] <> pName) then
      begin
        Showmessage(p+getUser(properties[3])+' R50');
        payP(pName, 50, properties[3]);
      end;
  end;

{WHITE RIVER - 7}
if XYPOS = 7 then
  begin
    if WHITERIVER = False then
      begin
        press := messagedlg(prop+'White River ?',mtCustom, mbYesNo, 0);
        if (press = mrYes) and (buyP(pName, 120)= 0) then
          begin
            showmessage(getUser(pName)+' now owns White River');
            setOwner(pname, 4, 'White River');
            WHITERIVER := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (WHITERIVER = True) and (properties[4] <> pName) then
      begin
        Showmessage(p+getUser(properties[4])+' R30');
        payP(pName, 30, properties[4]);
      end;
  end;

{NELSPRUIT - 9}
if XYPOS = 9 then
  begin
    if NELSPRUIT = False then
      begin
        press := messagedlg(prop+'Nelspruit ?',mtCustom, mbYesNo, 0);
        if (press = mrYes) and (buyP(pName, 140)= 0) then
          begin
            showmessage(getUser(pName)+' now owns Nelspruit');
            setOwner(pname, 5, 'Nelspruit');
            NELSPRUIT := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (NELSPRUIT = True) and (properties[5] <> pName) then
      begin
        Showmessage(p+getUser(properties[5])+' R35');
        payP(pName, 35, properties[5]);
      end;
  end;

{HERMANUS - 10}
if XYPOS = 10 then
  begin
    if HERMANUS = False then
      begin
        press := messagedlg(prop+'Hermanus ?',mtCustom, mbYesNo, 0);
        if (press = mrYes) and (buyP(pName, 160)= 0) then
          begin
            showmessage(getUser(pName)+' now owns Hermanus');
            setOwner(pname, 6, 'Hermanus');
            HERMANUS := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (HERMANUS = True) and (properties[6] <> pName) then
      begin
        Showmessage(p+getUser(properties[6])+' R40');
        payP(pName, 40, properties[6]);
      end;
  end;

{KIMBERLY - 12}
if XYPOS = 12 then
  begin
    if (KIMBERLY = False) and (buyP(pName, 180)= 0) then
      begin
        press := messagedlg(prop +'Kimberly ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Kimberly');
            setOwner(pname, 7, 'Kimberly');
            KIMBERLY := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (KIMBERLY = True) and (properties[7] <> pName) then
      begin
        Showmessage(p+getUser(properties[7])+' R45');
        payP(pName, 45, properties[7]);
      end;
  end;

{POLOKWANE - 13}
if XYPOS = 13 then
  begin
    if (POLOKWANE = False) and (buyP(pName, 200)= 0) then
      begin
        press := messagedlg(prop+'Polokwane ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Polokwane');
            setOwner(pname, 8, 'Polkwane');
            POLOKWANE := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (POLOKWANE = True) and (properties[8] <> pName) then
      begin
        Showmessage(p+getUser(properties[8])+' R50');
        payP(pName, 50, properties[8]);
      end;
  end;

{ELECTRICITY - 14}
if XYPOS = 14 then
  begin
    if (ELECTRICITY = False) and (buyP(pName, 100)= 0) then
      begin
        press := messagedlg(prop+'Electricity ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns the Electricity');
            setOwner(pname, 9, 'Electricity');
            ELECTRICITY := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (ELECTRICITY = True) and (properties[9] <> pName) then
      begin
        Showmessage(p+getUser(properties[9])+' R55');
        payP(pName, 55, properties[9]);
      end;
  end;

{PHALABORWA - 15}
if XYPOS = 15 then
  begin
    if (PHALABORWA = False) and (buyP(pName, 220)= 0) then
      begin
        press := messagedlg(prop+'Phalaborwa ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Phalaborwa');
            setOwner(pname, 10, 'Phalaborwa');
            PHALABORWA := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (PHALABORWA = True) and (properties[10] <> pName) then
      begin
        Showmessage(p+getUser(properties[10])+' R60');
        payP(pName, 60, properties[10]);
      end;
  end;

{STR- 16}
if XYPOS = 16 then
  begin
    if (STR = False) and (buyP(pName, 150)= 0) then
      begin
        press := messagedlg(prop+'Soweto Taxi Rank ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns the Soweto Taxi Rank');
            setOwner(pname, 11, 'Soweto Taxi Rank');
            STR := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (STR = True) and (properties[11] <> pName) then
      begin
        Showmessage(p+getUser(properties[11])+' R50');
        payP(pName, 50, properties[11]);
      end;
  end;

{GRASKOP - 17}
if XYPOS = 17 then
  begin
    if (GRASKOP = False) and (buyP(pName, 240)= 0) then
      begin
        press := messagedlg(prop+'Graskop ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Graskop');
            setOwner(pname, 12, 'Graskop');
            GRASKOP := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (GRASKOP = True) and (properties[12] <> pName) then
      begin
        Showmessage(p+getUser(properties[12])+' R65');
        payP(pName, 65, properties[12]);
      end;
  end;

{WELKOM - 19}
if XYPOS = 19 then
  begin
    if (WELKOM = False) and (buyP(pName, 260)= 0) then
      begin
        press := messagedlg(prop +'Welkom ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Welkom');
            setOwner(pname, 13, 'Welkom');
            WELKOM := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (WELKOM = True) and (properties[13] <> pName) then
      begin
        Showmessage(p+getUser(properties[13])+' R70');
        payP(pName, 70, properties[13]);
      end;
  end;

{VEREENIGING - 20}
if XYPOS = 20 then
  begin
    if (VEREENIGING = False) and (buyP(pName, 280)= 0) then
      begin
        press := messagedlg(prop+'Vereeeniging ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Vereeniging');
            setOwner(pname, 14, 'Vereeniging');
            VEREENIGING := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (VEREENIGING = True) and (properties[14] <> pName) then
      begin
        Showmessage(p+getUser(properties[14])+' R75');
        payP(pName, 75, properties[14]);
      end;
  end;

{WORCESTER - 22}
if XYPOS = 22 then
  begin
    if (WORCESTER = False) and (buyP(pName, 300)= 0) then
      begin
        press := messagedlg(prop+'Worcester ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Worcester');
            setOwner(pname, 15, 'Worcester');
            WORCESTER := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (WORCESTER = True) and (properties[15] <> pName) then
      begin
        Showmessage(p+getUser(properties[15])+' R80');
        payP(pName, 80, properties[15]);
      end;
  end;

{PORTALFRED - 24}
if XYPOS = 24 then
  begin
    if (PORTALFRED = False) and (buyP(pName, 320)= 0) then
      begin
        press := messagedlg(prop +'Port Alfred ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Port Alfred');
            setOwner(pname, 16, 'Port Alfred');
            PORTALFRED := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (PORTALFRED = True) and (properties[16] <> pName) then
      begin
        Showmessage(p+getUser(properties[16])+' R85');
        payP(pName, 85, properties[16]);
      end;
  end;

{KNYSNA - 25}
if XYPOS = 25 then
  begin
    if (KNYSNA = False) and (buyP(pName, 340)= 0) then
      begin
        press := messagedlg(prop+'Knysna ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Knysna');
            setOwner(pname, 17, 'Knysna');
            KNYSNA := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (KNYSNA = True) and (properties[17] <> pName) then
      begin
        Showmessage(p+getUser(properties[17])+' R90');
        payP(pName, 90, properties[17]);
      end;
  end;

{CTTR - 26}
if XYPOS = 26 then
  begin
    if (CTTR = False) and (buyP(pName, 150)= 0) then
      begin
        press := messagedlg(prop+'Cape Town Taxi Rank ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns the Cape Town Taxi Rank');
            setOwner(pname, 18, 'Cape Town Taxi Rank');
            CTTR := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (CTTR = True) and (properties[18] <> pName) then
      begin
        Showmessage(p+getUser(properties[18])+' R50');
        payP(pName, 50, properties[18]);
      end;
  end;

{RUSTENBURG - 27}
if XYPOS = 27 then
  begin
    if (RUSTENBURG = False) and (buyP(pName, 360)= 0) then
      begin
        press := messagedlg(prop+'Rustenburg ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Rustenburg');
            setOwner(pname, 19, 'Rustenburg');
            RUSTENBURG := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (RUSTENBURG = True) and (properties[19] <> pName) then
      begin
        Showmessage(p+getUser(properties[19])+' R95');
        payP(pName, 95, properties[19]);
      end;
  end;

{SOWETO - 28}
if XYPOS = 28 then
  begin
    if (SOWETO = False) and (buyP(pName, 380)= 0) then
      begin
        press := messagedlg(prop+'Soweto ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Soweto');
            setOwner(pname, 20, 'Soweto');
            RUSTENBURG := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (SOWETO = True) and (properties[20] <> pName) then
      begin
        Showmessage(p+getUser(properties[20])+' R100');
        payP(pName, 100, properties[20]);
      end;
  end;

{WATER - 29}
if XYPOS = 29 then
  begin
    if (WATER = False) and (buyP(pName, 100)= 0) then
      begin
        press := messagedlg(prop+'Water ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns the Water');
            setOwner(pname, 21, 'Water');
            WATER := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (WATER = True) and (properties[21] <> pName) then
      begin
        Showmessage(p+getUser(properties[21])+' R50');
        payP(pName, 50, properties[21]);
      end;
  end;

{GEORGE - 30}
if XYPOS = 30 then
  begin
    if (GEORGE = False) and (buyP(pName, 380)= 0) then
      begin
        press := messagedlg(prop+'George ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns George');
            setOwner(pname, 22, 'George');
            GEORGE := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (GEORGE = True) and (properties[22] <> pName) then
      begin
        Showmessage(p+getUser(properties[22])+' R105');
        payP(pName, 105, properties[22]);
      end;
  end;

{BLOEMFONTEIN - 32}
if XYPOS = 32 then
  begin
    if (BLOEMFONTEIN = False) and (buyP(pName, 380)= 0) then
      begin
        press := messagedlg(prop+'Bloemfontein ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Bloemfontein');
            setOwner(pname, 23, 'Bloemfontein');
            BLOEMFONTEIN := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (BLOEMFONTEIN = True) and (properties[23] <> pName) then
      begin
        Showmessage(p+getUser(properties[23])+' R110');
        payP(pName, 110, properties[23]);
      end;
  end;

{DURBAN - 33}
if XYPOS = 33 then
  begin
    if (DURBAN = False) and (buyP(pName, 400)= 0) then
      begin
        press := messagedlg(prop+'Durban ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Durban');
            setOwner(pname, 24, 'Durban');
            DURBAN := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (DURBAN = True) and (properties[24] <> pName) then
      begin
        Showmessage(p+getUser(properties[24])+' R115');
        payP(pName, 115, properties[24]);
      end;
  end;

{CAPETOWN - 35}
if XYPOS = 35 then
  begin
    if (CAPETOWN = False) and (buyP(pName, 400)= 0) then
      begin
        press := messagedlg(prop+'Cape Town ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Cape Town');
            setOwner(pname, 25, 'Cape Town');
            CAPETOWN := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (CAPETOWN = True) and (properties[25] <> pName) then
      begin
        Showmessage(p+getUser(properties[25])+' R120');
        payP(pName, 120, properties[25]);
      end;
  end;

{DTR - 36}
if XYPOS = 36 then
  begin
    if (DTR = False) and (buyP(pName, 150)= 0) then
      begin
        press := messagedlg(prop+'Durban Taxi Rank ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns the Durban Taxi Rank');
            setOwner(pname, 26, 'Durban Taxi Rank');
            DTR := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (DTR = True) and (properties[26] <> pName) then
      begin
        Showmessage(p+getUser(properties[26])+' R50');
        payP(pName, 50, properties[26]);
      end;
  end;

{PRETORIA - 38}
if XYPOS = 38 then
  begin
    if (PRETORIA = False) and (buyP(pName, 450)= 0) then
      begin
        press := messagedlg(prop+'Pretoria ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Pretoria');
            setOwner(pname, 27, 'Pretoria');
            PRETORIA := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (PRETORIA = True) and (properties[27] <> pName) then
      begin
        Showmessage(p+getUser(properties[27])+' R150');
        payP(pName, 150, properties[27]);
      end;
  end;

{JOBURG - 40}
if XYPOS = 40 then
  begin
    if (JOBURG = False) and (buyP(pName, 500)= 0) then
      begin
        press := messagedlg(prop+'Joburg ?',mtCustom, mbYesNo, 0);
        if press = mrYes then
          begin
            showmessage(getUser(pName)+' now owns Joburg');
            setOwner(pname, 28, 'Joburg');
            JOBURG := True;
          end;
        if press = mrNo then
          begin
            showmessage('no');
          end;
      end;
    if (JOBURG = True) and (properties[28] <> pName) then
      begin
        Showmessage(p+getUser(properties[28])+' R200');
        payP(pName, 200, properties[28]);
      end;
  end;

{start}
if XYPOS = 1 then
  begin
    spay(pname, 200);
  end;

{UBUNTUCHEST}
if (XYPOS = 3) or (XYPOS = 18) or (XYPOS = 34) then
  begin
    rand := randomrange(1,4);
    if rand = 1 then
      begin
        showmessage(Unit3.c1);
        ptax(pname);
      end;
    if rand = 2 then
      begin
        showmessage(Unit3.c2);
        ptax(pname);
        ptax(pname);
      end;
    if rand = 3 then
      begin
        showmessage(Unit3.c3);
        ptax(pname);
      end;
  end;

{POSSIBILITY}
if (XYPOS = 8) or (XYPOS = 23) or (XYPOS = 37) then
  begin
    rand := randomrange(1,4);
    if rand = 1 then
      begin
        showmessage(Unit3.po1);
        if (pName = 'P1')  then
          begin
            OWNP1.bal := OWNP1.bal +UC;
            UC := UC - UC;
          end;
        if (pName = 'P2')  then
          begin
            OWNP2.bal := OWNP2.bal +UC;
            UC := UC - UC;
          end;
      end;
    if rand = 2 then
      begin
        showmessage(Unit3.po2);
        ptax(pname);
      end;
    if rand = 3 then
      begin
        showmessage(Unit3.po3);
        showmessage('BANK MALFUNCTION !!!');
      end;
  end;

{pay Tax}
if (XYPOS = 5) or (XYPOS = 39) then
  begin
   ptax(pname);
  end;

{freeparking}
if XYPOS = 21 then
  begin
    if (pName = 'P1')  then
      begin
        OWNP1.bal := OWNP1.bal +UC;
        UC := UC - UC;
      end;
    if (pName = 'P2')  then
      begin
        OWNP2.bal := OWNP2.bal +UC;
        UC := UC - UC;
      end;



  end;

{GOTOJAIL}
if XYPOS = 31 then
  begin
    showmessage(j);
      if (pName = 'P1') and (OWNP1.bal > 0) then
      begin
        UC := UC + 50;
        OWNP1.bal := OWNP1.bal - 50;
      end;
    if (pName = 'P2') and (OWNP2.bal > 0) then
      begin
        UC := UC + 50;
        OWNP2.bal := OWNP2.bal - 50;
      end;

  end;


end;


procedure TC2.btnP1Click(Sender: TObject);
begin
P1STATS.show;
end;

procedure TC2.btnP2Click(Sender: TObject);
begin
P2STATS.show;
end;




procedure TC2.btnRDClick(Sender: TObject);
var
RD1: integer;
d: boolean;
begin
d := true;
RD1 := randomrange(1,7);
label3.caption := inttostr(Rd1);
if (c = 0) and (d = true) then
begin
  p1XY := P1XY + RD1;
  if p1XY > 40 then
    begin
      p1XY := 1;
    end;
  p1.Left := p1Xpos[p1XY];
  p1.Top := p1Ypos[p1XY];
  placement(p1XY, P1);
  label2.Caption := getUser('P1');
  d := false;
  c := 1;
end;
if (c = 1) and (d = true) then
begin
  p2XY := P2XY + RD1;
  if p2XY > 40 then
    begin
      p2XY := 1;
    end;
  p2.Left := p1Xpos[p2XY];
  p2.Top := p1Ypos[p2XY];
  placement(p2XY, P2);
  label2.Caption := getUser('P2');
  d := false;
  c := 0;
end;



end;

procedure TC2.Timer1Timer(Sender: TObject);
begin
label1.Caption := 'R '+inttostr(UC);
smP1.Lines.Strings[2] :='R ' + inttostr(OWNP1.bal);
smP2.Lines.Strings[2] :='R ' + inttostr(OWNP2.bal);
end;

end.
