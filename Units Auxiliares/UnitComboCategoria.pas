unit UnitComboCategoria;

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
  FireDAC.Comp.Client,
  FireDAC.DApt,
  Data.DB;

type
  TFrmComboCategoria = class(TForm)
    Layout1: TLayout;
    lbl_titulo: TLabel;
    img_voltar: TImage;
    lv_categoria: TListView;
    procedure img_voltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv_categoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure ListarCategorias;
    { Private declarations }
  public
    { Public declarations }
    CategoriaSelecao: string;
    IdCategoriaSelecao: Integer;
  end;

var
  FrmComboCategoria: TFrmComboCategoria;

implementation

{$R *.fmx}

uses
  FinancialControl_View_Principal,
  Classe_Categoria,
  DM_FinancialControl;

procedure TFrmComboCategoria.ListarCategorias;
var
  Cat : TCategoria;
  qryAux: TFDQuery;
  Erro: string;
  Icone: TStream;
begin
  try
    lv_categoria.Items.Clear;

    Cat := TCategoria.Create(dmFinancialControl.Conexao);
    qryAux := cat.ListarCategoria(Erro);

    while not qryAux.Eof do
    begin
      // Icone...
      if qryAux.FieldByName('ICONE').AsString <> '' then
        Icone := qryAux.CreateBlobStream(qryAux.FieldByName('ICONE'), TBlobStreamMode.bmRead)
      else
        Icone := nil;

      FrmPrincipal.AddCategoria(FrmComboCategoria.lv_categoria,
                                qryAux.FieldByName('ID_CATEGORIA').AsInteger,
                                qryAux.FieldByName('DESCRICAO').AsString,
                                Icone);

      if Icone <> nil then
        Icone.DisposeOf;

      qryAux.Next;
    end;

  finally
    qryAux.DisposeOf;
    Cat.DisposeOf;
  end;
end;

procedure TFrmComboCategoria.lv_categoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  IdCategoriaSelecao := Aitem.TagString.ToInteger;
  CategoriaSelecao := TListItemText(Aitem.Objects.FindDrawable('TxtCategoria')).Text;
  close;
end;

procedure TFrmComboCategoria.FormShow(Sender: TObject);
begin
  ListarCategorias;
end;

procedure TFrmComboCategoria.img_voltarClick(Sender: TObject);
begin
  IdCategoriaSelecao := 0;
  CategoriaSelecao := '';
  close;
end;

end.
