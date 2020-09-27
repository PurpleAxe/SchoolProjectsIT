unit VGHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmHelp = class(TForm)
    memoHelp: TMemo;
    lblHelp: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHelp: TfrmHelp;

implementation

{$R *.dfm}

procedure TfrmHelp.FormActivate(Sender: TObject);
begin
  try
    memoHelp.Lines.LoadFromFile('README.txt');
  except on E:exception do
    begin
      showmessage('Cannot locate Help file');
    end;

  end;

end;

end.
