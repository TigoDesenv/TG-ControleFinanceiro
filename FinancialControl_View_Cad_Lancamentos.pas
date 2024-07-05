unit FinancialControl_View_Cad_Lancamentos;

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
  FMX.DateTimeCtrls,
  FMX.Edit,
  FMX.ListBox,
  FMX.DialogService,
  DM_FinancialControl,
  FinancialControl_View_Lancamentos,
  cLancamento,
  uFormat,
  Classe_Categoria,
  FireDAC.comp.Client,
  FireDAC.DApt,
  Data.DB;

{$IFDEF AUTOREFCOUNT}
type
  TIntegerWrapper = class
    public
      Value: Integer;
      constructor Create(AValue: Integer);
end;
{$ENDIF}

type
  TFrmCadLancamentos = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Layout2: TLayout;
    Label2: TLabel;
    edt_DescricaoLanc: TEdit;
    Line1: TLine;
    Layout3: TLayout;
    Label3: TLabel;
    edt_ValorLanc: TEdit;
    Line2: TLine;
    Layout4: TLayout;
    Label4: TLabel;
    Line3: TLine;
    Layout5: TLayout;
    Label5: TLabel;
    Line4: TLine;
    edtDataLanc: TDateEdit;
    ImgHoje: TImage;
    ImgOntem: TImage;
    rectDelete: TRectangle;
    ImgTipoLancamento: TImage;
    imgDespesa: TImage;
    ImgReceita: TImage;
    img_save: TImage;
    lbl_Categoria: TLabel;
    Image1: TImage;
    procedure img_voltarClick(Sender: TObject);
    procedure ImgTipoLancamentoClick(Sender: TObject);
    procedure img_saveClick(Sender: TObject);
    procedure ImgHojeClick(Sender: TObject);
    procedure ImgOntemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_ValorLancTyping(Sender: TObject);
    procedure imgExcluirClick(Sender: TObject);
    procedure lbl_CategoriaClick(Sender: TObject);
  private
    { Private declarations }
//    procedure ComboCategoria;
    function TrataValor(str: string): double;
  public
    { Public declarations }
    Modo: String; //I (INCLUSÃO) / A (ALTERAÇÃO)
    Id_Lanc: Integer;
  end;

var
  FrmCadLancamentos: TFrmCadLancamentos;

implementation

{$R *.fmx}

uses
  FinancialControl_View_Principal,
  UnitComboCategoria;

{$IFDEF AUTOREFCOUNT}
constructor TIntegerWrapper.Create(AValue: Integer);
begin
  inherited Create;
  Value := AValue;
end;
{$ENDIF}

//procedure TFrmCadLancamentos.ComboCategoria;
//var
//  Categoria : TCategoria;
//  Erro : string;
//  qryAux: TFDQuery;
//begin
//  try
//    cmb_categoria.Items.Clear;
//
//    Categoria := TCategoria.Create(dmFinancialControl.Connection);
//    qryAux := Categoria.ListarCategoria(Erro);
//
//    if Erro <> '' then
//    begin
//      Showmessage(Erro);
//      Exit;
//    end;
//
//    while not qryAux.Eof do
//    begin
////      cmb_categoria.Items.AddObject(qryAux.FieldByName('DESCRICAO').AsString,
////                                    TObject(qryAux.FieldByName('ID_CATEGORIA').AsInteger));
//        cmb_categoria.Items.AddObject(qryAux.FieldByName('DESCRICAO').AsString,
//
//        {$IFDEF AUTOREFCOUNT}
//          TIntegerWrapper.Create(qry.FieldByName('ID_CATEGORIA').AsInteger)
//        {$ELSE}
//          TObject(qryAux.FieldByName('ID_CATEGORIA').AsInteger);
//        {$ENDIF});
//      qryAux.Next;
//    end;
//
//  finally
//    qryAux.DisposeOf;
//    Categoria.DisposeOf;
//  end;
//end;

procedure TFrmCadLancamentos.edt_ValorLancTyping(Sender: TObject);
begin
  Formatar(edt_ValorLanc, TFormato.Valor);
end;

procedure TFrmCadLancamentos.FormShow(Sender: TObject);
var
    Lanc : TLancamento;
    qryAux: TFDQuery;
    Erro : string;
begin
//  ComboCategoria;

  if modo = 'I' then
  begin
      edt_DescricaoLanc.Text := '';
      edtDataLanc.Date := date;
      edt_ValorLanc.Text := '';
      ImgTipoLancamento.Bitmap := imgDespesa.Bitmap;
      ImgTipoLancamento.Tag := -1;
      rectDelete.Visible := False;
      lbl_Categoria.Text := '';
      lbl_Categoria.Tag := 0;
  end
  else
  begin
    try
      Lanc := TLancamento.Create(dmFinancialControl.Conexao);
      Lanc.ID_LANCAMENTO := id_lanc;
      qryAux := Lanc.ListarLancamento(0, erro);

      if qryAux.RecordCount = 0 then
      begin
        ShowMessage('Lançamento não encontrado.');
        exit;
      end;

      edt_DescricaoLanc.Text := qryAux.FieldByName('DESCRICAO').AsString;
      edtDataLanc.Date := qryAux.FieldByName('DATA').AsDateTime;

      if qryAux.FieldByName('VALOR').AsFloat < 0 then  // Despesa...
      begin
        edt_ValorLanc.Text := FormatFloat('#,##0.00', qryAux.FieldByName('VALOR').AsFloat * -1);
        ImgTipoLancamento.Bitmap := imgDespesa.Bitmap;
        ImgTipoLancamento.Tag := -1;
      end
      else
      begin
        edt_ValorLanc.Text := FormatFloat('#,##0.00', qryAux.FieldByName('VALOR').AsFloat);
        ImgTipoLancamento.Bitmap := ImgReceita.Bitmap;
        ImgTipoLancamento.Tag := 1;
      end;

