object CSTATS: TCSTATS
  Left = 0
  Top = 0
  Caption = 'CSTATS'
  ClientHeight = 517
  ClientWidth = 879
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    879
    517)
  PixelsPerInch = 96
  TextHeight = 13
  object BMemo: TMemo
    Left = 16
    Top = 8
    Width = 433
    Height = 209
    Color = clBtnShadow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Lines.Strings = (
      ''
      'BANK BALANCE - R **. **'
      'CASH - R **. **'
      'CRYPTO RATES - **. ** %')
    ParentFont = False
    TabOrder = 0
  end
  object PMemo: TMemo
    Left = 16
    Top = 303
    Width = 841
    Height = 194
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnShadow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Lines.Strings = (
      
        '                                                                ' +
        '    PROPERTIES OWNED ')
    ParentFont = False
    TabOrder = 1
  end
  object CMemo: TMemo
    Left = 488
    Top = 8
    Width = 369
    Height = 265
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnShadow
    TabOrder = 2
  end
  object Button1: TButton
    Left = 16
    Top = 242
    Width = 75
    Height = 41
    Caption = 'Buy'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object Button2: TButton
    Left = 136
    Top = 240
    Width = 75
    Height = 41
    Caption = 'Sell'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object Button3: TButton
    Left = 256
    Top = 240
    Width = 75
    Height = 41
    Caption = 'Accept'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object Button4: TButton
    Left = 374
    Top = 240
    Width = 75
    Height = 41
    Caption = 'Decline'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
  end
  object Button5: TButton
    Left = 278
    Top = 82
    Width = 75
    Height = 39
    Caption = 'ATM'
    Font.Charset = OEM_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = Button5Click
  end
end
