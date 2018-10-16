object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'GDOOR to APOLO'
  ClientHeight = 242
  ClientWidth = 883
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 169
    Height = 25
    Caption = 'Migrar Condicionais'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 201
    Width = 883
    Height = 41
    Align = alBottom
    TabOrder = 1
    object pb: TProgressBar
      Left = 1
      Top = 1
      Width = 881
      Height = 39
      Align = alClient
      TabOrder = 0
    end
  end
  object Memo1: TMemo
    Left = 183
    Top = 0
    Width = 700
    Height = 201
    Align = alRight
    Lines.Strings = (
      '')
    TabOrder = 2
  end
  object Button2: TButton
    Left = 32
    Top = 72
    Width = 75
    Height = 25
    Caption = 'botao teste'
    TabOrder = 3
    Visible = False
    OnClick = Button2Click
  end
end
