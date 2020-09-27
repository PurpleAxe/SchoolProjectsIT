program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit3 in 'Unit3.pas' {Form3},
  ATM in 'ATM.pas' {A_T_M},
  OWNP1 in 'OWNP1.pas' {P1STATS},
  OWNP2 in 'OWNP2.pas' {P2STATS},
  OWNP3 in 'OWNP3.pas' {P3STATS},
  OWNP4 in 'OWNP4.pas' {P4STATS},
  OWNC in 'OWNC.pas' {CSTATS},
  COMPUTERAI in 'COMPUTERAI.pas' {CF},
  COMPUTERP4 in 'COMPUTERP4.pas' {C4},
  COMPUTERP3 in 'COMPUTERP3.pas' {C3},
  COMPUTERP2 in 'COMPUTERP2.pas' {C2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'VISOPOLY(ALPHA 1.0)';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TA_T_M, A_T_M);
  Application.CreateForm(TP1STATS, P1STATS);
  Application.CreateForm(TP2STATS, P2STATS);
  Application.CreateForm(TP3STATS, P3STATS);
  Application.CreateForm(TP4STATS, P4STATS);
  Application.CreateForm(TCSTATS, CSTATS);
  Application.CreateForm(TCF, CF);
  Application.CreateForm(TC4, C4);
  Application.CreateForm(TC3, C3);
  Application.CreateForm(TC2, C2);
  Application.Run;
end.
