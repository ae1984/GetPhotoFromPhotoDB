object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'fMain'
  ClientHeight = 120
  ClientWidth = 707
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 447
    Top = 8
    Width = 90
    Height = 57
  end
  object Label1: TLabel
    Left = 8
    Top = 44
    Width = 76
    Height = 13
    Caption = '-------------------'
  end
  object Label2: TLabel
    Left = 296
    Top = 44
    Width = 76
    Height = 13
    Caption = '-------------------'
  end
  object Label3: TLabel
    Left = 8
    Top = 61
    Width = 74
    Height = 13
    Caption = #1047#1072#1087#1091#1089#1082' '#1074' '#1095#1072#1089#1091':'
  end
  object Label4: TLabel
    Left = 112
    Top = 61
    Width = 76
    Height = 13
    Caption = #1047#1072#1087#1091#1089#1082' '#1074' '#1076#1077#1085#1100':'
  end
  object Label5: TLabel
    Left = 224
    Top = 61
    Width = 85
    Height = 13
    Caption = #1047#1072#1087#1088#1086#1089#1086#1074' '#1079#1072' '#1088#1072#1079':'
  end
  object btnGetPhoto: TButton
    Left = 543
    Top = 8
    Width = 156
    Height = 25
    Caption = 'btnGetPhoto'
    TabOrder = 0
    OnClick = btnGetPhotoClick
  end
  object btnTest: TButton
    Left = 543
    Top = 39
    Width = 75
    Height = 25
    Caption = 'btnTest'
    TabOrder = 1
    OnClick = btnTestClick
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 233
    Height = 21
    TabOrder = 2
    Text = 'f:\1\'
  end
  object Edit2: TEdit
    Left = 280
    Top = 8
    Width = 73
    Height = 21
    NumbersOnly = True
    TabOrder = 3
    Text = '0'
  end
  object Edit3: TEdit
    Left = 368
    Top = 8
    Width = 73
    Height = 21
    NumbersOnly = True
    TabOrder = 4
    Text = '1000'
  end
  object Edit4: TEdit
    Left = 8
    Top = 80
    Width = 76
    Height = 21
    TabOrder = 5
    Text = '10'
  end
  object Edit5: TEdit
    Left = 112
    Top = 80
    Width = 76
    Height = 21
    TabOrder = 6
    Text = '10'
  end
  object Edit6: TEdit
    Left = 224
    Top = 80
    Width = 76
    Height = 21
    TabOrder = 7
    Text = '40'
  end
  object Button1: TButton
    Left = 408
    Top = 61
    Width = 33
    Height = 25
    Caption = '0'
    TabOrder = 8
    OnClick = Button1Click
  end
  object ADOQuery1: TADOQuery
    Active = True
    ConnectionString = 
      'Provider=OraOLEDB.Oracle.1;Password=!;Persist Security In' +
      'fo=True;User ID=rmd_user;Data Source=PHOTODB'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select t.guid,a.data '
      'from esb_user.PHOTO_INFO t'
      'join esb_user.PHOTO_DATA a on a.id = t.id'
      'where t.guid = '#39'RFO20130826EBF3AD4542F607C0E0430A1105923806.jpg'#39)
    Left = 488
    Top = 24
  end
  object Timer1: TTimer
    Interval = 1800000
    OnTimer = Timer1Timer
    Left = 456
    Top = 8
  end
end
