{
    HambaVissie is a multiplayer cardgame of snap
    Copyright (C) 2019  Andreas Visagie
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
unit ServForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScktComp, ExtCtrls, DBConnect, Grids, DBGrids, ADODB, Menus, Math;

const
    arrSuit:array[0..3] of string=('Hearts','Diamonds','Clubs','Spades');
    arrCards:array[0..11] of string=
            ('2','3','4','5','6','7','8','9','10',
            'Jack','Queen','King');

type
  TDeck = class(Tobject)
    arrDeckObj:array [0..47] of integer;
    NextCard:integer;
    constructor Create(Aowner:TComponent);
    Procedure Shuffle;
    Procedure setPlayerCards(iCNum, iMax: integer);
    function getSuit(CardNbr:integer):String;
    function getCardVal(CardNbr:integer):string;
    function GetNextCard(var card:string):boolean;
  end;
  TServer = class(TForm)
    socServer: TServerSocket;
    memoConsole: TMemo;
    rdgStartStop: TRadioGroup;
    dbgPlayers: TDBGrid;
    dbgMain: TDBGrid;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    btnReset: TButton;
    OpenLog1: TMenuItem;
    procedure socServerClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure rdgStartStopClick(Sender: TObject);
    procedure socServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure socServerClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ValidateUser(sV, sPNum: string; iCNum: integer);
    procedure ValidatePassword(sV, sPNum: string; iCNum: integer);
    procedure RegPlayerDB(sRegMSG: string; iCNum: integer);
    procedure Open1Click(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure addPoints(iCNum: integer; sPName:string);
    procedure OpenLog1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Server: TServer;
  ClientNum, iStack: integer;
  DBconn :TDBConnection;
  tblPlayers, tblMain: TADOTable;
  sPlayerOneName, sPlayerTwoName, sPlayerThreeName, sPlayerFourName: string;
  RegArray: array[1..7] of string;
  arrStack: array[1..48] of string;
  Deck:TDeck;



implementation

uses DBMainForm, LogForm;


{$R *.dfm}



procedure TServer.Open1Click(Sender: TObject);
begin
Server.Hide;
frmDBMain.show;
end;

procedure TServer.OpenLog1Click(Sender: TObject);
begin
frmLog.show;
end;

{##############################################################
 #                                                            #
 #                                                            #
 #                                                            #
 #                    CARDDECK METHODS                        #
 #                                                            #
 #                                                            #
 ##############################################################}
//NOTE THIS IDEA OF SHUFFLING CARDS WAS DONE BY AN UNKOWN USER
//This is Andreas's revamped version of the code to suit Hamba Vissie's Requirements, written by Andreas Visagie
Constructor TDeck.Create;
var
i:integer;
begin
  inherited Create;
  for i:= 0 to 51 do arrDeckobj[i]:=i;
end;

Procedure TDeck.Shuffle;
var
  i,j,swap:integer;
begin
  randomize;
  for i:= 47 downto 1 do
  Begin
    j:=random(i+1);
    swap := arrDeckobj[i];
    arrDeckobj[i] := arrDeckobj[j];
    arrDeckobj[j] := swap;
  end;
  Nextcard:=0;
end;

Function TDeck.getSuit(Cardnbr:integer):string;
begin
  result := arrSuit[arrDeckobj[Cardnbr] div 12]
end;

Function TDeck.GetCardVal(CardNbr:integer):string;
begin
  result := arrCards[arrDeckobj[cardnbr] mod 12];
end;

function TDeck.GetNextCard(var card:string):boolean;
begin
  If nextcard<=47 then
    Begin
      card:=getcardval(nextcard) + ' of '+ getsuit(nextcard);
      result:=true;
      inc(nextcard);
    end
  else
    begin
      result:=false;
    end;
end;

Procedure TDeck.setPlayerCards(iCNum, iMax: integer);
var
i: integer;
sCard: string;
begin
  Server.memoConsole.Lines.Add('GAMRL : ================DEALING CARDS================');
  Server.memoConsole.Lines.Add('GAMRL : Dealing cards to HVP0'+inttostr(iCNum+1));
  for i := iMax downto 1 do
    begin
      If Deck.getnextcard(sCard) = True then
        begin
          Server.memoConsole.Lines.add('GAMRL : Sending '+sCard+' to HVP0'+inttostr(iCNum));
          Server.socServer.Socket.Connections[iCNum].SendText('#CD'+sCard);
        end;
    end;
end;


{##############################################################
 #                                                            #
 #                                                            #
 #                                                            #
 #                    DATABASE METHODS                        #
 #                                                            #
 #                                                            #
 ##############################################################}

procedure TServer.addPoints(iCNum: integer; sPName:string);
var
i:integer;
begin
  for i := iStack downto 1 do
    begin
      socServer.Socket.Connections[iCNum].SendText('STACK'+arrStack[i]);
      iStack := iStack - 1;
      memoConsole.Lines.Add('GAMRL : HVP0'+inttostr(iCNum+1)+' is taking from the stack '+arrStack[i]);
      tblMain.first;

    end;
    while not tblMain.Eof do
        begin
          if sPName = tblMain['Username'] then
            begin
              tblMain.Edit;
              tblMain['Score'] := tblMain['Score'] + 20;
              tblMain.Post;
              Exit;
            end
          else
            begin
              tblMain.Next;
            end;
        end;
      while not tblPlayers.Eof do
        begin
          if sPName = tblPlayers['Username'] then
            begin
              tblPlayers.Edit;
              tblPlayers['Score'] := tblPlayers['Score'] + 20;
              tblPlayers.Post;
              Exit;
            end
          else
            begin
              tblPlayers.Next;
            end;
        end;
end;

procedure TServer.btnResetClick(Sender: TObject);
begin
Server.Close;
end;

procedure TServer.FormClose(Sender: TObject; var Action: TCloseAction);
var
LogFile: TextFile;

begin
DBconn.dbDisconnect;
//LOG
AssignFile(LogFile, 'Log.txt');
Rewrite(LogFile);
write(logFile, memoConsole.Text);
closefile(LogFile);
end;

procedure TServer.FormCreate(Sender: TObject);
var
  i:integer;
  card:string;
begin
iStack := 1;
clientNum := 0;
//Decks
Deck := TDeck.Create(self);
  Deck.shuffle; {shuffle the deck};
  For i:= 0 to 47 do   {Add shuffled cards to display}
    if deck.getnextcard(card) = True then
      begin
         deck.nextcard:=0;
      end;

//DBCONNECTIONS
  DBconn := TDBConnection.Create;
  DBconn.dbConnect;
  tblPlayers := DBconn.tblOne;
  tblMain := DBconn.tblMany;
  DBconn.setupGrids(dbgPlayers, dbgMain);
end;

procedure TServer.RegPlayerDB(sRegMSG: string; iCNum: integer);
var
iUID: integer;
begin
if copy(sRegMSG,1,3) = '#RN' then
  begin
    memoConsole.Lines.Add('DBINF : ================REGISTERING================');
    memoConsole.Lines.Add('DBINF : Initiating Registration process for HVP0'+inttostr(iCNum+1));
    RegArray[1] := copy(sRegMSG,4,length(sRegMSG));
    memoConsole.Lines.Add('DBINF : Adding '+RegArray[1]);
    socServer.Socket.Connections[iCNum].SendText('#RS');
  end;
if copy(sRegMSG,1,3) = '#RS' then
  begin
    RegArray[2] := copy(sRegMSG,4,length(sRegMSG));
    memoConsole.Lines.Add('DBINF : Adding '+RegArray[2]);
    socServer.Socket.Connections[iCNum].SendText('#RC');
  end;
if copy(sRegMSG,1,3) = '#RC' then
  begin
    RegArray[3] := copy(sRegMSG,4,length(sRegMSG));
    memoConsole.Lines.Add('DBINF : Adding '+RegArray[3]);
    socServer.Socket.Connections[iCNum].SendText('#RU');
  end;
if copy(sRegMSG,1,3) = '#RU' then
  begin
    RegArray[4] := copy(sRegMSG,4,length(sRegMSG));
    memoConsole.Lines.Add('DBINF : Adding '+RegArray[4]);
    socServer.Socket.Connections[iCNum].SendText('#RP');
  end;
if copy(sRegMSG,1,3) = '#RP' then
  begin
    RegArray[5] := copy(sRegMSG,4,length(sRegMSG));
    memoConsole.Lines.Add('DBINF : Adding '+RegArray[5]);
    socServer.Socket.Connections[iCNum].SendText('#RA');
  end;
if copy(sRegMSG,1,3) = '#RA' then
  begin
    RegArray[6] := copy(sRegMSG,4,length(sRegMSG));
    memoConsole.Lines.Add('DBINF : Adding '+RegArray[6]);
    socServer.Socket.Connections[iCNum].SendText('#RG');
  end;
if copy(sRegMSG,1,3) = '#RG' then
  begin
    RegArray[7] := copy(sRegMSG,4,length(sRegMSG));
    memoConsole.Lines.Add('DBINF : Adding '+RegArray[7]);

    //LOAD DATABASE WITH DATA
    tblPlayers.Append;
    tblPlayers['Name'] := RegArray[1];
    tblPlayers['Surname'] := RegArray[2];
    tblPlayers['CellNumber'] := RegArray[3];
    tblPlayers['Username'] := RegArray[4];
    tblPlayers['Password'] := RegArray[5];
    tblPlayers['Age'] := strtoint(RegArray[6]);
    tblPlayers['Gender'] := RegArray[7];
    tblPlayers.Post;
    iUID := tblPlayers['UID'];
    memoConsole.Lines.Add(inttostr(iUID));
    tblPlayers.last;
    tblMain.Append;
    tblMain['UID'] := iUID;
    tblMain['Name'] := RegArray[1];
    tblMain['Surname'] := RegArray[2];
    tblMain['Username'] := RegArray[4];
    tblMain.Post
  end;


end;

procedure TServer.ValidateUser(sV, sPNum: string; iCNum: integer);
var
bFound: boolean;
begin
if copy(sV,1,3) = '#VU' then //USERNAME VALIDATION
  begin
    bFound := False;
    memoConsole.Lines.Add('DBINF : ================VALIDATING================');
    memoConsole.Lines.Add('DBINF : Initiating Validation process for HVP0'+inttostr(iCNum+1));
    memoConsole.Lines.Add('DBINF : Validating...  '+copy(sV, 4, length(sV)));
    tblPlayers.First;
    while not tblPlayers.Eof do
      begin
        if tblPlayers['Username'] = copy(sV, 4, length(sV)) then
          begin
            memoConsole.Lines.Add('DBINF : Found '+copy(sV, 4, length(sV))+' in Players');
            socServer.Socket.Connections[iCNum].SendText('#VUTRUE');
            sPNum := tblPlayers['Username'];
            bFound := True;
            if iCNum = 0 then
              begin
                sPlayerOneName := sPNum;
              end
            else if iCNum = 1 then
              begin
                sPlayerTwoName := sPNum;
              end
            else if iCNum = 2 then
              begin
                sPlayerThreeName := sPNum;
              end
            else if iCNum = 3 then
              begin
                sPlayerFourName := sPNum;
              end;
            Exit;
          end
        else
          begin
            tblPlayers.Next;
            memoConsole.Lines.Add('DBINF : Next user');
          end;
      end;
    if bFound = False then
      begin
        memoConsole.Lines.Add('DBINF : User not found');
        socServer.Socket.Connections[iCNum].SendText('#VUFALSE');
      end;
  end;
end;

procedure TServer.ValidatePassword(sV, sPNum: string; iCNum: integer);
var
bFound: boolean;
begin
if copy(sV,1,3) = '#VP' then //PASSWORD VALIDATIOn
  begin
    bFound := False;
    tblPlayers.First;
    memoConsole.Lines.Add('DBINF : Matching password for '+sPNum);
    while not tblPlayers.Eof do
      begin
        if sPNum = tblPlayers['Username'] then
          begin
            if tblPlayers['Password'] = copy(sV, 4, length(sV)) then
              begin
                memoConsole.Lines.Add('DBINF : Password matches !, Granting game access to HVP0'+inttostr(iCNum+1));
                socServer.Socket.Connections[iCNum].SendText('#VPTRUE');
                bfound := True;
                Exit;
              end;
            if tblPlayers['Password'] <> copy(sV, 4, length(sV)) then
              begin
                memoConsole.Lines.Add('DBINF : Password Does not match, Denying game access to HVP0'+inttostr(iCNum+1));
                socServer.Socket.Connections[iCNum].SendText('#VPFALSE');
                bFound := False;
                exit;
              end;
          end
        else
          begin
            tblPlayers.next;
          end;
      end;
  end;
end;

{##############################################################
 #                                                            #
 #                                                            #
 #                                                            #
 #                    SERVER METHODS                          #
 #                                                            #
 #                                                            #
 ##############################################################}

procedure TServer.rdgStartStopClick(Sender: TObject);
begin
clientNum := 0;
if rdgStartStop.ItemIndex = 0 then
  begin
    socServer.Active := True;
    memoConsole.lines.add('Server : SERVER IS ONLINE !');
  end;
if rdgStartStop.ItemIndex = 1 then
  begin
    socServer.Active := False;
    memoConsole.lines.add('Server : Server is shutting down ...');
  end;
end;

procedure TServer.socServerClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//Notify CMDCONSOLE that players have joined
memoConsole.Lines.Add('Server : A client connected on ' + socServer.Socket.Connections[clientNum].RemoteAddress);
memoConsole.Lines.Add('Server : There are now '+inttostr(socServer.Socket.ActiveConnections)+' active clients.');

//Assigning each client with a UID (Unique IDentifier)
if socServer.Socket.ActiveConnections = 1 then
  begin
   socServer.Socket.Connections[0].SendText('HVP01');
  end;
if socServer.Socket.ActiveConnections = 2 then
  begin
   socServer.Socket.Connections[0].SendText('HVP01');
   socServer.Socket.Connections[1].SendText('HVP02');
  end;
if socServer.Socket.ActiveConnections = 3 then
  begin
   socServer.Socket.Connections[0].SendText('HVP01');
   socServer.Socket.Connections[1].SendText('HVP02');
   socServer.Socket.Connections[2].SendText('HVP03');
  end;
if socServer.Socket.ActiveConnections = 4 then
  begin
   socServer.Socket.Connections[0].SendText('HVP01');
   socServer.Socket.Connections[1].SendText('HVP02');
   socServer.Socket.Connections[2].SendText('HVP03');
   socServer.Socket.Connections[3].SendText('HVP04');
  end;
end;

procedure TServer.socServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
memoConsole.Lines.Add('Server : A client disconnected on ' + socServer.Socket.Connections[clientNum].RemoteAddress);
memoConsole.Lines.Add('Server : There are now '+inttostr(socServer.Socket.ActiveConnections-1)+' active clients.');
end;

{##############################################################
 #                                                            #
 #                                                            #
 #                                                            #
 #                    CLIENT HANDLER METHODS                  #
 #                                                            #
 #                                                            #
 ##############################################################}

procedure TServer.socServerClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
clientCMD, UID, CMD, MSG: string;
bFound: boolean;
i: integer;
card: string;
begin
clientCMD := Socket.ReceiveText;
UID := copy(clientCMD,1,5);
CMD := copy(clientCMD,6,5);
MSG := copy(clientCMD,11, length(clientCmd));

{##############################################################
 #                                                            #
 #                        ONE CLIENT                          #
 #                                                            #
 ##############################################################}

if socServer.Socket.ActiveConnections = 1 then
  begin
    //GAMERULE ALGORITHMS
    if CMD = 'GAMRL' then
      begin
        Socket.SendText('Please add more friends');
      end;
    //DATABASE ALGORITHMS
    if (CMD = 'DBINF') and (UID = 'HVP01') then //USER1
      begin
        ValidateUser(MSG, sPlayerOneName, 0);
        ValidatePassword(MSG, sPlayerOneName, 0);
        RegPlayerDB(MSG, 0);
      end;
  end;

{##############################################################
 #                                                            #
 #                        TWO CLIENTS                         #
 #                                                            #
 ##############################################################}


if socServer.Socket.ActiveConnections = 2 then
  begin
    //GAME RULE
    if (CMD = 'GAMRL') and (UID = 'HVP01') then
      begin
        if MSG = 'DEALCARDS' then
          begin
            Deck.setPlayerCards(0, 24);
          end;
        if copy(MSG,1,3) = '#CR' then
          begin
            arrStack[iStack] := copy(MSG, 4, length(MSG));
            memoConsole.Lines.Add('GAMRL : HVP01 added '+arrStack[iStack]+' to the stack');
            iStack := iStack + 1;
            socServer.Socket.Connections[0].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[1].SendText('#CR'+copy(MSG,4,length(MSG)));
          end;
        if MSG = 'BTNENABLE' then
          begin
            socServer.Socket.Connections[1].SendText('ENABLE');
          end;
        if copy(MSG,1,3) = '#HV' then
          begin
            addPoints(0,sPlayerOneName);
          end;

      end;
    if (CMD = 'GAMRL') and (UID = 'HVP02') then
      begin
        if MSG = 'DEALCARDS' then
          begin
            Deck.setPlayerCards(1, 24);
          end;
        if copy(MSG,1,3) = '#CR' then
          begin
            arrStack[iStack] := copy(MSG, 4, length(MSG));
            memoConsole.Lines.Add('GAMRL : HVP02 added '+arrStack[iStack]+' to the stack');
            iStack := iStack + 1;
            socServer.Socket.Connections[0].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[1].SendText('#CR'+copy(MSG,4,length(MSG)));
          end;
        if MSG = 'BTNENABLE' then
          begin
            socServer.Socket.Connections[0].SendText('ENABLE');
          end;
        if copy(MSG,1,3) = '#HV' then
          begin
             addPoints(1,sPlayerTwoName);
          end;
      end;

    //DATABASE ALGORITHMS
    if (CMD = 'DBINF') and (UID = 'HVP01') then //USER1
      begin
        ValidateUser(MSG, sPlayerOneName, 0);
        ValidatePassword(MSG, sPlayerOneName, 0);
        RegPlayerDB(MSG, 0);
      end;
    if (CMD = 'DBINF') and (UID = 'HVP02') then //USER2
      begin
        ValidateUser(MSG, sPlayerTwoName, 1);
        ValidatePassword(MSG, sPlayerTwoName, 1);
        RegPlayerDB(MSG, 1);
      end;
  end;

{##############################################################
 #                                                            #
 #                      THREE CLIENTS                         #
 #                                                            #
 ##############################################################}

if socServer.Socket.ActiveConnections = 3 then
  begin
    //GAME RULE
    if (CMD = 'GAMRL') and (UID = 'HVP01') then
      begin
        if MSG = 'DEALCARDS' then
          begin
            Deck.setPlayerCards(0, 16);
          end;
        if copy(MSG,1,3) = '#CR' then
          begin
            arrStack[iStack] := copy(MSG, 4, length(MSG));
            memoConsole.Lines.Add('GAMRL : HVP01 added '+arrStack[iStack]+' to the stack');
            iStack := iStack + 1;
            socServer.Socket.Connections[0].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[1].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[2].SendText('#CR'+copy(MSG,4,length(MSG)));
          end;
        if MSG = 'BTNENABLE' then
          begin
            socServer.Socket.Connections[1].SendText('ENABLE');
          end;
        if copy(MSG,1,3) = '#HV' then
          begin
             addPoints(0,sPlayerOneName);
          end;
      end;
    if (CMD = 'GAMRL') and (UID = 'HVP02') then
      begin
        if MSG = 'DEALCARDS' then
          begin
            Deck.setPlayerCards(1, 16);
          end;
        if copy(MSG,1,3) = '#CR' then
          begin
            arrStack[iStack] := copy(MSG, 4, length(MSG));
            memoConsole.Lines.Add('GAMRL : HVP02 added '+arrStack[iStack]+' to the stack');
            iStack := iStack + 1;
            socServer.Socket.Connections[0].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[1].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[2].SendText('#CR'+copy(MSG,4,length(MSG)));
          end;
        if MSG = 'BTNENABLE' then
          begin
            socServer.Socket.Connections[2].SendText('ENABLE');
          end;
       if copy(MSG,1,3) = '#HV' then
          begin
             addPoints(1,sPlayerTwoName);
          end;
      end;
    if (CMD = 'GAMRL') and (UID = 'HVP03') then
      begin
        if MSG = 'DEALCARDS' then
          begin
            Deck.setPlayerCards(2, 16);
          end;
        if copy(MSG,1,3) = '#CR' then
          begin
            arrStack[iStack] := copy(MSG, 4, length(MSG));
            memoConsole.Lines.Add('GAMRL : HVP03 added '+arrStack[iStack]+' to the stack');
            iStack := iStack + 1;
            socServer.Socket.Connections[0].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[1].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[2].SendText('#CR'+copy(MSG,4,length(MSG)));
          end;
        if MSG = 'BTNENABLE' then
          begin
            socServer.Socket.Connections[0].SendText('ENABLE');
          end;
       if copy(MSG,1,3) = '#HV' then
          begin
             addPoints(2,sPlayerThreeName);
          end;
      end;
    //DATABASE ALGORITHMS
    if (CMD = 'DBINF') and (UID = 'HVP01') then //USER1
      begin
        ValidateUser(MSG, sPlayerOneName, 0);
        ValidatePassword(MSG, sPlayerOneName, 0);
        RegPlayerDB(MSG, 0);
      end;
    if (CMD = 'DBINF') and (UID = 'HVP02') then //USER2
      begin
        ValidateUser(MSG, sPlayerTwoName, 1);
        ValidatePassword(MSG, sPlayerTwoName, 1);
        RegPlayerDB(MSG, 1);
      end;
    if (CMD = 'DBINF') and (UID = 'HVP03') then //USER3
      begin
        ValidateUser(MSG, sPlayerThreeName, 2);
        ValidatePassword(MSG, sPlayerThreeName, 2);
        RegPlayerDB(MSG, 2);
      end;
  end;

{##############################################################
 #                                                            #
 #                      FOUR CLIENTS                          #
 #                                                            #
 ##############################################################}


if socServer.Socket.ActiveConnections = 4 then
  begin
    //GAME RULE
    if (CMD = 'GAMRL') and (UID = 'HVP01') then
      begin
        if MSG = 'DEALCARDS' then
          begin
            Deck.setPlayerCards(0, 12);
          end;
        if copy(MSG,1,3) = '#CR' then
          begin
            arrStack[iStack] := copy(MSG, 4, length(MSG));
            memoConsole.Lines.Add('GAMRL : HVP01 added '+arrStack[iStack]+' to the stack');
            iStack := iStack + 1;
            socServer.Socket.Connections[0].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[1].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[2].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[3].SendText('#CR'+copy(MSG,4,length(MSG)));
          end;
        if MSG = 'BTNENABLE' then
          begin
            socServer.Socket.Connections[1].SendText('ENABLE');
          end;
       if copy(MSG,1,3) = '#HV' then
          begin
             addPoints(0,sPlayerOneName);
          end;
      end;
    if (CMD = 'GAMRL') and (UID = 'HVP02') then
      begin
        if MSG = 'DEALCARDS' then
          begin
            Deck.setPlayerCards(1, 12);
          end;
        if copy(MSG,1,3) = '#CR' then
          begin
            arrStack[iStack] := copy(MSG, 4, length(MSG));
            memoConsole.Lines.Add('GAMRL : HVP02 added '+arrStack[iStack]+' to the stack');
            iStack := iStack + 1;
            socServer.Socket.Connections[0].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[1].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[2].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[3].SendText('#CR'+copy(MSG,4,length(MSG)));
          end;
        if MSG = 'BTNENABLE' then
          begin
            socServer.Socket.Connections[2].SendText('ENABLE');
          end;
       if copy(MSG,1,3) = '#HV' then
          begin
             addPoints(1,sPlayerTwoName);
          end;
      end;
    if (CMD = 'GAMRL') and (UID = 'HVP03') then
      begin
        if MSG = 'DEALCARDS' then
          begin
            Deck.setPlayerCards(2, 12);
          end;
        if copy(MSG,1,3) = '#CR' then
          begin
            arrStack[iStack] := copy(MSG, 4, length(MSG));
            memoConsole.Lines.Add('GAMRL : HVP03 added '+arrStack[iStack]+' to the stack');
            iStack := iStack + 1;
            socServer.Socket.Connections[0].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[1].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[2].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[3].SendText('#CR'+copy(MSG,4,length(MSG)));
          end;
        if MSG = 'BTNENABLE' then
          begin
            socServer.Socket.Connections[3].SendText('ENABLE');
          end;
       if copy(MSG,1,3) = '#HV' then
          begin
             addPoints(2,sPlayerThreeName);
          end;
      end;
    if (CMD = 'GAMRL') and (UID = 'HVP04') then
      begin
        if MSG = 'DEALCARDS' then
          begin
            Deck.setPlayerCards(3, 12);
          end;
        if copy(MSG,1,3) = '#CR' then
          begin
            arrStack[iStack] := copy(MSG, 4, length(MSG));
            memoConsole.Lines.Add('GAMRL : HVP04 added '+arrStack[iStack]+' to the stack');
            iStack := iStack + 1;
            socServer.Socket.Connections[0].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[1].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[2].SendText('#CR'+copy(MSG,4,length(MSG)));
            socServer.Socket.Connections[3].SendText('#CR'+copy(MSG,4,length(MSG)));
          end;
        if MSG = 'BTNENABLE' then
          begin
            socServer.Socket.Connections[0].SendText('ENABLE');
          end;
           if copy(MSG,1,3) = '#HV' then
          begin
             addPoints(3,sPlayerFourName);
          end;
      end;
    //DATABASE ALGORITHMS
    if (CMD = 'DBINF') and (UID = 'HVP01') then //USER1
      begin
        ValidateUser(MSG, sPlayerOneName, 0);
        ValidatePassword(MSG, sPlayerOneName, 0);
        RegPlayerDB(MSG, 0);
      end;
    if (CMD = 'DBINF') and (UID = 'HVP02') then //USER2
      begin
        ValidateUser(MSG, sPlayerTwoName, 1);
        ValidatePassword(MSG, sPlayerTwoName, 1);
        RegPlayerDB(MSG, 1);
      end;
    if (CMD = 'DBINF') and (UID = 'HVP03') then //USER3
      begin
        ValidateUser(MSG, sPlayerThreeName, 2);
        ValidatePassword(MSG, sPlayerThreeName, 2);
        RegPlayerDB(MSG, 2);
      end;
    if (CMD = 'DBINF') and (UID = 'HVP04') then //USER4
      begin
        ValidateUser(MSG, sPlayerFourName, 3);
        ValidatePassword(MSG, sPlayerFourName, 3);
        RegPlayerDB(MSG, 3);
      end;
  end;

end;

end.
