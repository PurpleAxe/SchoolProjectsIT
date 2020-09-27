unit VGTraveller;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, ComCtrls, DateUtils, ScktComp;

type
  TfrmTraveller = class(TForm)
    imgBGTraveller: TImage;
    pnlMain: TPanel;
    btnFindAgent: TPanel;
    btnSignOut: TPanel;
    memTripStats: TMemo;
    btnTripsOpen: TPanel;
    pnlTripPlan: TPanel;
    btnCancel: TPanel;
    btnDone: TPanel;
    edtDuration: TEdit;
    btnSend: TButton;
    edtChatMessage: TEdit;
    edtAccomodation: TEdit;
    edtBudget: TEdit;
    cbxAgentRating: TComboBox;
    pnlDeparted: TPanel;
    cbxDeparted: TCheckBox;
    pnlArrived: TPanel;
    cbxArrived: TCheckBox;
    lblDuration: TLabel;
    lblAcoomodation: TLabel;
    lblBudget: TLabel;
    pnlTravFindAgent: TPanel;
    btnTravFindAgent: TPanel;
    memRecAgent: TMemo;
    btnAcceptAgent: TPanel;
    cboxCountry: TComboBox;
    edtInitBudget: TEdit;
    edtInitTravellersAmt: TEdit;
    btnAgCancel: TPanel;
    lblSelCountry: TLabel;
    lblDesiredBudget: TLabel;
    lblTravAmt: TLabel;
    dtpStart: TDateTimePicker;
    lblStartDate: TLabel;
    dtpEnd: TDateTimePicker;
    lblEnddate: TLabel;
    pnlRating: TPanel;
    lblRating: TLabel;
    pnlRateDone: TPanel;
    socClient: TClientSocket;
    redtChatRoom: TRichEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTripsOpenClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSignOutClick(Sender: TObject);
    procedure btnFindAgentClick(Sender: TObject);
    procedure btnTravFindAgentClick(Sender: TObject);
    procedure btnAcceptAgentClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure rateAgent(iRating: integer);
    procedure btnSendClick(Sender: TObject);
    procedure pnlRateDoneClick(Sender: TObject);

    procedure socClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure socClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure socClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure socClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTraveller: TfrmTraveller;
  iAID: integer;

implementation

uses VGmain;

