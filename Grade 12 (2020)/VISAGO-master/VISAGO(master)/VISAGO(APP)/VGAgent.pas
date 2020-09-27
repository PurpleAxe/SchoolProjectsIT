unit VGAgent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, ComCtrls, ScktComp;

type
  TfrmAgent = class(TForm)
    imgBGAgent: TImage;
    pnlEdtMain: TPanel;
    btnEdtTD: TPanel;
    edtChatMessage: TEdit;
    redtChatRoom: TRichEdit;
    lblSelTrip: TLabel;
    btnSignOut: TPanel;
    btnFindTravellers: TPanel;
    btnSend: TButton;
    lbTrips: TListBox;
    redtStats: TRichEdit;
    pnlFindTrav: TPanel;
    btnFTCancel: TPanel;
    lbSelTrip: TListBox;
    lblVisit: TLabel;
    btnHelpTrav: TPanel;
    pnlTripPlan: TPanel;
    btnCancel: TPanel;
    btnPost: TPanel;
    redtTravPlan: TRichEdit;
    edtAccomodation: TEdit;
    pnlCheckBoc: TPanel;
    cbBudget: TCheckBox;
    socClient: TClientSocket;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbTripsClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSignOutClick(Sender: TObject);
    procedure btnFTCancelClick(Sender: TObject);
    procedure btnFindTravellersClick(Sender: TObject);
    procedure btnEdtTDClick(Sender: TObject);
    procedure btnHelpTravClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure socClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure socClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure socClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure socClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAgent: TfrmAgent;
  iTID, iTIDindex: integer;
  arrTID: array [1..1000] of integer;


implementation

uses VGmain;

