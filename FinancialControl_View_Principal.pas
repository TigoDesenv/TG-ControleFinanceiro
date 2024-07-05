unit FinancialControl_View_Principal;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  DateUtils,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  FinancialControl_View_Lancamentos,
  FinancialControl_View_Categorias,
  FinancialControl_View_Cad_Lancamentos,
  FMX.Ani,
  cLancamento,
  DM_FinancialControl,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  Data.DB,
  cUsuario;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    img_menu: TImage;
    c_Icone: TCircle;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    lbl_Saldo: TLabel;
    Label3: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Image2: TImage;
    lbl_Receitas: TLabel;
    Label5: TLabel;
    Layout6: TLayout;
    Image3: TImage;
    lbl_Despesas: TLabel;
    Label7: TLabel;
    Rectangle1: TRectangle;
    ImgAdd: TImage;
    Rectangle2: TRectangle;
    Layout7: TLayout;
    Label8: TLabel;
    lblTodosLancamentos: TLabel;
    lvLancamento: TListView;
    imagemTest: TImage;
    StyleBook1: TStyleBook;
    rectMenu: TRectangle;
    LayoutPrincipal: TLayout;
    AnimationMenu: TFloatAnimation;
    imgFecharMenu: TImage;
    LayoutMenuCategoria: TLayout;
    Label9: TLabel;
    LayoutMenuLogoff: TLayout;
    Label10: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ImgAddClick(Sender: TObject);
    procedure lvLancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvLancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvLancamentoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure lvLancamentoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lblTodosLancamentosClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_menuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AnimationMenuFinish(Sender: TObject);
    procedure AnimationMenuProcess(Sender: TObject);
    procedure imgFecharMenuClick(Sender: TObject);
    procedure LayoutMenuCategoriaClick(Sender: TObject);
    procedure LayoutMenuLogoffClick(Sender: TObject);
    procedure c_IconeClick(Sender: TObject);
  private
    { Private declarations }
    procedure MontaPainelPrincipal;
    procedure ListarUltimosLancamentos;

  public
    { Public declarations }
    procedure AddLancamento(List: TListView; id_lacamentos: Integer;
      descricao, categoria: String; valor: Double;
      DtLancamento: TDateTime;
      foto: TStream);
    procedure SetupLancamento(lv: TListView;
      Item: TListViewItem);
    procedure AddCategoria(listview: TListView; id_categoria: Integer; categoria: string;
              foto: TStream);
    procedure SetupCategoria(lv: TListView; Item: TListViewItem);
    procedure CarregaIcone;
  end;

var
  FrmPrincipal: TFrmPrincipal;
  AlterandoFotoLogin: Boolean;

implementation

{$R *.fmx}

uses
  FinancialControl_View_Login,
  uAlterarImagem;

procedure TFrmPrincipal.AddCategoria(listview: TListView; id_categoria: Integer;
  categoria: string; foto: TStream);
var
  txt : TListItemText;
  img : TListItemImage;
  bmp : TBitmap;
begin
  with listview.Items.Add do
  begin
    TagString := id_categoria.ToString;

    txt := TListItemText(Objects.FindDrawable('TxtCategoria'));
    txt.Text := categoria;

    // Icone...
    img := TListItemImage(Objects.FindDrawable('ImgIcone'));

    if foto <> nil then
    begin
      bmp := TBitmap.Create;
      bmp.LoadFromStream(foto);

      img.OwnsBitmap := true;
      img.Bitmap := bmp;
    end;
  end;
end;

procedure TFrmPrincipal.AddLancamento(List: TListView; id_lacamentos: Integer; descricao,
  categoria: String; valor: Double; DtLancamento: TDateTime; Foto: TStream);
var
  Txt: TListItemText;
  Img: TListItemImage;
  bmp: TBitmap;
begin
  with List.Items.Add do
  begin
    // Exemplo utilizando Variável
    TagString := id_lacamentos.ToString;

    Txt := TListItemText(Objects.FindDrawable('TxtDescricao'));
    Txt.Text := descricao;

    TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;
    TListItemText(Objects.FindDrawable('TxtValor')).Text := FormatFloat('#,##0.00', valor);
    TListItemText(Objects.FindDrawable('TxtData')).Text := FormatDateTime('dd/mm', DtLancamento);

    // Icone da ListView
    Img := TListItemImage(Objects.FindDrawable('ImgIcone'));

    if foto <> nil then
    begin
      bmp := TBitmap.Create;
      bmp.LoadFromStream(Foto);

      Img.OwnsBitmap := True;
      img.Bitmap := bmp;
    end;
  end;
end;

