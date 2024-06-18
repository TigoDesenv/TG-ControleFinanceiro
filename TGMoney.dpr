program TGMoney;

uses
  System.StartUpCopy,
  FMX.Forms,
  FinancialControl_View_Login in 'FinancialControl_View_Login.pas' {FrmLogin},
  FinancialControl_View_Principal in 'FinancialControl_View_Principal.pas' {FrmPrincipal},
  FinancialControl_View_Lancamentos in 'FinancialControl_View_Lancamentos.pas' {FrmLancamentos},
  FinancialControl_View_Cad_Lancamentos in 'FinancialControl_View_Cad_Lancamentos.pas' {FrmCadLancamentos},
  FinancialControl_View_Categorias in 'FinancialControl_View_Categorias.pas' {FrmCategorias},
  FinancialControl_View_Cad_Categorias in 'FinancialControl_View_Cad_Categorias.pas' {FrmCategoriasCad},
  DM_FinancialControl in 'DM_FinancialControl.pas' {dmFinancialControl: TDataModule},
  Classe_Categoria in 'Classes\Classe_Categoria.pas',
  cLancamento in 'Classes\cLancamento.pas',
  uFormat in 'Units Auxiliares\uFormat.pas',
  uPermissions in 'Units Auxiliares\uPermissions.pas',
  cUsuario in 'Classes\cUsuario.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmFinancialControl, dmFinancialControl);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;

end.
