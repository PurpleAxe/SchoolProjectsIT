program VISAGO;

uses
  Forms,
  VGmain in 'VGmain.pas' {frmMain},
  clsCurrentUser_u in 'clsCurrentUser_u.pas',
  VGTraveller in 'VGTraveller.pas' {frmTraveller},
  VGAgent in 'VGAgent.pas' {frmAgent},
  clsDBConnections in '..\Repository\clsDBConnections.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTraveller, frmTraveller);
  Application.CreateForm(TfrmAgent, frmAgent);
  Application.Run;
end.
