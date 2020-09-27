unit clsDBConnections;

interface

uses
  SysUtils, Classes, DB, ADODB, StdCtrls, DBGrids, DBCtrls, Controls, Dialogs, Forms;

type
  TDBConnection = class(TObject)
  private
    {Private}
  public
    //VAR
    dbConnection: TADOConnection;
    dsrTrip, dsrAgent, dsrTraveller, dsrUsr, dsrQRYsql: TDataSource;
    tblTrip, tblAgent, tblTraveller, tblUsr: TADOTable;
    qrySQL: TADOQuery;
    //METHODS
    procedure dbConnect;
    procedure dbDisconnect;
    procedure runSQL(sSQL: string);
    procedure setupTripGrid(var GridTrip: TDBGrid);
    procedure setupAgentGrid(var GridAgent: TDBGrid);
    procedure setupTravellerGrid(var GridTraveller: TDBGrid);
    procedure setupUsrGrid(var GridUsr: TDBGrid);
    procedure setupSQLGrid(var GridSQL: TDBGrid);
    procedure setupAllGrids(var GridTrip, GridAgent, GridTraveller, GridUsr, GridSQL: TDBGrid);
  end;

implementation

{ TDBConnection }
const
DBFileName: string = '..\Repository\VisagoRep.mdb';

var
//Form to place all Database methods
//Dynamic Component
  DBForm: TForm;

{##############################
#                             #
#     CONNECT TO DATABASE     #
#                             #
##############################}
procedure TDBConnection.dbConnect;
begin
  {ESTABLISH CONNECT TO THE DATABASE}
  dbConnection := TADOConnection.Create(DBForm);
  dbConnection.LoginPrompt := False;
  dbConnection.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;' + 'Data Source=' + DBFileName + ';' +
    'Mode=ReadWrite;' + 'Persist Security Info=False;' +
    'Jet OLEDB:Database Password=';
  dbConnection.Provider := 'Provider=Microsoft.Jet.OLEDB.4.0;';
  dbConnection.Open;

  {SQL QUERY}
  qrySQL := TADOQuery.Create(DBForm);
    qrySQL.Connection := dbConnection;

  {CONNECT TO TRIPs TABLE}
  tblTrip := TADOTable.Create(DBForm);
    tblTrip.Connection := dbConnection;
    tblTrip.TableName := 'Trips';
    tblTrip.Open;
    tblTrip.Sort := 'TripID ASC';
    tblTrip.First;
  {CONNECT TO AGENTs TABLE}
  tblAgent := TADOTable.Create(DBForm);
    tblAgent.Connection := dbConnection;
    tblAgent.TableName := 'Agents';
    tblAgent.Open;
    tblAgent.Sort := 'AID ASC';
    tblAgent.First;
  {CONNECT TO TRAVELLERs TABLE}
  tblTraveller := TADOTable.Create(DBForm);
    tblTraveller.Connection := dbConnection;
    tblTraveller.TableName := 'Travellers';
    tblTraveller.Open;
    tblTraveller.sort := 'TID ASC';
    tblTraveller.First;
  {CONNECT TO USERs TABLE}
  tblUsr := TADOTable.Create(DBForm);
    tblUsr.Connection := dbConnection;
    tblUsr.TableName := 'Users';
    tblUsr.Open;
    tblUsr.Sort := 'UID ASC';
    tblUsr.First;

  {ESTABLISH DATASOURCEs}
  dsrTrip := TDataSource.Create(DBForm);
    dsrTrip.DataSet := tblTrip;
  dsrAgent := TDataSource.Create(DBForm);
    dsrAgent.DataSet := tblAgent;
  dsrTraveller := TDataSource.Create(DBForm);
    dsrTraveller.DataSet := tblTraveller;
  dsrUsr := TDataSource.Create(DBForm);
    dsrUsr.DataSet := tblUsr;
  dsrQRYsql := TDataSource.Create(DBForm);
    dsrQRYsql.DataSet := qrySQL;

end;

{##############################
#                             #
#  DISCONNECT FROM DATABASE   #
#                             #
##############################}
procedure TDBConnection.dbDisconnect;
begin
{BREAK CONNECTIONS BETWEEN TABLES AND DB}
  qrySQL.Free;
    qrySQL := nil;
  tblTrip.Free;
    tblTrip := nil;
  tblTraveller.Free;
    tblTraveller := nil;
  tblAgent.Free;
    tblAgent := nil;
  tblUsr.Free;
    tblUsr := nil;
  dbConnection.Close;
    dbConnection.Free;
    dbConnection := nil;
end;



{##############################
#                             #
#     RUN SQL COMMANDS        #
#                             #
##############################}
procedure TDBConnection.runSQL(sSQL: string);
begin
  if length(sSQL) <> 0 then
    begin
    //Run SQL command
      qrySQL.Close;
      qrySQL.SQL.Text := sSQL;
      qrySQL.Open;
    end
  else
    begin
      showmessage('SQL STRING IS EMPTY !');
    end;
end;

{##############################
#                             #
#GRID SETUPS TO DISPLAY TABLES#
#                             #
##############################}
procedure TDBConnection.setupAgentGrid(var GridAgent: TDBGrid);
begin
  GridAgent.DataSource := dsrAgent;
end;

procedure TDBConnection.setupAllGrids(var GridTrip, GridAgent, GridTraveller,
  GridUsr, GridSQL: TDBGrid);
begin
//apply datasource to Grid
  GridTrip.DataSource := dsrTrip;
  GridAgent.DataSource := dsrAgent;
  GridSQL.DataSource := dsrQRYsql;
  GridTraveller.DataSource := dsrTraveller;
  GridUsr.DataSource := dsrUsr;
end;
 //setup Grids according to variables
procedure TDBConnection.setupSQLGrid(var GridSQL: TDBGrid);
begin
  GridSQL.DataSource := dsrQRYsql;
end;

procedure TDBConnection.setupTravellerGrid(var GridTraveller: TDBGrid);
begin
  GridTraveller.DataSource := dsrTraveller;
end;

procedure TDBConnection.setupTripGrid(var GridTrip: TDBGrid);
begin
  GridTrip.DataSource := dsrTrip;
end;

procedure TDBConnection.setupUsrGrid(var GridUsr: TDBGrid);
begin
  GridUsr.DataSource := dsrUsr;
end;

end.
