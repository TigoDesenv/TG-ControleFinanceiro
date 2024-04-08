program TGMoney;

uses
  System.StartUpCopy,
  FMX.Forms,
  FinancialControl_View_Login in 'FinancialControl_View_Login.pas' {FrmLogin},
  uPermissions in 'uPermissions.pas',
  FinancialControl_View_Principal in 'FinancialControl_View_Principal.pas' {FrmPrincipal},
  FinancialControl_View_Lancamentos in 'FinancialControl_View_Lancamentos.pas' {FrmLancamentos},
  FinancialControl_View_Cad_Lancamentos in 'FinancialControl_View_Cad_Lancamentos.pas' {FrmCadLancamentos},
  FinancialControl_View_Categorias in 'FinancialControl_View_Categorias.pas' {FrmCategorias},
  FinancialControl_View_Cad_Categorias in 'FinancialControl_View_Cad_Categorias.pas' {FrmCategoriasCad};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmCategorias, FrmCategorias);
  Application.CreateForm(TFrmCategoriasCad, FrmCategoriasCad);
  Application.Run;

end.