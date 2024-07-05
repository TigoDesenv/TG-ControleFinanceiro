object dmFinancialControl: TdmFinancialControl
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 409
  Width = 538
  object Conexao: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\tigot\Desktop\GitHub Tiago\PUBLICO\TG-Controle' +
        'Financeiro\DataBase\TGMoney_DB.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 56
    Top = 40
  end
end
