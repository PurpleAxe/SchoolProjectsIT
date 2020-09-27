object A_T_M: TA_T_M
  Left = 0
  Top = 0
  Caption = 'ATM'
  ClientHeight = 468
  ClientWidth = 337
  Color = clDefault
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    337
    468)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 0
    Width = 148
    Height = 64
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    Caption = 'ATM'
    Font.Charset = OEM_CHARSET
    Font.Color = clRed
    Font.Height = -64
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object AATM: TMemo
    Left = 24
    Top = 80
    Width = 289
    Height = 81
    Anchors = [akLeft, akTop, akRight]
    BorderStyle = bsNone
    Color = clMenuText
    Font.Charset = OEM_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Terminal'
    Font.Style = []
    Lines.Strings = (
      'BANK BALANCE - R**.**'
      ''
      'AMOUNT - R**.**')
    ParentFont = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 24
    Top = 248
    Width = 289
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    Caption = 'WITHDRAW'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 24
    Top = 320
    Width = 289
    Height = 32
    Anchors = [akLeft, akTop, akRight]
    Caption = 'DEPOSIT'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 24
    Top = 392
    Width = 289
    Height = 32
    Anchors = [akLeft, akTop, akRight]
    Caption = 'DEPOSIT INTO BYTECOIN'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 24
    Top = 176
    Width = 289
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Load Balance'
    Font.Charset = OEM_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = Button4Click
  end
end