{$R *.dfm}
{##############################
#                             #
#     Client -> server        #
#                             #
###############################}
procedure TfrmAgent.socClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  socket.SendText(frmMain.CurrentUser.getUsername+' joined'+#13);
end;


procedure TfrmAgent.socClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   //These display to the User that they are offline
  showmessage('Server connection interupted'+#13+'Going to OFFLINE MODE');
  redtChatRoom.Clear;
  redtChatRoom.SelAttributes.Color := clRed;
  redtChatRoom.SelAttributes.Style := [fsBold];
  redtChatRoom.SelText := 'OFFLINE MODE';
end;

procedure TfrmAgent.socClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  //These display to the User that they are offline
  showmessage('Server connection interupted'+#13+'Going to OFFLINE MODE');
  redtChatRoom.Clear;
  redtChatRoom.SelAttributes.Color := clRed;
  redtChatRoom.SelAttributes.Style := [fsBold];
  redtChatRoom.SelText := 'OFFLINE MODE';

end;

procedure TfrmAgent.socClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  sUser, sMsg: string;
begin
  sMsg := Socket.ReceiveText;
  sUser := copy(sMsg, 1, pos(':', sMsg)-1);
  //Format for specific User
  if sUser = frmMain.CurrentUser.getUsername then
    begin
        redtChatRoom.SelAttributes.Style := [fsBold];
        redtChatRoom.SelText := 'Me: '+copy(sMsg, pos(':', sMsg)+1, length(sMsg))+#13;
        redtChatRoom.SelAttributes.Color := clWhite;
        redtChatRoom.SelAttributes.Style := [];
    end
  else
    begin
    //return to Regular format
      redtChatRoom.Lines.Add(sMsg);
    end;
end;

//SERVER CONNECTION
procedure TfrmAgent.btnSendClick(Sender: TObject);
begin
//Send Message to Server
  socClient.socket.SendText(frmMain.CurrentUser.getUsername+': '+edtChatMessage.Text);
  edtChatMessage.Clear;
end;



{##############################
#                             #
#         FIND EVENTS         #
#          FORM               #
###############################}
procedure TfrmAgent.btnFTCancelClick(Sender: TObject);
begin
  //Cancel Method
  pnlEdtMain.Visible := True;
  pnlFindTrav.Visible := False;
  pnlTripPlan.Visible := False;
  redtTravPlan.Clear;
end;
//Help Traveller
procedure TfrmAgent.btnHelpTravClick(Sender: TObject);
var
sSelTrip: string;
begin
try
//Transfer lbSelTrips to lbTrips
  sSelTrip := lbSelTrip.Items[lbSelTrip.ItemIndex];
  if frmMain.tblUsers.Locate('TID', arrTID[lbSelTrip.ItemIndex+1], []) then
    begin
      lbTrips.Items.Add(frmMain.tblUsers['Username']);
    end
  else
    begin
      showmessage('An error ocurred');
    end;
  pnlEdtMain.Visible := True;
  pnlFindTrav.Visible := False;
  pnlTripPlan.Visible := False;
except on E: Exception do
  showmessage('Please select a Traveller');
end;
end;

//POST ITEMS TO DB
procedure TfrmAgent.btnPostClick(Sender: TObject);
begin
  pnlEdtMain.Visible := True;
  pnlFindTrav.Visible := False;
  pnlTripPlan.Visible := False;
  redtTravPlan.Clear;
  frmMain.tblAgents.Locate('AID', frmMain.CurrentUser.getAID,[] );
  frmMain.tblAgents.Edit;
  frmMain.tblAgents['RecommendedAccommodation'] := edtAccomodation.Text;
  frmMain.tblAgents.Post;
  frmMain.tblTrips.Locate('AID', frmMain.CurrentUser.getAID, []);
  //check if Agent agrees with budget
  if cbBudget.Checked = True then
    begin
      frmMain.tblTrips.Edit;
      frmMain.tblTrips['Status'] := 'Good';
      frmMain.tblTrips.Post;
    end
  else
    begin
      frmMain.tblTrips.Edit;
      frmMain.tblTrips['Status'] := 'Bad';
      frmMain.tblTrips.Post;
    end;

end;

{##############################
#                             #
#         MAIN EVENTS         #
#         FORM                #
###############################}
//Trip D
procedure TfrmAgent.btnEdtTDClick(Sender: TObject);
begin
  //Display all Travellers details
  try
    currencystring := '$';
    pnlEdtMain.Visible := False;
    pnlTripPlan.Visible := True;
    frmMain.tblUsers.Locate('Username',lbTrips.Items[lbtrips.ItemIndex], []);
    frmMain.tblTravellers.Locate('TID', frmMain.tblUsers['TID'], []);
    redtTravPlan.Lines.Add('Travellers Plan');
    redtTravPlan.Lines.Add('');
    redtTravPlan.Lines.Add('Desired Destination: '+frmMain.tblTravellers['DesiredDestination']);
    redtTravPlan.Lines.Add('Amount of Travellers: '+inttostr(frmMain.tblTravellers['AmountTravellers']));
    redtTravPlan.Lines.Add('Desired Budget: '+floattostrf(frmMain.tblTravellers['DesiredBudget'], ffcurrency, 8 ,2));
  except on E:Exception do
   showmessage('Please select a Traveller');
  end;
  end;

//Siwtch Forms
procedure TfrmAgent.btnFindTravellersClick(Sender: TObject);
begin
  pnlEdtMain.Visible := False;
  pnlFindTrav.Visible := True;
end;



//EXIT PROGRAM
procedure TfrmAgent.btnSignOutClick(Sender: TObject);
begin
  frmMain.Close;
end;

//Formactivated
procedure TfrmAgent.FormActivate(Sender: TObject);
begin
//Start Client socket
  socClient.Active := True;
  //Find all Travellers intereeted in the agent
  iTIDindex := 1;
  redtStats.Lines.Add('STATs');
  frmMain.tblTrips.First;
  while not frmMain.tblTrips.Eof do
    begin 
      if frmMain.tblTrips['AID'] = frmMain.CurrentUser.getAID then
        begin
          arrTID[iTIDindex] := frmMain.tblTrips['TID'];
          iTIDindex := iTIDindex+1;
          frmMain.tblUsers.Locate('TID', frmMain.tblTrips['TID'], []);
          // populate Listbox for select trips
          lbSelTrip.items.Add(frmMain.tblUsers['Username']);
          redtStats.Lines.Add('');
          frmMain.tblAgents.Locate('AID', frmMain.CurrentUser.getAID, []);
          redtStats.Lines.Add('Rating: '+inttostr(frmMain.tblAgents['Rating']));
        end;
      frmMain.tblTrips.Next;
    end;
  
end;
//EXIT PROGRAM
procedure TfrmAgent.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.Close;
end;

procedure TfrmAgent.lbTripsClick(Sender: TObject);
begin
  try
  //Get Trip details and display
  lblSelTrip.Caption := 'Trip currently selected: '+lbTrips.Items.Strings[lbTrips.ItemIndex];
  except on E: Exception do
    showmessage('Please select a Traveller');
  end;
end;


end.
