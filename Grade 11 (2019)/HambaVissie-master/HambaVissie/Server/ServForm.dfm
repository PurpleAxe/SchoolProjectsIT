object Server: TServer
  Left = 0
  Top = 0
  Caption = 'Server'
  ClientHeight = 692
  ClientWidth = 1057
  Color = clBtnText
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    1057
    692)
  PixelsPerInch = 96
  TextHeight = 18
  object memoConsole: TMemo
    Left = 272
    Top = 0
    Width = 791
    Height = 343
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object rdgStartStop: TRadioGroup
    Left = 0
    Top = -16
    Width = 274
    Height = 81
    Align = alCustom
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Items.Strings = (
      'START'
      'STOP')
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    OnClick = rdgStartStopClick
  end
  object dbgPlayers: TDBGrid
    Left = 0
    Top = 368
    Width = 1057
    Height = 120
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dbgMain: TDBGrid
    Left = 0
    Top = 520
    Width = 1057
    Height = 120
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnReset: TButton
    Left = 0
    Top = 136
    Width = 266
    Height = 57
    Caption = 'RESET'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnResetClick
  end
  object socServer: TServerSocket
    Active = False
    Port = 3434
    ServerType = stNonBlocking
    OnClientConnect = socServerClientConnect
    OnClientDisconnect = socServerClientDisconnect
    OnClientRead = socServerClientRead
    Left = 224
    Top = 72
  end
  object MainMenu1: TMainMenu
    Left = 160
    Top = 72
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open DB Menu'
        OnClick = Open1Click
      end
      object OpenLog1: TMenuItem
        Caption = 'Open Log'
        OnClick = OpenLog1Click
      end
    end
  end
end
