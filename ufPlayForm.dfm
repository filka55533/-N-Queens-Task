object frmPlay: TfrmPlay
  Left = 32
  Top = 120
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1047#1072#1076#1072#1095#1072' '#1086' '#1092#1077#1088#1079#1103#1093
  ClientHeight = 754
  ClientWidth = 1575
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mmMainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object pnlLandDesk: TPanel
    Left = 0
    Top = 0
    Width = 801
    Height = 754
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object imgDesk: TImage
      Left = 160
      Top = 88
      Width = 361
      Height = 305
      Visible = False
      OnMouseDown = imgDeskMouseDown
      OnMouseMove = imgDeskMouseMove
    end
    object pbGreenCell: TPaintBox
      Left = 608
      Top = 112
      Width = 105
      Height = 105
      Visible = False
    end
  end
  object pnlRightSide: TPanel
    Left = 801
    Top = 0
    Width = 774
    Height = 754
    Align = alClient
    BevelInner = bvLowered
    Caption = 'S'
    TabOrder = 1
    Visible = False
    object lblTimeLeft: TLabel
      Left = 536
      Top = 72
      Width = 180
      Height = 28
      Caption = #1055#1088#1086#1096#1083#1086' '#1074#1088#1077#1084#1077#1085#1080':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object lblTimeNow: TLabel
      Left = 600
      Top = 120
      Width = 64
      Height = 21
      Caption = '00:00:00'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object lblMessage: TLabel
      Left = 192
      Top = 680
      Width = 47
      Height = 28
      Caption = 'label'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object lblCombinFindName: TLabel
      Left = 520
      Top = 200
      Width = 227
      Height = 56
      Caption = #1053#1072#1081#1076#1077#1085#1086' '#1082#1086#1084#1073#1080#1085#1072#1094#1080#1081':'#13#10
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object lblCombProress: TLabel
      Left = 608
      Top = 256
      Width = 43
      Height = 21
      Caption = '0/100'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object lblHerzTemp: TLabel
      Left = 560
      Top = 336
      Width = 131
      Height = 28
      Caption = #1063#1072#1089#1090#1086#1090#1072' ('#1084#1089') :'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object mmoMoves: TMemo
      Left = 112
      Top = 56
      Width = 361
      Height = 457
      BevelEdges = [beRight, beBottom]
      BevelInner = bvLowered
      BevelKind = bkTile
      BevelOuter = bvRaised
      BiDiMode = bdLeftToRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 30
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object btnBackMove: TButton
      Left = 120
      Top = 552
      Width = 129
      Height = 49
      Caption = #1042#1077#1088#1085#1091#1090#1100' '#1093#1086#1076
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnBackMoveClick
    end
    object btnStarNewGame: TButton
      Left = 568
      Top = 552
      Width = 129
      Height = 49
      Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnClick = btnStarNewGameClick
    end
    object btnToStop: TButton
      Left = 344
      Top = 552
      Width = 129
      Height = 49
      Caption = #1047#1072#1082#1086#1085#1095#1080#1090#1100' '#1080#1075#1088#1091
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnToStopClick
    end
    object edtHerzChoose: TEdit
      Left = 552
      Top = 384
      Width = 153
      Height = 32
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = '3000'
    end
    object btnAccept: TButton
      Left = 584
      Top = 432
      Width = 89
      Height = 33
      HelpType = htKeyword
      HelpKeyword = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1095#1072#1089#1090#1086#1090#1099
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 5
      OnClick = btnAcceptClick
    end
    object btnReply: TButton
      Left = 568
      Top = 592
      Width = 129
      Height = 49
      Caption = #1055#1086#1074#1090#1086#1088#1080#1090#1100
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnMouseDown = btnReplyMouseDown
    end
    object btnStop_Start: TButton
      Left = 568
      Top = 552
      Width = 129
      Height = 49
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Visible = False
      OnMouseDown = btnStop_StartMouseDown
    end
  end
  object mmMainMenu: TMainMenu
    object mniGame: TMenuItem
      Caption = #1056#1077#1078#1080#1084
      OnClick = mniGameClick
      object mniNewGame: TMenuItem
        Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
        OnClick = mniNewGameClick
      end
      object mniOpen: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1080#1075#1088#1091
        OnClick = mniOpenClick
      end
      object mniSave: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1075#1088#1091
        OnClick = mniSaveClick
      end
      object mniDemonstration: TMenuItem
        Caption = #1044#1077#1084#1086#1085#1089#1090#1088#1072#1094#1080#1103' '#1082#1086#1084#1073#1080#1085#1072#1094#1080#1081
        OnClick = mniDemonstrationClick
      end
    end
    object mniHelp: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      OnClick = mniHelpClick
    end
  end
  object dlgSaveGame: TSaveDialog
    Filter = #1048#1075#1088#1086#1074#1086#1081' '#1092#1072#1081#1083'|*.bin'
    Left = 24
  end
  object dlgOpenGame: TOpenDialog
    Filter = #1048#1075#1088#1086#1074#1086#1081' '#1092#1072#1081#1083'|*.bin'
    Left = 48
  end
  object tmrTimePlay: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrTimePlayTimer
    Left = 73
  end
end
