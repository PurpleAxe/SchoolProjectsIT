{
    Visopoly a bilingual monopoly game
    Copyright (C) 2018  Andreas Visagie

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
unit COMPUTERAI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls;

type
  TCF = class(TForm)
    Image1: TImage;
    Button1: TButton;
    btnP1: TButton;
    btnC: TButton;
    Memo1: TMemo;
    Player: TShape;
    AI: TShape;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CF: TCF;
  {PLAYER POSITION FOR BOARD ALONG X-AXIS}
 // pXpos: array[1..40] of integer=(8, 72, 136, 200, 264, 328, 392);
  {PLAYER POSITION FOR BOARD ALONG Y-AXIS}
 // pYpos: array[1..40] of integer=(8, 8, 8, 8, 8, 8, 8);

implementation

{$R *.dfm}

end.