{$R *.dfm}
{##############################
#                             #
#     Client -> server        #
#                             #
###############################}
procedure TfrmTraveller.socClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  socket.SendText(frmMain.CurrentUser.getUsername+' joined'+#13);
end;

procedure TfrmTraveller.socClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   //These display to the User that they are offline
  showmessage('Server connection interupted'+#13+'Going to OFFLINE MODE');
  redtChatRoom.Clear;
  redtChatRoom.SelAttributes.Color := clRed;
  redtChatRoom.SelAttributes.Style := [fsBold];
  redtChatRoom.SelText := 'OFFLINE MODE';
  edtChatMessage.Clear;

end;

procedure TfrmTraveller.socClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  //These display to the User that they are offline
  showmessage('Server connection interupted'+#13+'Going to OFFLINE MODE');
  redtChatRoom.Clear;
  redtChatRoom.SelAttributes.Color := clRed;
  redtChatRoom.SelAttributes.Style := [fsBold];
  redtChatRoom.SelText := 'OFFLINE MODE';
  edtChatMessage.Clear;

end;

procedure TfrmTraveller.socClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  sUser, sMsg: string;
begin
//Receive Server messages
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
procedure TfrmTraveller.btnSendClick(Sender: TObject);
begin
//Send Message to Server
  socClient.socket.SendText(frmMain.CurrentUser.getUsername+': '+edtChatMessage.Text);
  edtChatMessage.Clear;
end;



{##############################
#                             #
#      PLAN TRIP EVENTS       #
#                             #
###############################}
//AGENT RATINGS
procedure TfrmTraveller.rateAgent(iRating: integer);
begin
// Rating of agent
  frmMain.tblAgents.Edit;
  frmMain.tblAgents['Rating'] := iRating;
  frmMain.tblAgents.Post;
end;

//Done button
procedure TfrmTraveller.btnDoneClick(Sender: TObject);
begin
  try
    frmMain.tblTrips.First;
    frmMain.tblAgents.First;
    if (edtAccomodation.Text = '') or (edtDuration.Text = '') or
      (edtBudget.Text = '') then
      begin
        showmessage('Not all fields are filled in');
      end
    else
      begin
       while not frmMain.tblTrips.Eof do
          begin
            if frmMain.tblTrips['TID'] = frmMain.CurrentUser.getTID then
              begin
              //update trip details
                frmMain.tblTrips.Edit;
                frmMain.tblTrips['ActualAccommodation'] := edtAccomodation.Text;
                frmMain.tblTrips['DesiredStayingTime'] := strtoint(edtDuration.Text);
                frmMain.tblTrips['ActualBudget'] := strtoint(edtBudget.Text);
                frmMain.tblTrips['Arrived'] := cbxArrived.Checked;
                frmMain.tblTrips['Departed'] := cbxDeparted.Checked;
                frmMain.tblTrips.Post;
                //Display on main memo
                currencystring := '$';
                memTripStats.Lines.Add('');
                memTripStats.Lines.Add('VISAGO');
                memTripStats.Lines.add('-----------------------------------------------------');
                memTripStats.Lines.Add('Time staying'+#9+#9+'| '+Inttostr(frmMain.tblTrips['DesiredStayingTime'])+' days');
                memTripStats.Lines.Add('Actual Budget:'+#9+#9+'| '+floattostrf(frmMain.tblTrips['ActualBudget'],ffcurrency,8,2));
                memTripStats.Lines.Add('Actual Accommodation:'+#9+'| '+frmMain.tblTrips['ActualAccommodation']);
                if frmMain.tblTrips['Departed'] = true
                  then memTripStats.Lines.Add('Departed:'+#9+#9+#9+'| '+'True')
                  else memTripStats.Lines.Add('Departed:'+#9+#9+#9+'| '+'False');
                if frmMain.tblTrips['Arrived'] = true
                  then memTripStats.Lines.Add('Arrived:'+#9+#9+#9+'| '+'True')
                  else memTripStats.Lines.Add('Arrived:'+#9+#9+#9+'| '+'False');
                memTripStats.Lines.Add('-----------------------------------------------------');
                memTripStats.Lines.Add('Thank you for using VISAGO, we hope to see you again!');
                if cbxArrived.Checked = true then
                    begin
                    //DELETE TRIP ROW if arrived
                      frmMain.tblTrips.Delete;
                      {!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
                       btnFindAgent.Visible := True;
                       btnTripsOpen.Visible := False;
                    end;
                    pnlMain.visible := False;
                  pnlTripPlan.Visible := False;
                  pnlRating.Visible := True;
                exit;
              end
            else
              begin
                frmMain.tblTrips.Next;
              end;
          end;
      end;
  except on E:EXCEPTION do
    begin
    //error, generally occurs after user has just accepted agent, hence the program sometimes needs a restart
      showmessage('Please re-Login as an error occured');
      frmMain.Close;
      frmTraveller.Close;
    end;
  end;

end;


{##############################
#                             #
#    FIND AGENTS EVENTS       #
#                             #
###############################}
//Accept Agent
procedure TfrmTraveller.btnAcceptAgentClick(Sender: TObject);
begin
  if (cboxCountry.ItemIndex = -1) or (edtInitBudget.Text = '') or (edtInitTravellersAmt.Text = '') then
    begin
      showmessage('Please make sure all fields are filled in');
    end
  else
    begin
    // Append trips table for AGent accepted and Traveller
      frmMain.tblTrips.Insert;
      frmMain.tblTrips['TID'] := frmMain.CurrentUser.getTID;
      frmMain.tblTrips['AID'] := iAID;
      frmMain.tblTrips['Destination'] := cboxCountry.Text;
      frmMain.tblTrips['StartDate'] := DateOf(dtpStart.Date);
      frmMain.tblTrips['EndDate'] := DateOf(dtpEnd.Date);
      frmMain.tblTrips.Post;
      frmMain.tblTravellers.Locate('TID', frmMain.CurrentUser.getTID, []);
      frmMain.tblTravellers.Edit;
              frmMain.tblTravellers['DesiredDestination'] := cboxCountry.Text;
              frmMain.tblTravellers['AmountTravellers'] := strtoint(edtInitTravellersAmt.Text);
              frmMain.tblTravellers['DesiredBudget'] := strtoint(edtInitBudget.Text);
      frmMain.tblTravellers.Post;
      pnlMain.Visible := True;
      pnlTripPlan.Visible := False;
      pnlTravFindAgent.Visible := False;
      memRecAgent.Visible := False;
      btnAcceptAgent.Visible := False;
      frmMain.tblAgents.First;
      btnFindAgent.Visible := False;
      btnTripsOpen.Visible := True;
    end;


end;

//Traveller finds agent
procedure TfrmTraveller.btnTravFindAgentClick(Sender: TObject);
var
i: integer;
begin
  frmMain.tblUsers.First;
  memRecAgent.Visible := True;
  memRecAgent.Clear;
  memRecAgent.lines.Add('Stats');
  memRecAgent.Lines.Add('');
  btnAcceptAgent.Visible := True;
  //find Agents
  while not frmMain.tblUsers.eof do
    begin
      if (frmMain.tblAgents['AID'] = frmMain.CurrentUser.getAID) then
        begin
          frmMain.tblAgents.Next;
          exit;
        end
      else if (frmMain.tblUsers['AID'] = 0) then
        begin
          frmMain.tblUsers.Next;
        end
      else if (frmMain.tblUsers['AID'] = frmMain.tblAgents['AID'])then
        begin
        //Display Agents found that are available
          iAID := frmMain.tblAgents['AID'];
          memRecAgent.Lines.Add('Username: '+frmMain.tblUsers['Username']);
          memRecAgent.Lines.Add('User Rating: '+inttostr(frmMain.tblAgents['Rating']));
          memRecAgent.Lines.Add('Phone Number: '+frmMain.tblUsers['CountryCode']
                                +' '+inttostr(frmMain.tblUsers['CellNumber']));
          memRecAgent.Lines.Add('Email: '+frmMain.tblUsers['Email']);
          frmMain.tblAgents.Next;
          exit;
        end
      else
        begin
          frmMain.tblUsers.Next;
        end;
    end;

end;


{##############################
#                             #
#         FORM EVENTS         #
#                             #
###############################}
//ALL PANELS GO TO MAIN PANEL

procedure TfrmTraveller.btnCancelClick(Sender: TObject);
begin
  //clear all Fields
  pnlMain.Visible := True;
  pnlTripPlan.Visible := False;
  pnlTravFindAgent.Visible := False;
  memRecAgent.Visible := False;
  btnAcceptAgent.Visible := False;
  frmMain.tblAgents.First;
  cbxAgentRating.ItemIndex := -1;
  edtAccomodation.Clear;
  edtBudget.Clear;
  edtChatMessage.Clear;
  edtDuration.Clear;
  cboxCountry.ItemIndex := -1;
  edtInitBudget.Clear;
  edtInitTravellersAmt.Clear;
end;

//OPEN FIND AGENTS PANEL
procedure TfrmTraveller.btnFindAgentClick(Sender: TObject);
begin
  pnlTravFindAgent.Visible := True;
  pnlMain.Visible := False;
end;

procedure TfrmTraveller.btnSignOutClick(Sender: TObject);
begin
 frmMain.Close;
end;
//OPEN TRIPS PANEL
procedure TfrmTraveller.btnTripsOpenClick(Sender: TObject);
begin
  pnlMain.visible := false;
  pnlTripPlan.Visible := True;
end;
//WHEN FORM IS ACTIVE
procedure TfrmTraveller.FormActivate(Sender: TObject);
var
  iIndex: Integer;
begin
  //Start Socket
  socClient.Active := True;
  //Setup Form
   btnFindAgent.Visible := True;
   btnTripsOpen.Visible := False;
   frmMain.tblTrips.First;
   //Check if Traveller has trip already planned
  while not frmMain.tblTrips.Eof do
    begin
      if frmMain.tblTrips['TID'] = frmMain.CurrentUser.getTID then
        begin
          btnFindAgent.Visible := False;
          btnTripsOpen.Visible := True;
          memTripStats.Lines.Add('Destination: '+frmMain.tblTrips['Destination']);
          frmMain.tblUsers.Locate('AID', frmMain.tblTrips['AID'], []);
          memTripStats.Lines.Add('Agent: '+frmMain.tblUsers['Username']);
          memTripStats.Lines.Add('');
          exit;
        end
      else
        begin
          frmMain.tblTrips.Next;
        end;
    end;
    //populate Country COmbo box
  pnlMain.visible := True;
  pnlTripPlan.Visible := False;
  for iIndex := 1 to length(frmMain.arrCountries) do
    begin
      cboxCountry.Items[iIndex-1] := frmMain.arrCountries[iIndex];
    end;
  frmMain.tblAgents.First;
end;
//WHEN FORM CLOSES
procedure TfrmTraveller.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.Close;

end;



procedure TfrmTraveller.pnlRateDoneClick(Sender: TObject);
begin
  //Rating Agent
  case cbxAgentRating.ItemIndex of
    0 : rateAgent(0);
    1 : rateAgent(1);
    2 : rateAgent(2);
    3 : rateAgent(3);
    4 : rateAgent(4);
    5 : rateAgent(5);
  end;
  pnlMain.visible := True;
  pnlRating.Visible := False;
end;

end.
