object dm: Tdm
  OldCreateOrder = False
  Height = 242
  Width = 479
  object qrOrigem: TFDQuery
    Active = True
    Connection = congdoor
    SQL.Strings = (
      'select * from tcondicional ')
    Left = 208
    Top = 118
  end
  object qrDest: TFDQuery
    Active = True
    Connection = ConConnection
    SQL.Strings = (
      'select * from c000007')
    Left = 112
    Top = 118
  end
  object ConConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=con')
    Connected = True
    LoginPrompt = False
    Left = 103
    Top = 35
  end
  object congdoor: TFDConnection
    Params.Strings = (
      
        'Database=C:\projetos\Delphi\projetos\vcl\migrador gtor\Master\BA' +
        'SESGMASTER.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=localhost'
      'Port=3050'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 207
    Top = 35
  end
end
