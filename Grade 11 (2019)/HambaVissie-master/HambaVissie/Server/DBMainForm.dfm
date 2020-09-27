object frmDBMain: TfrmDBMain
  Left = 0
  Top = 0
  Caption = 'db'
  ClientHeight = 740
  ClientWidth = 1107
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object dbgPlayers: TDBGrid
    Left = 0
    Top = 24
    Width = 1105
    Height = 120
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -15
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dbgMain: TDBGrid
    Left = 0
    Top = 168
    Width = 1105
    Height = 120
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dbgExec: TDBGrid
    Left = 0
    Top = 312
    Width = 1105
    Height = 169
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object edtUsr: TEdit
    Left = 32
    Top = 512
    Width = 209
    Height = 26
    TabOrder = 3
    TextHint = 'Delete a record'
  end
  object btnDelete: TButton
    Left = 32
    Top = 583
    Width = 209
    Height = 41
    Caption = 'DELETE'
    TabOrder = 4
    OnClick = btnDeleteClick
  end
  object btnSortNames: TButton
    Left = 448
    Top = 512
    Width = 209
    Height = 41
    Caption = 'SORT NAMES'
    TabOrder = 5
    OnClick = btnSortNamesClick
  end
  object btnSortScores: TButton
    Left = 448
    Top = 583
    Width = 209
    Height = 40
    Caption = 'SORT SCORES'
    TabOrder = 6
    OnClick = btnSortScoresClick
  end
  object btnShowHighScore: TButton
    Left = 882
    Top = 512
    Width = 209
    Height = 40
    Caption = 'SHOW HIGHEST SCORE'
    TabOrder = 7
    OnClick = btnShowHighScoreClick
  end
end
