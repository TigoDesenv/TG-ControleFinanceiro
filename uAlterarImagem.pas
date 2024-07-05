unit uAlterarImagem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TFrmAlteraImagem = class(TForm)
    Layout10: TLayout;
    circEditarFoto: TCircle;
    Layout11: TLayout;
    rectConta: TRoundRect;
    Label3: TLabel;
    procedure circEditarFotoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAlteraImagem: TFrmAlteraImagem;

implementation

{$R *.fmx}

uses
  FinancialControl_View_Login;

procedure TFrmAlteraImagem.circEditarFotoClick(Sender: TObject);
begin
  FRMLogin.actEscolher.Execute;
end;

end.
