program ClientProj;

uses
  Forms,
  ClientForm in 'ClientForm.pas' {Client};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClient, Client);
  Application.Run;
end.
