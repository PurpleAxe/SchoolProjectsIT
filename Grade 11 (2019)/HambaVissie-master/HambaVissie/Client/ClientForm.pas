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
unit ClientForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp, StdCtrls, ExtCtrls, ComCtrls, Spin, jpeg;

type
  TClient = class(TForm)
    socClient: TClientSocket;
    btnConnect: TButton;
    memoConnect: TMemo;
    pnlInit: TPanel;
    pgcInitTabs: TPageControl;
    tabSignIn: TTabSheet;
    tabRegister: TTabSheet;
    tabConnect: TTabSheet;
    btnSignIn: TButton;
    btnRegister: TButton;
    edtName: TEdit;
    edtSurname: TEdit;
    edtCellNumber: TEdit;
    edtUsername: TEdit;
    edtPassword: TEdit;
    cbxGender: TComboBox;
    spnedtAge: TSpinEdit;
    lblSrName: TLabel;
    lblName: TLabel;
    lblUser: TLabel;
    lblPass: TLabel;
    lblCN: TLabel;
    lblgender: TLabel;
    lblAge: TLabel;
    btnTRegister: TButton;
    edtUsrName: TEdit;
    edtPswd: TEdit;
    lblUSRNM: TLabel;
    lblPSWD: TLabel;
    btnTSignIn: TButton;
    pnlGame: TPanel;
    lbDeck: TListBox;
    btnSnap: TButton;
    btnStack: TButton;
    btnSignOut: TButton;
    pnlImg: TPanel;
    mainPNG: TImage;
    lblTitle: TLabel;
    lblClick: TLabel;
    edtHost: TEdit;
    edtPort: TEdit;
    lblIP: TLabel;
    lblPort: TLabel;
    btnConnectServer: TButton;
    imgPrevious: TImage;
    imgCurrent: TImage;
    lblPrevious: TLabel;
    lblCurrent: TLabel;
    procedure btnConnectClick(Sender: TObject);
    procedure socClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure btnSignInClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnTRegisterClick(Sender: TObject);
    procedure btnSignOutClick(Sender: TObject);
    procedure mainPNGClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConnectServerClick(Sender: TObject);
    procedure socClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure socClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure btnTSignInClick(Sender: TObject);
    procedure btnStackClick(Sender: TObject);
    procedure btnSnapClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Client: TClient;
  UID, serverCMD, sRName,
  sRSurname, sRCellNo, sRUsername,
  sRPassword, sRGender, sCurrent, sRecent: string;
  iRAge: integer;
implementation

{$R *.dfm}

procedure TClient.btnConnectClick(Sender: TObject);
begin
pgcInitTabs.ActivePageIndex := 2;

end;

procedure TClient.btnConnectServerClick(Sender: TObject);
begin
socClient.Host := edtHost.text;
socClient.Port := strtoint(edtPort.text);
socClient.Active := True;
end;

procedure TClient.btnRegisterClick(Sender: TObject);
begin
pgcInitTabs.ActivePageIndex := 1;
end;

procedure TClient.btnSignInClick(Sender: TObject);
begin
pgcInitTabs.ActivePageIndex := 0;
end;

procedure TClient.btnTRegisterClick(Sender: TObject);
begin
//Initiating variables for DB transfer
sRName := edtName.text;
sRSurname := edtSurname.Text;
sRCellNo := edtCellNumber.Text;
sRUsername := edtUsername.Text;
sRPassword := edtPassword.Text;
iRAge := spnedtAge.Value;
if cbxGender.ItemIndex = 0 then
  begin
    sRGender := 'F';
  end
else
  begin
    sRGender := 'M';
  end;
//INITIATE THE REGISTRATION PROCESS
if (sRName = '') or (sRSurname = '') or (sRCellNo = '') or (sRUsername = '') or (sRPassword = '') then
  begin
    showMessage('Please complete all fields');
  end
else
  begin
    socClient.Socket.SendText(UID+'DBINF'+'#RN'+sRName);
  end;

end;

procedure TClient.btnTSignInClick(Sender: TObject);
begin
//INITIATE SIGN IN PROCESS
socClient.Socket.SendText(UID+'DBINF'+'#VU'+edtUsrName.Text);
end;

procedure TClient.FormCreate(Sender: TObject);
begin
memoConnect.Lines.Add('Currently offline ...');
end;

procedure TClient.mainPNGClick(Sender: TObject);
begin
pnlGame.Visible := False;
pnlInit.Visible := True;
pnlImg.Visible := False;
end;

procedure TClient.btnSignOutClick(Sender: TObject);
begin
pnlGame.Visible := False;
pnlInit.Visible := False;
pnlImg.Visible := True;
edtPswd.Clear;
edtPassword.Clear;
edtUserName.Clear;
edtPassword.Clear;
edtCellNumber.Clear;
edtUsrName.Clear;
edtName.Clear;
edtSurname.Clear;
lbDeck.Clear;
socClient.active := False;
memoConnect.Clear;
memoConnect.Lines.Add('Currently offline...');
end;

