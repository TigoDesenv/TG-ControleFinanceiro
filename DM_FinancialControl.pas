unit DM_FinancialControl;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, System.IOUtils;

type
  TdmFinancialControl = class(TDataModule)
    Conexao: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmFinancialControl: TdmFinancialControl;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmFinancialControl.DataModuleCreate(Sender: TObject);
begin
  with Conexao do
  begin
    {$IFDEF MSWINDOWS}
    try
      Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\DataBase\TGMoney_DB.db';
      Connected := true;
    except on E:Exception do
      raise Exception.Create('Erro de conex�o com o banco de dados: ' + E.Message);
    end;

    {$ELSE}

    Params.Values['DriverID'] := 'SQLite';
    try
      Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'TGMoney_DB.db');
      Connected := true;
    except on E:Exception do
      raise Exception.Create('Erro de conex�o com o banco de dados: ' + E.Message);
    end;
    {$ENDIF}
  end;
end;

end.
