{This unit is a reproduction of the Grade 12 (CAPS) exam papers for connecting
Databases to the form}
unit DBConnect;

interface

uses
  Forms, SysUtils, Classes, DB, ADODB, StdCtrls, DBGrids, DBCtrls,
  Windows;

type
  TDBConnection = class(TObject)
  public
    //Public variables
    dbConnection: TADOConnection;
    dsrOne, dsrMany, dsrQRYA, dsrQRYB: TDataSource;
    tblOne, tblMany: TADOTable;
    qryA, qryB: TADOQuery;
    //Public Procedures
    procedure dbConnect;
    procedure dbDisconnect;
    procedure setupGrids(var GridOne, GridMany: TDBGrid);
    procedure runSQL(sSQL: string);
    procedure setupAllGrids(var GridOne, GridMany, GridSQL: TDBGrid);
  end;

var
  DBForm: TForm;

implementation
  //FOR TDBConnection
  uses
    Controls, Dialogs;

  const
    DBFile: string = 'DB_HAMVIS.mdb';
    TBLOneName: string = 'tblPlayers';
    TBLManyName: string = 'tblMain';

procedure TDBConnection.dbConnect;
begin
  dbConnection := TADOConnection.Create(DBForm);
  dbConnection.LoginPrompt := False;
  dbConnection.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;' + 'Data Source=' + DBFile + ';' +
    'Mode=ReadWrite;' + 'Persist Security Info=False;' +
    'Jet OLEDB:Database Password=';
  dbConnection.Provider := 'Provider=Microsoft.Jet.OLEDB.4.0;';
  dbConnection.Open;

  tblOne := TADOTable.Create(DBForm);
  tblOne.Connection := dbConnection;
  tblOne.TableName := TBLOneName;
  tblOne.Open;
  tblOne.First;

  tblMany := TADOTable.Create(DBForm);
  tblMany.Connection := dbConnection;
  tblMany.TableName := TBLManyName;
  tblMany.Open;
  tblMany.First;

  qryA := TADOQuery.Create(DBForm);
  qryA.Connection := dbConnection;

  dsrOne := TDataSource.Create(DBForm);
  dsrOne.DataSet := tblOne;
  dsrMany := TDataSource.Create(DBForm);
  dsrMany.DataSet := tblMany;
  dsrQRYA := TDataSource.Create(DBForm);
  dsrQRYA.DataSet := qryA;
end;

procedure TDBConnection.dbDisconnect;
begin
  qryA.Free;
  qryA := nil;
  qryB.Free;
  qryB := nil;
  tblOne.Free;
  tblOne := nil;
  tblMany.Free;
  tblMany := nil;
  dbConnection.Close;
  dbConnection.Free;
  dbConnection := nil;
end;

procedure TDBConnection.runSQL(sSQL: string);
begin
  if length(sSQL) <> 0 then
  begin
    qryA.Close;
    qryA.SQL.Text := sSQL;
    qryA.Open;
  end
  else
    Showmessage('No SQL statement entered');
end;

procedure TDBConnection.setupGrids(var GridOne, GridMany: TDBGrid);
begin
  GridOne.datasource := dsrOne;
  GridMany.datasource := dsrMany;
end;

procedure TDBConnection.setupAllGrids(var GridOne, GridMany, GridSQL: TDBGrid);
begin
  GridOne.datasource := dsrOne;
  GridMany.datasource := dsrMany;
  GridSQL.datasource := dsrQRYA;
end;

end.
