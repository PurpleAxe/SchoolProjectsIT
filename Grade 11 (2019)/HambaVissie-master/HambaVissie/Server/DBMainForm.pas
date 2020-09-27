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
unit DBMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DBConnect, ADODB, StdCtrls;

type
  TfrmDBMain = class(TForm)
    dbgPlayers: TDBGrid;
    dbgMain: TDBGrid;
    dbgExec: TDBGrid;
    edtUsr: TEdit;
    btnDelete: TButton;
    btnSortNames: TButton;
    btnSortScores: TButton;
    btnShowHighScore: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSortNamesClick(Sender: TObject);
    procedure btnSortScoresClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnShowHighScoreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDBMain: TfrmDBMain;
  DBconn :TDBConnection;
  tblPlayers, tblMain: TADOTable;
implementation

uses ServForm;

{$R *.dfm}



procedure TfrmDBMain.btnDeleteClick(Sender: TObject);
begin
tblPlayers.First;
tblMain.First;
while not tblPlayers.Eof do
  begin
    if tblPlayers['Username'] = edtUsr.Text then
      begin
        tblPlayers.Delete;
        showMessage(edtUsr.text+' has been removed from tblPlayers');
        Exit;
      end
    else
      begin
        tblPlayers.Next;
      end;

  end;

while not tblMain.eof do
  begin
  if tblMain['Username'] = edtUsr.Text then
      begin
        tblMain.Delete;
        showMessage(edtUsr.text+' has been removed from tblMain');
        Exit;
      end
    else
      begin
        tblMain.Next;
      end;
  end;
end;

procedure TfrmDBMain.btnShowHighScoreClick(Sender: TObject);
var
j: integer;
begin
j := 0;
tblMain.First;
while not tblMain.eof do
  begin
    if j < tblMain['Score'] then
      begin
        j := tblMain['Score'];
      end
    else
      begin
        tblMain.Next;
      end;
  end;
tblMain.First;
while not tblMain.eof do
  begin
    if j = tblMain['Score'] then
      begin
        showMessage(tblMain['Name']+' has the highest score.');
        Exit;
      end
    else
      begin
        tblMain.Next;
      end;
  end;

end;

procedure TfrmDBMain.btnSortNamesClick(Sender: TObject);
begin
tblPlayers.Sort := 'Name DESC, Surname DESC';
tblMain.Sort := 'Name DESC, Surname DESC';
end;

procedure TfrmDBMain.btnSortScoresClick(Sender: TObject);
begin
tblMain.Sort := 'Score DESC';
end;

procedure TfrmDBMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Server.show;
DBconn.dbDisconnect;
end;

procedure TfrmDBMain.FormCreate(Sender: TObject);
begin
  DBconn := TDBConnection.Create;
  DBconn.dbConnect;
  tblPlayers := DBconn.tblOne;
  tblMain := DBconn.tblMany;
  DBconn.setupAllGrids(dbgPlayers, dbgMain, dbgExec);
end;

end.
