unit VGServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, clsDBConnections, Menus, ExtCtrls, StdCtrls, Spin,
  ComCtrls, DBCtrls, ADODB, IdContext, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, Sockets, ScktComp;

type
  TfrmServer = class(TForm)
    DBGUser: TDBGrid;
    DBGAgent: TDBGrid;
    DBGTrip: TDBGrid;
    DBGTraveller: TDBGrid;
    pnlAllGrids: TPanel;
    pnlSQL: TPanel;
    MainMenu: TMainMenu;
    Op1: TMenuItem;
    AllGirds1: TMenuItem;
    SQLGrid1: TMenuItem;
    DBGSQL: TDBGrid;
    btnSearchUser: TButton;
    btnMinBudget: TButton;
    btnAvgBudget: TButton;
    btnCellf3: TButton;
    UserCountry: TButton;
    btnSort: TButton;
    lblAnlytical: TLabel;
    edtCC: TEdit;
    edtName: TEdit;
    btnUserSort: TButton;
    pgcDBGrids: TPageControl;
    tabUsers: TTabSheet;
    tabAgent: TTabSheet;
    tabTraveller: TTabSheet;
    tabTrips: TTabSheet;
    edtUsername: TEdit;
    ServerConsole1: TMenuItem;
    pnlServ: TPanel;
    memoLog: TMemo;
    btnStart: TButton;
    btnStop: TButton;
    lblPort: TLabel;
    edtPort: TEdit;
    lblServ: TLabel;
    socServer: TServerSocket;
    lblPortn: TLabel;
    Help1: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure AllGirds1Click(Sender: TObject);
    procedure SQLGrid1Click(Sender: TObject);
    procedure btnSearchUserClick(Sender: TObject);
    procedure btnCellf3Click(Sender: TObject);
    procedure btnAvgBudgetClick(Sender: TObject);
    procedure btnMinBudgetClick(Sender: TObject);
    procedure UserCountryClick(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure btnUserSortClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ServerConsole1Click(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure socServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure socServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure socServerClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Help1Click(Sender: TObject);


  private
    { Private declarations }
    sSocStr : string;
  public
    { Public declarations }
  end;

var
  frmServer: TfrmServer;
  dbConn: TDBConnection;
  tblUsers, tblAgents, tblTravellers: TADOTable;
implementation

uses VGHelp;

{$R *.dfm}
//ALL GRIDS
procedure TfrmServer.AllGirds1Click(Sender: TObject);
begin
  pnlAllGrids.Visible := True;
  pnlSQL.Visible := False;
  pnlServ.Visible := False;
end;
 //AVG QUERY
procedure TfrmServer.btnAvgBudgetClick(Sender: TObject);
begin
  dbConn.runSQL('select max(DesiredBudget) as [HighestDesiredBudget] from Travellers');
end;
//Cellphone data
procedure TfrmServer.btnCellf3Click(Sender: TObject);
begin
  dbConn.runSQL('select CellNumber, LEFT(CellNumber, 3) as [First 3 Digits], RIGHT(CellNumber, 4) as [Last 4 Digits] from Users');
end;
//Sort query
procedure TfrmServer.btnSortClick(Sender: TObject);
begin
  dbConn.runSQL('select * from Users where CountryCode = '''+edtCC.text+''' or uName = '''+edtName.Text+'''');
  edtCC.Clear;
  edtName.Clear;
end;
//Start the server
procedure TfrmServer.btnStartClick(Sender: TObject);
begin
  socServer.Active := True;
  lblPortn.Caption := 'Listening on Port: ' + edtPort.Text;
  memoLog.Lines.Add('[SERVER] - Started at '+ TimeToStr(now) + ' on '+ DateToStr(now));
  btnStop.Visible := True;
  btnStart.Visible := False;
end;
//Stop server
procedure TfrmServer.btnStopClick(Sender: TObject);
var

  slLog: TStringList;
  logDate: TDateTime;
begin
socServer.Active := False;
  memoLog.Lines.Add('[SERVER] - Stopped at '+ TimeToStr(now)+ ' on '+ DateToStr(now));
  slLog := TStringList.Create;
  lblPortn.Caption := 'Listening on Port:';
  try
    logDate := now;
    slLog.add(memoLog.Text);
    slLog.SaveToFile('logs\Log-'+FormatDateTime('dd-mm-yyyy', logDate)+'.txt');
    btnStart.Visible := True;
    btnStop.Visible := False;
  finally
    slLog.free
  end;
end;
//Orderby Query for users
procedure TfrmServer.btnUserSortClick(Sender: TObject);
begin
  dbConn.runSQL('Select * from Users Order By CountryCode asc');
end;

procedure TfrmServer.UserCountryClick(Sender: TObject);
begin
  dbConn.runSQL('Select Travellers.HomeCountry, Agents.HomeCountry, Users.uName, Users.uSurname FROM Travellers INNER JOIN (Agents INNER JOIN Users ON Agents.AID = Users.AID) ON Travellers.TID = Users.TID');
end;
//user with smallest budget
procedure TfrmServer.btnMinBudgetClick(Sender: TObject);
begin
  dbConn.runSQL('select min(DesiredBudget) as [LowestDesiredBudget] from Travellers')
end;
// Search for a specific user in the repo
procedure TfrmServer.btnSearchUserClick(Sender: TObject);
begin
  dbConn.runSQL('Select * from Users where Username = '''+edtUsername.text+'''');
  edtUsername.Clear;
end;
//Start Form
procedure TfrmServer.FormActivate(Sender: TObject);
begin
  //Setup connections
  dbConn := TDBConnection.Create;
  dbConn.dbConnect;
  dbConn.setupAllGrids(DBGTrip, DBGAgent, DBGTraveller, DBGUser, DBGSQL);
end;
//WHEN FORM CLOSES
procedure TfrmServer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Disconnect from DB
  dbConn.dbDisconnect;
end;


procedure TfrmServer.Help1Click(Sender: TObject);
begin
  frmHelp.show;
end;

procedure TfrmServer.ServerConsole1Click(Sender: TObject);
begin
  //Change forms
  pnlServ.Visible := True;
  pnlAllGrids.Visible := False;
  pnlSQL.Visible := False;
end;

procedure TfrmServer.socServerClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //Send to client
  Socket.SendText('---------------VISAGO CHATROOM---------------'+#13);
  Socket.SendText('==============================');
  //log Client
  memoLog.Lines.Add('{CLIENT} - '+socket.ReceiveText);
end;

procedure TfrmServer.socServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
iSoc: integer;
begin
  memoLog.Lines.Add('{CLIENT} - User Left');
  for iSoc:=0 to socServer.Socket.ActiveConnections-1 do
    socServer.Socket.Connections[iSoc].SendText('A user left');
end;

procedure TfrmServer.socServerClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  iSoc:integer;
  sMsg: string;
begin
  //send messages to CLient
  sMsg := socket.ReceiveText;
  memoLog.Lines.Add('{CLIENT} - '+sMsg);
   for iSoc:=0 to socServer.Socket.ActiveConnections-1 do
      socServer.Socket.Connections[iSoc].SendText(sMsg);
end;

procedure TfrmServer.SQLGrid1Click(Sender: TObject);
begin
  //Change forms
  pnlAllGrids.Visible := False;
  pnlServ.Visible := False;
  pnlSQL.Visible := True;
end;

end.