procedure TFrmPrincipal.AnimationMenuFinish(Sender: TObject);
begin
  LayoutPrincipal.Enabled := AnimationMenu.Inverse;
  AnimationMenu.Inverse := not AnimationMenu.Inverse;
end;

procedure TFrmPrincipal.AnimationMenuProcess(Sender: TObject);
begin
  LayoutPrincipal.Margins.Right := -260 - rectMenu.Margins.Left;
end;

procedure TFrmPrincipal.CarregaIcone;
var
  User : TUsuario;
  qryAux: TFDQuery;
  Erro: string;
  Foto: TStream;
begin
  try
    User := TUsuario.Create(dmFinancialControl.Conexao);
    qryAux := User.ListarUsuario(Erro);

    if qryAux.FieldByName('FOTO').AsString <> '' then
      Foto := qryAux.CreateBlobStream(qryAux.FieldByName('FOTO'), TBlobStreamMode.bmRead)
    else
      Foto := nil;

    if Foto <> nil then
    begin
      c_Icone.Fill.Bitmap.Bitmap.LoadFromStream(foto);
      Foto.DisposeOf;
    end;

  finally
    qryAux.DisposeOf;
    User.DisposeOf;
  end;
end;

procedure TFrmPrincipal.c_IconeClick(Sender: TObject);
begin
  AlterandoFotoLogin := True;

  if not Assigned(FrmLogin) then
  begin
    Application.CreateForm(TFrmLogin, FrmLogin);
    FrmLogin.Show;
  end;
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FrmLancamentos) then
  begin
    FrmLancamentos.DisposeOf;
    FrmLancamentos := nil;
  end;

  Action := TCloseAction.caFree;
  FrmPrincipal := nil;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  rectMenu.Margins.Left := - 260;
  rectMenu.Align := TAlignLayout.Left;
  rectMenu.Visible := True;
  AlterandoFotoLogin := False;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  ListarUltimosLancamentos;
  CarregaIcone;
end;

procedure TFrmPrincipal.ImgAddClick(Sender: TObject);
begin
  if not Assigned(frmCadLancamentos) then
    Application.CreateForm(TFrmCadLancamentos, FrmCadLancamentos);

  FrmCadLancamentos.Modo := 'I';
  FrmCadLancamentos.Id_Lanc := -1;

  FrmCadLancamentos.ShowModal(procedure(ModalResult: TModalResult)
                              begin
                                ListarUltimosLancamentos;
                              end);
end;

procedure TFrmPrincipal.imgFecharMenuClick(Sender: TObject);
begin
  AnimationMenu.Start;
end;

procedure TFrmPrincipal.img_menuClick(Sender: TObject);
begin
  AnimationMenu.Start;
end;

procedure TFrmPrincipal.LayoutMenuCategoriaClick(Sender: TObject);
begin
  AnimationMenu.Start;
  if not Assigned(FrmCategorias) then
    Application.CreateForm(TFrmCategorias, FrmCategorias);

  FrmCategorias.Show;
end;

procedure TFrmPrincipal.LayoutMenuLogoffClick(Sender: TObject);
var
  User : TUsuario;
  Erro : string;
begin
  try
    User := TUsuario.Create(dmFinancialControl.Conexao);

    if not User.Logout(Erro) then
    begin
      Showmessage(Erro);
      Exit;
    end;

    AlterandoFotoLogin := False;
  finally
    User.DisposeOf;
  end;

  if not Assigned(FrmLogin) then
    Application.CreateForm(TFrmLogin, FrmLogin);

  Application.MainForm := FrmLogin;
  FrmLogin.Show;
  FrmPrincipal.Close;
end;

procedure TFrmPrincipal.lblTodosLancamentosClick(Sender: TObject);
begin
  if not Assigned(FrmLancamentos) then
    Application.CreateForm(TFrmLancamentos, FrmLancamentos);

  FrmLancamentos.Show;
end;

procedure TFrmPrincipal.ListarUltimosLancamentos;
var
  Foto: TStream;
  Lancamento: TLancamento;
  qryAux: TFDQuery;
  Erro: String;
begin
  try
    FrmPrincipal.lvlancamento.Items.Clear;
    Lancamento := TLancamento.Create(dmFinancialControl.Conexao);
    qryAux := Lancamento.ListarLancamento(10, Erro);

    if Erro <> '' then
    begin
      ShowMessage(Erro);
      Exit;
    end;

