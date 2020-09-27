object frmHelp: TfrmHelp
  Left = 0
  Top = 0
  Caption = 'Help'
  ClientHeight = 454
  ClientWidth = 855
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  DesignSize = (
    855
    454)
  PixelsPerInch = 96
  TextHeight = 13
  object lblHelp: TLabel
    Left = 368
    Top = 2
    Width = 96
    Height = 45
    Caption = 'HELP'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object memoHelp: TMemo
    Left = 32
    Top = 53
    Width = 793
    Height = 393
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
