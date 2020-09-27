unit VGmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, GIFImg, StdCtrls, pngimage, clsDBConnections, ADODB, clsCurrentUser_u;

type
  TfrmMain = class(TForm)
    LogoGIF: TImage;
    LogoShape: TShape;
    lblLogo: TLabel;
    imgBGMain: TImage;
    ButtonEffectTimer: TTimer;
    pnlInit: TPanel;
    btnLogin: TPanel;
    btnRegister: TPanel;
    pnlLogin: TPanel;
    edtUsrName: TEdit;
    edtPassword: TEdit;
    imgEYEL: TImage;
    imgEYEO: TImage;
    btnCheckLogin: TPanel;
    btnLoginExt: TPanel;
    pnlRegister: TPanel;
    edtRegUsername: TEdit;
    edtRegSurname: TEdit;
    edtRegName: TEdit;
    edtRegCellNumber: TEdit;
    edtRegPassword: TEdit;
    edtRegEmail: TEdit;
    lblSurname: TLabel;
    lblEmail: TLabel;
    lblUsername: TLabel;
    lblPassword: TLabel;
    lblCell: TLabel;
    lblName: TLabel;
    cbxCountryCode: TComboBox;
    cbxHomeCountry: TComboBox;
    lblHC: TLabel;
    lblCC: TLabel;
    btnAgentOnly: TPanel;
    btnTravellerOnly: TPanel;
    btnTravellerAgent: TPanel;
    btnRegCancel: TPanel;
    lblStatus: TLabel;
    lblLPassword: TLabel;
    lblusrName: TLabel;
    pnlSelect: TPanel;
    imgLogoSelect: TImage;
    imgLogoLogin: TImage;
    btnSelTraveller: TPanel;
    btnSelAgent: TPanel;
    lblSel: TLabel;
    imgLogoReg: TImage;
    lblDate: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonEffectTimerTimer(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure imgEYELClick(Sender: TObject);
    procedure imgEYEOClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoginExtClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnAgentOnlyClick(Sender: TObject);
    procedure btnRegCancelClick(Sender: TObject);
    procedure btnTravellerAgentClick(Sender: TObject);
    function isRegisterValid: boolean;
    function isUserNameAble: boolean;
    procedure btnTravellerOnlyClick(Sender: TObject);
    procedure cbxHomeCountryChange(Sender: TObject);
    procedure btnCheckLoginClick(Sender: TObject);
    procedure clearAllEdits();
    procedure runLogoGIF(sImg: TImage);
    procedure btnSelTravellerClick(Sender: TObject);
    procedure btnSelAgentClick(Sender: TObject);
    procedure edtRegCellNumberChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  CurrentUser: TCurrentUser;
  tblUsers,tblAgents, tblTravellers, tblTrips: TADOTable;
  arrCountries: array[1..234]of string;
  end;

var
  frmMain: TfrmMain;
  iAnimTime: integer = 0;
  dbConnection: TDBConnection;
  arrCountryCodes: array[1..234] of string;


implementation

uses VGTraveller, VGAgent;

{$R *.dfm}

{#############################
#                            #
#      Select Events         #
#                            #
##############################}
procedure TfrmMain.btnSelAgentClick(Sender: TObject);
begin
  frmAgent.Show;
  frmMain.Hide;
  clearAllEdits();
end;

procedure TfrmMain.btnSelTravellerClick(Sender: TObject);
begin
  frmTraveller.Show;
  frmMain.Hide;
  clearAllEdits();
end;

{#############################
#                            #
#    Register Events         #
#                            #
##############################}
//Automatically assign CountryCode with code # this can be changed
procedure TfrmMain.cbxHomeCountryChange(Sender: TObject);
begin
  cbxCountryCode.ItemIndex := cbxHomeCountry.ItemIndex;
end;


//make sure all fields entered are valid
function TfrmMain.isRegisterValid: boolean;
begin
//Nested if statements for data validation
  if (edtRegName.Text = '') or (edtRegSurname.text = '') or
            (edtRegCellNumber.Text = '') or (edtRegUsername.Text = '') or
              (edtRegPassword.Text = '') or (edtRegEmail.Text = '') then
      begin
        showmessage('Please make sure all fields are filled');
        Result := False;
      end
  else if cbxHomeCountry.ItemIndex = -1 then
    begin
      showmessage('Please select a country');
      Result := False;
    end
  else if cbxCountryCode.ItemIndex = -1 then
    begin
      showmessage('Please select a country code');
      Result := False;
    end
  else if (pos('@', edtRegEmail.Text) = 0) or (pos('.', edtRegEmail.Text) = 0) then
    begin
      showmessage('Email is invalid, E.g visago@gmail.com');
      Result := False;
    end
  else if length(edtRegCellNumber.Text) < 7 then
    begin
      showmessage('Cell Number is too short');
      result := false;
    end
  else if length(edtRegCellNumber.Text) > 10 then
    begin
      showmessage('Cell Number is too Long');
      result := false;
    end
  else if length(edtRegPassword.Text) < 8 then
    begin
       showmessage('Please make sure your password is greater than 8 characters');
      result := false;
    end

  else
    begin
      Result := True;
    end;
end;
//Find Out if Username is in use or not
function TfrmMain.isUserNameAble: boolean;
begin
  tblUsers.First;
  while not tblUsers.Eof do
    begin
      if tblUsers['Username'] = edtRegUsername.Text then
        begin
          showmessage('Username : '+edtRegUsername.Text+' is already taken');
          Result := False;
          exit;
        end
      else
        begin
          tblUsers.Next;
          result := True;
        end;
    end;
end;


//Validate Username
procedure TfrmMain.btnRegCancelClick(Sender: TObject);
begin
  clearAllEdits();
end;

//TRAVELLER AND AGENT
procedure TfrmMain.btnTravellerAgentClick(Sender: TObject);
begin
  try
    if (isRegisterValid = False) or (isUserNameAble = False) then
      begin
        exit;
      end
    else
      begin
      //insert Traverller and agent into DB
        lblStatus.Caption := 'Loading Traveller Table';
        tblTravellers.Insert;
        tblTravellers['HomeCountry'] := cbxHomeCountry.Text;
        tblTravellers.Post;
        tblTravellers.Last;
        lblStatus.Caption := 'Loading Agent Table';
        tblAgents.Insert;
        tblAgents['HomeCountry'] := cbxHomeCountry.Text;
        tblAgents.Post;
        tblAgents.Last;
        lblStatus.Caption := 'Loading User Table';
        tblUsers.Insert;
          tblUsers['uName'] := edtRegName.Text;
          tblUsers['uSurname'] := edtRegSurname.text;
          tblUsers['Email'] := edtRegEmail.Text;
          tblUsers['CountryCode'] := cbxCountryCode.Text;
          tblUsers['CellNumber'] := strtoint(edtRegCellNumber.Text);
          tblUsers['Username'] := edtRegUsername.Text;
          tblUsers['Password'] := edtRegPassword.Text;
          tblUsers['AID'] := tblAgents['AID'];
          tblUsers['TID'] := tblTravellers['TID'];
        tblUsers.Post;
        lblStatus.Caption := 'Data Posted';
        showmessage('Please Close the application and Open it again'+#13
                +'Your user has been Registered'+#13
                +'When you open the application please LOGIN'+#13
                +'NO ERROR OCCURED');
      end;
  except on E:Exception do
    showmessage('Please Close the application and Open it again'+#13
                +'Your user has been Registered'+#13
                +'When you open the application please LOGIN'+#13
                +'AN ERROR OCCURED');

  end;
end;

//TRAVELLER
procedure TfrmMain.btnTravellerOnlyClick(Sender: TObject);
begin
  try
    if (isRegisterValid = False) or (isUserNameAble = False) then
      begin
        exit;
      end
    else
      begin
      //Insert Traveller into DB
        tblTravellers.Insert;
        tblTravellers['HomeCountry'] := cbxHomeCountry.Text;
        tblTravellers.Post;
        tblTravellers.Last;
        tblUsers.Append;
          tblUsers['uName'] := edtRegName.Text;
          tblUsers['uSurname'] := edtRegSurname.text;
          tblUsers['Email'] := edtRegEmail.Text;
          tblUsers['CountryCode'] := cbxCountryCode.Text;
          tblUsers['CellNumber'] := strtoint(edtRegCellNumber.Text);
          tblUsers['Username'] := edtRegUsername.Text;
          tblUsers['Password'] := edtRegPassword.Text;
          tblUsers['TID'] := tblTravellers['TID'];
        tblUsers.Post;
        showmessage('Please Close the application and Open it again'+#13
                +'Your user has been Registered'+#13
                +'When you open the application please LOGIN'+#13
                +'NO ERROR OCCURED');
    end;
  except on E:Exception do
  //Errir catches
    showmessage('Please Close the application and Open it again'+#13
                +'Your user has been Registered'+#13
                +'When you open the application please LOGIN'+#13
                +'AN ERROR OCCURED');
  end;
end;

//AGENT
procedure TfrmMain.btnAgentOnlyClick(Sender: TObject);
begin
  try
    if isRegisterValid = False then
      begin

      end
    else
      begin
      //insert Agent into DB
        lblStatus.Caption := 'Loading Agent Table';
        tblAgents.Insert;
          tblAgents['HomeCountry'] := cbxHomeCountry.Text;
        tblAgents.Post;
        tblAgents.Last;
        lblStatus.Caption := 'Loading User Table';
        tblUsers.Insert;
          tblUsers['uName'] := edtRegName.Text;
          tblUsers['uSurname'] := edtRegSurname.text;
          tblUsers['Email'] := edtRegEmail.Text;
          tblUsers['CountryCode'] := cbxCountryCode.Text;
          tblUsers['CellNumber'] := strtoint(edtRegCellNumber.Text);
          tblUsers['Username'] := edtRegUsername.Text;
          tblUsers['Password'] := edtRegPassword.Text;
          tblUsers['AID'] := tblAgents['AID'];
        tblUsers.Post;
        lblStatus.Caption := 'Data Posted';
        showmessage('Please Close the application and Open it again'+#13
                +'Your user has been Registered'+#13
                +'When you open the application please LOGIN'+#13
                +'NO ERROR OCCURED');
      end;
  except on E:Exception do
    showmessage('Please Close the application and Open it again'+#13
                +'Your user has been Registered'+#13
                +'When you open the application please LOGIN'+#13
                +'AN ERROR OCCURED');

  end;
end;

{#############################
#                            #
#       Login Events         #
#                            #
##############################}
//Verify Login events
procedure TfrmMain.btnCheckLoginClick(Sender: TObject);
begin
  tblUsers.First;
  //make sure login is correct
  while not tblUsers.Eof do
    begin
      if tblUsers['Username'] = edtUsrName.Text then
        begin
        //add user to current user class for multiform use
          CurrentUser := TCurrentUser.Create(edtUsrName.Text, edtPassword.Text,
                                            tblUsers['UID'], tblUsers['TID'],
                                            tblUsers['AID']);
          CurrentUser.Login(tblUsers['Username'], tblUsers['Password']);
            if CurrentUser.verifyLogin = True then
              begin
                if CurrentUser.getAID = 0 then
                  begin
                    frmTraveller.show;
                    frmMain.Hide;
                    clearAllEdits();
                  end
                else if CurrentUser.getTID = 0 then
                  begin
                    frmAgent.show;
                    frmMain.Hide;
                    clearAllEdits();
                  end
                else
                  begin
                    pnlSelect.Visible := true;
                    pnlLogin.Visible := false;
                    pnlRegister.Visible := false;
                  end;
              end
            else
              begin
                showmessage('Incorrect Password');
                edtPassword.Text := '';
              end;
          exit;
        end
      else
        begin
          tblUsers.Next;
        end;
    end;
showmessage('Username '+edtUsrName.Text+' does not exist');
end;
//Back to main menu
procedure TfrmMain.btnLoginExtClick(Sender: TObject);
begin
  clearAllEdits();
end;
//EYE CLOSED
procedure TfrmMain.imgEYELClick(Sender: TObject);
begin
  imgEYEL.Visible := false;
  imgEYEO.Visible := true;
  edtPassword.PasswordChar := #0;
end;
//EYE OPEM
procedure TfrmMain.imgEYEOClick(Sender: TObject);
begin
  imgEYEO.Visible := false;
  imgEYEL.Visible := true;
  edtPassword.PasswordChar := '●';
end;

{#############################
#                            #
#       Time  Events         #
#                            #
##############################}
// animation for welcoming screen
procedure TfrmMain.ButtonEffectTimerTimer(Sender: TObject);
begin
  iAnimTime := iAnimTime + 1;
  case iAnimTime of
    1 : begin
      btnLogin.Caption := 'W E ';
      btnRegister.Caption := 'V I';
    end;
    2 : begin
      btnLogin.Caption := 'W E L C';
      btnRegister.Caption := 'V I S A';
    end;
    3 : begin
      btnLogin.Caption := 'W E L C O M E';
      btnRegister.Caption := 'V I S A G O';
    end;
    4 : begin
      btnLogin.Caption := 'WELCOME!';
      btnRegister.Caption := 'VISAGO';
    end;
    5 : begin
      btnLogin.Caption := 'Login';
      btnRegister.Caption := 'Register';
    end;
    6 : ButtonEffectTimer.Enabled := false;
  end;
end;

{##############################
#                             #
#         FORM EVENTS         #
#                             #
###############################}
//Clears all edit boxes for the frames
procedure TfrmMain.clearAllEdits;
begin
    pnlLogin.visible := false;
    pnlInit.Visible := true;
    pnlRegister.Visible := false;
    pnlSelect.Visible := false;
    edtUsrName.Text := '';
    edtPassword.Text := '';
    edtRegUsername.Text := '';
    edtRegName.Text := '';
    edtRegSurname.Text := '';
    edtRegPassword.Text := '';
    edtRegCellNumber.Text := '';
    edtRegEmail.Text := '';
    cbxHomeCountry.ItemIndex := -1;
    cbxCountryCode.ItemIndex := -1;
    lblStatus.Caption := '';
end;
procedure TfrmMain.edtRegCellNumberChange(Sender: TObject);
var
  iCatch: integer;
begin
  try
    iCatch := StrToInt(edtRegCellNumber.Text);
  except on E:exception do
    begin
      edtRegCellNumber.text := '0';
      showmessage('Please enter numbers only!'+#13+' E.g 0874567899');
    end;

  end;
end;

//REGISTER FRAM
procedure TfrmMain.btnRegisterClick(Sender: TObject);
var
iIndex: integer;
begin
  //populate arrays and comboboxes with countries etc...
  iIndex := 0;
    clearAllEdits();
  pnlLogin.Visible := False;
  pnlInit.Visible := false;
  pnlRegister.Visible := True;
  for iIndex := 1 to length(arrCountryCodes) do
    begin
      cbxCountryCode.Items[iIndex-1] := arrCountryCodes[iIndex];
      cbxHomeCountry.Items[iIndex-1] := arrCountries[iIndex];
    end;

end;

//Login Frame
procedure TfrmMain.btnLoginClick(Sender: TObject);
begin
  pnlLogin.Visible := true;
  pnlInit.Visible := false;
  pnlRegister.Visible :=False;
end;
//CLose form
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
dbConnection.dbDisconnect;
end;

//Let logo run GIF
procedure TfrmMain.runLogoGIF(sImg: TImage);
begin
  //animate GIF
 (sImg.Picture.Graphic as TGIFImage).Animate := true;
 (sImg.Picture.Graphic as TGIFImage).AnimationSpeed := 45;
end;
//Create Form
procedure TfrmMain.FormCreate(Sender: TObject);
var
CCFile: TextFile;
sRawLine: string;
iIndex: integer;
begin
  lblDate.Caption := 'Today - '+DateToStr(date);
  iIndex := 1;
  runLogoGIF(LogoGIF);
  runLogoGIF(imgLogoLogin);
  runLogoGIF(imgLogoSelect);
  runLogoGIF(imgLogoReg);
 ButtonEffectTimer.Enabled := true;

 try
 assignfile(CCFile,'CountryCodes.txt');
 reset(CCFile);
 except on E : Exception do
  begin
    showmessage('CountryCodes.txt file is missing');
    Application.Terminate;
    Exit;
  end;
 end;
 //extract COuntries out of text file
 while not eof(CCFile) do
  begin
    readln(CCFile, sRawLine);
    arrCountryCodes[iIndex] := '+'+copy(sRawLine, 1, pos(' --- ',sRawLine)-1);
    arrCountries[iIndex] := copy(sRawLine, pos(' --- ',sRawLine)+5, length(sRawLine));
    iIndex := iIndex + 1;
  end;
 closefile(CCFile);
 //establish DB connections
 dbConnection := TDBConnection.create;
 dbConnection.dbConnect;
 tblTrips := dbConnection.tblTrip;
 tblAgents := dbConnection.tblAgent;
 tblUsers := dbCOnnection.tblUsr;
 tblTravellers := dbConnection.tblTraveller;
 end;

end.
