object frmChooseSize: TfrmChooseSize
  Left = 283
  Top = 456
  Width = 449
  Height = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object lblTextChoosing: TLabel
    Left = 104
    Top = 40
    Width = 227
    Height = 24
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1088#1072#1079#1084#1077#1088#1099' '#1076#1086#1089#1082#1080
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Calibri'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cbbSizeBox: TComboBox
    Left = 176
    Top = 80
    Width = 89
    Height = 22
    Style = csOwnerDrawVariable
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 0
    Text = '4'
    Items.Strings = (
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13')
  end
  object btnAccept: TButton
    Left = 184
    Top = 160
    Width = 75
    Height = 25
    Caption = #1054#1082
    ModalResult = 1
    TabOrder = 1
  end
end
