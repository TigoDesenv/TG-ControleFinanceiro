program TGMoney;

uses
  System.StartUpCopy,
  FMX.Forms,
  FinancialControl_View_Login in 'FinancialControl_View_Login.pas' {FrmLogin},
  uPermissions in 'uPermissions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