//      cmb_categoria.ItemIndex := cmb_categoria.Items.IndexOf(qryAux.FieldByName('DESCRICAO_CATEGORIA').AsString);
      lbl_Categoria.Text := qryAux.FieldByName('DESCRICAO_CATEGORIA').AsString;
      lbl_Categoria.Tag := qryAux.FieldByName('ID_CATEGORIA').AsInteger;
      rectDelete.Visible := True;

    finally
      qryAux.DisposeOf;
      Lanc.DisposeOf;
    end;
  end;
end;

procedure TFrmCadLancamentos.ImgHojeClick(Sender: TObject);
begin
  edtDataLanc.Date := Date;
end;

procedure TFrmCadLancamentos.ImgOntemClick(Sender: TObject);
begin
  edtDataLanc.Date := Date - 1;
end;

procedure TFrmCadLancamentos.ImgTipoLancamentoClick(Sender: TObject);
begin
  if ImgTipoLancamento.Tag = 1 then
  begin
    ImgTipoLancamento.Bitmap := imgDespesa.Bitmap;
    ImgTipoLancamento.Tag := -1;
  end
  else
  begin
    ImgTipoLancamento.Bitmap := ImgReceita.Bitmap;
    ImgTipoLancamento.Tag := 1;
  end;
end;

procedure TFrmCadLancamentos.imgExcluirClick(Sender: TObject);
var
  Lanc: TLancamento;
begin
  TDialogService.MessageDialog('Confirma Exclusão do Lançamento?',
    TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    TMsgDlgBtn.mbNo,
    0,
    procedure(const AResult: TModalResult)
    var
      Erro: String;
    begin
      if AResult = mrYes then
      begin
        try
          Lanc := TLancamento.Create(dmFinancialControl.Conexao);
          Lanc.ID_LANCAMENTO := Id_Lanc;

          if not Lanc.Excluir(Erro) then
          begin
            ShowMessage(Erro);
            Exit;
          end;

          Close;
        finally
          Lanc.DisposeOf;
        end;
      end;
    end);
end;

procedure TFrmCadLancamentos.img_saveClick(Sender: TObject);
var
  Lanc : TLancamento;
  erro : string;
begin
  try
    Lanc := TLancamento.Create(dmFinancialControl.Conexao);
    Lanc.DESCRICAO := edt_DescricaoLanc.Text;
    Lanc.VALOR := TrataValor(edt_ValorLanc.Text) * ImgTipoLancamento.Tag;

    {$IFDEF AUTOREFCOUNT}
    //lanc.ID_CATEGORIA := TIntegerWrapper(cmb_categoria.Items.Objects[cmb_categoria.ItemIndex]).Value;
    {$ELSE}
    //lanc.ID_CATEGORIA := Integer(cmb_categoria.Items.Objects[cmb_categoria.ItemIndex]);
    {$ENDIF}

    Lanc.ID_CATEGORIA := lbl_categoria.Tag;
    Lanc.DATA_LANC := edtDataLanc.Date;

    if modo = 'I' then
      Lanc.Inserir(erro)
    else
    begin
      Lanc.ID_LANCAMENTO := id_lanc;
      Lanc.Alterar(erro);
    end;

    if erro <> '' then
    begin
      showmessage(erro);
      exit;
    end;

    close;

  finally
    Lanc.DisposeOf;
  end;
end;

procedure TFrmCadLancamentos.img_voltarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCadLancamentos.lbl_CategoriaClick(Sender: TObject);
begin
  // Abre litagem categorias
  if not Assigned(FrmComboCategoria) then
    Application.CreateForm(TFrmComboCategoria, FrmComboCategoria);

  FrmComboCategoria.ShowModal(procedure(ModalResult: TModalResult)
  begin
    if FrmComboCategoria.IdCategoriaSelecao > 0 then
    begin
      lbl_categoria.Text := FrmComboCategoria.CategoriaSelecao;
      lbl_categoria.Tag := FrmComboCategoria.IdCategoriaSelecao;
    end;
  end);
end;

function TFrmCadLancamentos.TrataValor(str: string): double;
begin
  // Recebe = 1.250,75
  str := StringReplace(str, '.', '', [rfReplaceAll]); // 1250,75
  str := StringReplace(str, ',', '', [rfReplaceAll]); // 125075

  try
    Result := StrToFloat(str) / 100;
  except
    Result := 0;
  end
end;

end.
