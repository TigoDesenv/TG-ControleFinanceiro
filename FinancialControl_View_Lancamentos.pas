unit FinancialControl_View_Lancamentos;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  cLancamento,
  DM_FinancialControl,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  Data.DB,
  DateUtils;

type
  TFrmLancamentos = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Layout2: TLayout;
    ImgMesAnterior: TImage;
    ImgMesProximo: TImage;
    Image3: TImage;
    lbl_mes: TLabel;
    Rectangle1: TRectangle;
    Layout3: TLayout;
    Label5: TLabel;
    lbl_Receita: TLabel;
    lbl_Despesas: TLabel;
    Label3: TLabel;
    lbl_Saldo: TLabel;
    Label7: TLabel;
    ImgAdd: TImage;
    lv_lancamento: TListView;
    procedure img_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ImgAddClick(Sender: TObject);
    procedure ImgMesProximoClick(Sender: TObject);
    procedure ImgMesAnteriorClick(Sender: TObject);
    procedure lv_lancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    DataFiltro: TDate;
    procedure MostrarLancamentos(id_lancamento: Integer);
    procedure ListaDeLancamentos;
    procedure NavegarMes(num_mes: integer);
    function NomeMes: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLancamentos: TFrmLancamentos;

implementation

{$R *.fmx}

uses
  FinancialControl_View_Principal,
  FinancialControl_View_Cad_Lancamentos;

procedure TFrmLancamentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := TCloseAction.caFree;
  //FrmLancamentos := nil;  // Estamos destruindo no close do FrmPrincipal
end;

procedure TFrmLancamentos.FormShow(Sender: TObject);
begin
  DataFiltro := Date;
  NavegarMes(0);
end;

procedure TFrmLancamentos.ImgAddClick(Sender: TObject);
begin
  MostrarLancamentos(0);
end;

procedure TFrmLancamentos.ImgMesAnteriorClick(Sender: TObject);
begin
  NavegarMes(-1);
end;

procedure TFrmLancamentos.ImgMesProximoClick(Sender: TObject);
begin
  NavegarMes(1);
end;

procedure TFrmLancamentos.img_voltarClick(Sender: TObject);
begin
  close;
end;

procedure TFrmLancamentos.ListaDeLancamentos;
var
  Foto: TStream;
  xLancamento: TLancamento;
  qryAux: TFDQuery;
  Erro: String;
  ValorReceita: Double;
  ValorDespesa: Double;
begin
  try
    FrmLancamentos.lv_lancamento.Items.Clear;
    ValorReceita := 0;
    ValorDespesa := 0;

    xLancamento := TLancamento.Create(dmFinancialControl.Connection);
    xLancamento.DATA_DE := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(DataFiltro));
    xLancamento.DATA_ATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(DataFiltro));
    qryAux := xLancamento.ListarLancamento(0, Erro);

    if Erro <> '' then
    begin
      ShowMessage(Erro);
      Exit;
    end;

    while not qryAux.Eof do
    begin
      if qryAux.FieldByName('ICONE').AsString <> '' then
        Foto := qryAux.CreateBlobStream(qryAux.FieldByName('ICONE'), TBlobStreamMode.bmRead)
      else
        Foto := nil;

      FrmPrincipal.AddLancamento(lv_lancamento,
        qryAux.FieldByName('ID_LANCAMENTO').AsInteger,
        qryAux.FieldByName('DESCRICAO').AsString,
        qryAux.FieldByName('DESCRICAO_CATEGORIA').AsString,
        qryAux.FieldByName('VALOR').AsFloat,
        qryAux.FieldByName('DATA').AsDateTime,
        Foto);

      if qryAux.FieldByName('VALOR').AsFloat > 0 then
        ValorReceita := ValorReceita + qryAux.FieldByName('VALOR').AsFloat
      else
        ValorDespesa := ValorDespesa + qryAux.FieldByName('VALOR').AsFloat;

      qryAux.Next;

      Foto.DisposeOf;
    end;

    lbl_Receita.Text := FormatFloat('#,##0.00', ValorReceita);
    lbl_Despesas.Text := FormatFloat('#,##0.00', ValorDespesa);
    lbl_Saldo.Text := FormatFloat('#,##0.00', ValorReceita + ValorDespesa); // somamos porque a despesa ja é negativa
    // tratar as cores da labels dos valores
  finally
    xLancamento.DisposeOf;
  end;
end;

procedure TFrmLancamentos.MostrarLancamentos(id_lancamento: Integer);
begin
  if not Assigned(frmCadLancamentos) then
    Application.CreateForm(TFrmCadLancamentos, FrmCadLancamentos);

  if id_lancamento <> 0 then
  begin
    FrmCadLancamentos.Modo := 'A';
    FrmCadLancamentos.Id_Lanc := id_lancamento;
  end
  else
  begin
    FrmCadLancamentos.Modo := 'I';
    FrmCadLancamentos.Id_Lanc := 0;
  end;
  FrmCadLancamentos.Show;
end;

procedure TFrmLancamentos.lv_lancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  MostrarLancamentos(StrToInt(AItem.TagString));
end;

procedure TFrmLancamentos.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  FrmPrincipal.SetupLancamento(FrmLancamentos.lv_lancamento, AItem);
end;

procedure TFrmLancamentos.NavegarMes(num_mes: integer);
begin
  DataFiltro := IncMonth(DataFiltro, num_mes);
  lbl_mes.Text := NomeMes;
  ListaDeLancamentos;
end;

function TFrmLancamentos.NomeMes: string;
begin
  case MonthOf(DataFiltro) of
    1 : Result := 'Janeiro';
    2 : Result := 'Fevereiro';
    3 : Result := 'Março';
    4 : Result := 'Abril';
    5 : Result := 'Maio';
    6 : Result := 'Junho';
    7 : Result := 'Julho';
    8 : Result := 'Agosto';
    9 : Result := 'Setembro';
    10 : Result := 'Outubro';
    11 : Result := 'Novembro';
    12 : Result := 'Dezembro';
  end;

  Result := Result + ' / ' + YearOf(DataFiltro).ToString;
end;

end.
