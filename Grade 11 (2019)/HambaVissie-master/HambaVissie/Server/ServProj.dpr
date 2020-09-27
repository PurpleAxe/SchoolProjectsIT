program ServProj;

uses
  Forms,
  ServForm in 'ServForm.pas' {Server},
  DBConnect in 'DBConnect.pas' {$R *.res},
  DBMainForm in 'DBMainForm.pas' {frmDBMain},
  LogForm in 'LogForm.pas' {frmLog};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServer, Server);
  Application.CreateForm(TfrmDBMain, frmDBMain);
  Application.CreateForm(TfrmLog, frmLog);
  Application.Run;
end.