//TO DETERMINE IF THE CARDS MATCH OR NOT
procedure TClient.btnSnapClick(Sender: TObject);
var
iDelim: integer;
sCCard, sPCard: string;
begin
iDelim := pos(' of ',sCurrent);
sCCard := copy(sCurrent,1,iDelim-1);

iDelim := pos(' of ',sRecent);
sPCard := copy(sRecent,1,iDelim-1);

if sCCard = sPCard then
  begin
    showMessage('HAMBA VISSIE!!!!');
    socClient.Socket.SendText(UID+'GAMRL'+'#HV');
  end;

end;

//SWAPPING CARDS CONTINUESLY
procedure TClient.btnStackClick(Sender: TObject);
begin
if lbDeck.Items.Strings[lbDeck.ItemIndex] = '' then
  begin
    showmessage('Please select a card with values on it');
  end
else
  begin
    socClient.Socket.SendText(UID+'GAMRL'+'BTNENABLE');
    btnStack.Enabled := false;
    socClient.Socket.SendText(UID+'GAMRL'+'#CR'+lbDeck.Items.Strings[lbDeck.ItemIndex]);
    lbDeck.Items.Strings[lbDeck.ItemIndex] := '';
  end;
end;

procedure TClient.socClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
memoConnect.Clear;
memoConnect.Lines.Add('Connected to server '+edtHost.Text+':'+edtPort.Text);
end;
//CATCH SOCKET ERRORS
procedure TClient.socClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
Showmessage('Unable to reach server');
socClient.Active := False;
end;

procedure TClient.socClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
iDeckNumber, iCurrentDeckNumber, i, iDelim: integer;
sCard: string;
begin
//Get commands from server
serverCMD := Socket.ReceiveText;
//Assign client a Unique IDentifier(UID)
if (copy(serverCMD,1,3) = 'HVP') and (length(serverCMD) = 5) then
  begin
    UID := serverCMD;
    memoConnect.Lines.Add('You are player '+copy(serverCMD, 4, 2));
  end;

//VALIDATION OF SIGN IN
if copy(serverCMD, 1, 3) = '#VU' then //VALIDATING USERNAME
  begin
    if copy(serverCMD, 4, length(serverCMD)) = 'TRUE' then
      begin
        memoConnect.Lines.Add('Found user in DB');
        socClient.Socket.SendText(UID+'DBINF'+'#VP'+edtPswd.Text);
      end;
    if copy(serverCMD, 4, length(serverCMD)) = 'FALSE' then
      begin
        showMessage('Username not found in our DataBase please try another username or Register');
      end;
  end;

if copy(serverCMD, 1, 3) = '#VP' then //VALIDATING PASSWORD
  begin
    if copy(serverCMD, 4, length(serverCMD)) = 'TRUE' then
      begin
        pnlInit.Visible := False;
        pnlGame.Visible := True;
        socClient.Socket.SendText(UID+'GAMRL'+'DEALCARDS');
      end;
    if copy(serverCMD, 4, length(serverCMD)) = 'FALSE' then
      begin
        edtPswd.Clear;
        Showmessage('INCORRECT PASSWORD');
      end;
  end;

//REHISATRATION TO SERVER
if serverCMD = '#RS' then
  begin
    socClient.Socket.SendText(UID+'DBINF'+'#RS'+sRSurname);
  end;
if serverCMD = '#RC' then
  begin
    socClient.Socket.SendText(UID+'DBINF'+'#RC'+sRCellNo);
  end;
if serverCMD = '#RU' then
  begin
    socClient.Socket.SendText(UID+'DBINF'+'#RU'+sRUsername);
  end;
if serverCMD = '#RP' then
  begin
    socClient.Socket.SendText(UID+'DBINF'+'#RP'+sRPassword);
  end;
if serverCMD = '#RA' then
  begin
    socClient.Socket.SendText(UID+'DBINF'+'#RA'+inttostr(iRAge));
  end;
if serverCMD = '#RG' then
  begin
    socClient.Socket.SendText(UID+'DBINF'+'#RG'+sRGender);
    pnlGame.Visible := True;
    pnlInit.Visible := False;
    socClient.Socket.SendText(UID+'GAMRL'+'DEALCARDS');
  end;

  //Cards Initiater
if copy(serverCMD,1,3) = '#CD' then
  begin
    sCard := copy(serverCMD,4,length(serverCMD));
    lbDeck.items.add(sCard);
  end;

  //STACK REFILLER
if copy(serverCMD,1,5) = 'STACK' then
  begin
    sCard := copy(serverCMD,6,length(serverCMD));
    lbDeck.items.add(sCard);
  end;

  //CARDS
if copy(serverCMD,1,3) = '#CR' then
  begin
    sRecent := sCurrent;
    sCurrent := copy(serverCMD,4,length(serverCMD));
    lblCurrent.Caption := sCurrent;
    lblPrevious.Caption := sRecent;
  end;

if serverCMD = 'ENABLE' then
  begin
    btnStack.Enabled := True;
  end;




end;

end.