//    qryAux.First;
    while not qryAux.Eof do
    begin
      if qryAux.FieldByName('ICONE').AsString <> '' then
        Foto := qryAux.CreateBlobStream(qryAux.FieldByName('ICONE'), TBlobStreamMode.bmRead)
      else
        Foto := nil;

      AddLancamento(lvLancamento,
        qryAux.FieldByName('ID_LANCAMENTO').AsInteger,
        qryAux.FieldByName('DESCRICAO').AsString,
        qryAux.FieldByName('DESCRICAO_CATEGORIA').AsString,
        qryAux.FieldByName('VALOR').AsFloat,
        qryAux.FieldByName('DATA').AsDateTime,
        Foto);
      qryAux.Next;

      Foto.DisposeOf;
    end;

  finally
    Lancamento.DisposeOf;
  end;

  MontaPainelPrincipal;
end;

procedure TFrmPrincipal.lvLancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if not Assigned(FrmCadLancamentos) then
      Application.CreateForm(TFrmCadLancamentos, FrmCadLancamentos);

  FrmCadLancamentos.modo := 'A';
  FrmCadLancamentos.id_lanc := Aitem.TagString.ToInteger;

  FrmCadLancamentos.ShowModal(procedure(ModalResult: TModalResult)
                              begin
                                ListarUltimosLancamentos;
                              end);
end;

procedure TFrmPrincipal.lvLancamentoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  {
  if TListView(Sender).Selected <> nil then
  begin
    if ItemObject is TListItemImage then
    begin
      Image3.Bitmap := TListItemImage(ItemObject).Bitmap;
    end;

    if ItemObject is TListItemText then
    begin
      Label2.Text := TListItemText(ItemObject).Text;
    end;
  end;
  }
end;

procedure TFrmPrincipal.lvLancamentoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  {
  if lvlancamento.Items.Count > 0 then
    if lvlancamento.GetItemRect(lvlancamento.items.Count - 4).Bottom <= lvlancamento.Height then
    begin
      AddLancamentos(1, 'Supermercado 1', 'Transporte', -45, date, nil);
      AddLancamentos(2, 'Supermercado 2', 'Transporte', -45, date, nil);
      AddLancamentos(3, 'Supermercado 3', 'Transporte', -45, date, nil);
      AddLancamentos(4, 'Supermercado 4', 'Transporte', -45, date, nil);
      AddLancamentos(5, 'Supermercado 5', 'Transporte', -45, date, nil);
    end;
    }
end;

procedure TFrmPrincipal.lvLancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  SetupLancamento(FrmPrincipal.lvlancamento, AItem);
end;

procedure TFrmPrincipal.MontaPainelPrincipal;
var
  Lanc: TLancamento;
  qryAux: TFDQuery;
  Erro: String;
  ValorReceita, ValorDespesa: Double;
begin
  try
    Lanc := TLancamento.Create(dmFinancialControl.Conexao);
    Lanc.DATA_DE := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(date));
    Lanc.DATA_ATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(date));
    qryAux := Lanc.ListarLancamento(0, Erro);

    if Erro <> '' then
    begin
      Showmessage(erro);
      Exit;
    end;

    ValorReceita := 0;
    ValorDespesa := 0;

    while not qryAux.Eof do
    begin
      if qryAux.FieldByName('VALOR').AsFloat > 0 then
        ValorReceita := ValorReceita + qryAux.FieldByName('VALOR').AsFloat
      else
        ValorDespesa := ValorDespesa + qryAux.FieldByName('VALOR').AsFloat;

      qryAux.Next;
    end;

    lbl_receitas.Text := FormatFloat('#,##0.00', ValorReceita);
    lbl_despesas.Text := FormatFloat('#,##0.00', ValorDespesa);
    lbl_saldo.Text := FormatFloat('#,##0.00', ValorReceita + ValorDespesa); // Somamos pq o vl_desp já esta negativo...
  finally
    Lanc.DisposeOf;
    qryAux.DisposeOf;
  end;
end;

procedure TFrmPrincipal.SetupCategoria(lv: TListView; Item: TListViewItem);
var
  txt : TListItemText;
begin
  txt := TListItemText(Item.Objects.FindDrawable('TxtCategoria'));
  txt.Width := lv.Width - txt.PlaceOffset.X - 20;
end;

procedure TFrmPrincipal.SetupLancamento(lv: TListView; Item: TListViewItem);
var
  txt : TListItemText;
  //img : TListItemImage;
begin
  txt := TListItemText(Item.Objects.FindDrawable('TxtDescricao'));
  txt.Width := lv.Width - txt.PlaceOffset.X - 100;

  {
  img := TListItemImage(AItem.Objects.FindDrawable('ImgIcone'));

  if lv_lancamento.Width < 200 then
  begin
    img.Visible := false;
    txt.PlaceOffset.X := 2;
  end;
  }
end;

end.
