program VISServer;

uses
  Forms,
  VGServer in 'VGServer.pas' {frmServer},
  clsDBConnections in '..\Repository\clsDBConnections.pas',
  VGHelp in 'VGHelp.pas' {frmHelp};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmServer, frmServer);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.Run;
end.
