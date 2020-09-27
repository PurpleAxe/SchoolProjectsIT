unit OWNP2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TP2STATS = class(TForm)
    BMemo: TMemo;
    PMemo: TMemo;
    CMemo: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Timer1: TTimer;
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  P2STATS: TP2STATS;
  bal: integer;

implementation

uses ATM;

{$R *.dfm}

procedure TP2STATS.Button1Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP2STATS.Button2Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP2STATS.Button3Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP2STATS.Button4Click(Sender: TObject);
begin
showmessage('Bank Unavailable');
end;

procedure TP2STATS.Button5Click(Sender: TObject);
begin
A_T_M.show;
ATM.P1 := False;
ATM.P2 := True;
ATM.P3 := False;
ATM.P4 := False;
end;

procedure TP2STATS.Timer1Timer(Sender: TObject);
begin
Bmemo.Clear;
Bmemo.Lines.Add('');
BMemo.Lines.add('BANK BALANCE - R'+inttostr(bal));
BMemo.Lines.add('CASH - R0');
BMemo.Lines.add ('CRYPTO RATES - '+inttostr(ATM.rate)+' %');

end;

end.
