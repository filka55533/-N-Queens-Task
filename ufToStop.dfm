object frmToStop: TfrmToStop
  Left = 745
  Top = 218
  VertScrollBar.Visible = False
  BorderStyle = bsDialog
  ClientHeight = 342
  ClientWidth = 906
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  Visible = True
  PixelsPerInch = 120
  TextHeight = 16
  object pnlBack: TPanel
    Left = 0
    Top = 0
    Width = 906
    Height = 342
    Align = alClient
    Color = clSilver
    TabOrder = 0
    object lblCptAsk: TLabel
      Left = 128
      Top = 64
      Width = 679
      Height = 49
      Alignment = taCenter
      Caption = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099', '#1095#1090#1086' '#1093#1086#1090#1080#1090#1077' '#1079#1072#1082#1086#1085#1095#1080#1090#1100' '#1080#1075#1088#1091'?'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = 'Calibri'
      Font.Style = []
      ParentFont = False
    end
    object btnYes: TButton
      Left = 208
      Top = 208
      Width = 153
      Height = 49
      Caption = #1044#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Calibri'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
    end
    object btnNo: TButton
      Left = 552
      Top = 208
      Width = 153
      Height = 49
      Caption = #1053#1077#1090
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Calibri'
      Font.Style = []
      ModalResult = 7
      ParentFont = False
      TabOrder = 1
    end
  end
end
