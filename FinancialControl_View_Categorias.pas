unit FinancialControl_View_Categorias;

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
  Classe_Categoria,
  FireDAC.comp.Client,
  FireDAC.DApt,
  Data.DB,
  DM_FinancialControl;

type
  TFrmCategorias = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Rectangle1: TRectangle;
    Layout3: TLayout;
    lbl_QtdCategoria: TLabel;
    img_add: TImage;
    lv_categoria: TListView;
    procedure img_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lv_categoriaUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_addClick(Sender: TObject);
    procedure lv_categoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure CadCategoria(id_cat: string);
    { Private declarations }
  public
    { Public declarations }
    procedure ListarCategorias;
  end;

var
  FrmCategorias: TFrmCategorias;

implementation

{$R *.fmx}

uses
  FinancialControl_View_Principal,
  FinancialControl_View_Cad_Categorias;

procedure TFrmCategorias.CadCategoria(id_cat: string);
begin
  if not Assigned(FrmCategoriasCad) then
    Application.CreateForm(TFrmCategoriasCad, FrmCategoriasCad);
  // INCLUSÃO
  if id_cat = '' then
  begin
    FrmCategoriasCad.Id_Cat := 0;
    FrmCategoriasCad.Modo := 'I';
    FrmCategoriasCad.lbl_titulo.text := 'Nova Categoria'
  end
  else
  // ALTERAÇÃO
  begin
    FrmCategoriasCad.Id_Cat := Id_Cat.ToInteger;
    FrmCategoriasCad.Modo := 'A';
    FrmCategoriasCad.lbl_titulo.text := 'Editar Categoria';
  end;

  FrmCategoriasCad.Show;
end;

procedure TFrmCategorias.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmCategorias := nil;
end;

procedure TFrmCategorias.ListarCategorias;
var
  Cat: TCategoria;
  Qry: TFDQuery;
  Erro: String;
  Icone: TStream;
begin
  try
    lv_categoria.Items.Clear;

    Cat := TCategoria.Create(dmFinancialControl.Conexao);
    Qry := cat.ListarCategoria(erro);

    Qry.First;
    while not Qry.Eof do
    begin
      // Validação do Ícone
      if Qry.FieldByName('ICONE').AsString <> '' then
        Icone := Qry.CreateBlobStream(Qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
      else
        Icone := nil;

      FrmPrincipal.AddCategoria(lv_categoria,
                                Qry.FieldByName('ID_CATEGORIA').AsInteger,
                                Qry.FieldByName('DESCRICAO').AsString,
                                Icone);

      if Icone <> nil then
        Icone.DisposeOf;

      Qry.Next;
    end;

    if lv_categoria.Items.Count > 1 then
      lbl_QtdCategoria.Text := lv_categoria.Items.Count.ToString + ' Categorias'
    else
      lbl_QtdCategoria.Text := lv_categoria.Items.Count.ToString + ' Categoria';
  finally
    Cat.DisposeOf;
    Qry.DisposeOf;
  end;
end;

procedure TFrmCategorias.FormShow(Sender: TObject);
//var
//  Foto : TStream;
//  x : integer;
begin
//  Foto := TMemoryStream.Create;
//  FrmPrincipal.imagemTest.Bitmap.SaveToStream(foto);
//  Foto.Position := 0;
//
//  for x := 1 to 10 do
//    FrmPrincipal.AddCategoria(lv_categoria,
//                              1,
//                              'Transporte',
//                              Foto);
//
//  Foto.DisposeOf;

  ListarCategorias;
end;

procedure TFrmCategorias.img_addClick(Sender: TObject);
begin
  CadCategoria('');
end;

procedure TFrmCategorias.img_voltarClick(Sender: TObject);
begin
  close;
end;

procedure TFrmCategorias.lv_categoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  CadCategoria(AItem.TagString);
end;

procedure TFrmCategorias.lv_categoriaUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  FrmPrincipal.SetupCategoria(lv_categoria, AItem);
end;

end.
