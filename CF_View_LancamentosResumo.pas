unit CF_View_LancamentosResumo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts, FireDAC.Comp.Client, FireDAC.DApt, Data.DB, cLancamento;

type
  TFrmLancamentosResumo = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Layout2: TLayout;
    Image3: TImage;
    lbl_mes: TLabel;
    lv_resumo: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_voltarClick(Sender: TObject);
  private
    procedure MontarResumo;
    procedure AddCategoria(listview: TListView; categoria: string; valor: double;
              foto: TStream);
    { Private declarations }
  public
    { Public declarations }
    DataFiltro : TDate;
  end;

var
  FrmLancamentosResumo: TFrmLancamentosResumo;

implementation

{$R *.fmx}

uses
  FinancialControl_View_Principal,
  DM_FinancialControl,
  System.DateUtils;

procedure TFrmLancamentosResumo.AddCategoria(listview: TListView;
  categoria: string; valor: double; foto: TStream);
var
  txt : TListItemText;
  img : TListItemImage;
  bmp : TBitmap;
begin
  with listview.Items.Add do
  begin
    txt := TListItemText(Objects.FindDrawable('TxtCategoria'));
    txt.Text := categoria;

    txt := TListItemText(Objects.FindDrawable('TxtValor'));
    txt.Text := FormatCurr('#,##0.00', valor);

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

procedure TFrmLancamentosResumo.MontarResumo;
var
  Lanc : TLancamento;
  qryAux: TFDQuery;
  Erro: string;
  Icone: TStream;
begin
  try
    lv_resumo.Items.Clear;

    Lanc := TLancamento.Create(dmFinancialControl.Conexao);
    Lanc.DATA_DE := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(DataFiltro));
    Lanc.DATA_ATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(DataFiltro));
    qryAux := Lanc.ListarResumo(Erro);

    while not qryAux.Eof do
    begin
      // Icone...
      if qryAux.FieldByName('ICONE').AsString <> '' then
        Icone := qryAux.CreateBlobStream(qryAux.FieldByName('ICONE'), TBlobStreamMode.bmRead)
      else
        Icone := nil;

      FrmLancamentosResumo.AddCategoria(lv_resumo,
                                        qryAux.FieldByName('DESCRICAO').AsString,
                                        qryAux.FieldByName('VALOR').AsCurrency,
                                        Icone);

      if Icone <> nil then
        Icone.DisposeOf;

      qryAux.Next;
    end;

  finally
    qryAux.DisposeOf;
    Lanc.DisposeOf;
  end;
end;

procedure TFrmLancamentosResumo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmLancamentosResumo := nil;
end;

procedure TFrmLancamentosResumo.FormShow(Sender: TObject);
begin
  MontarResumo;
end;

procedure TFrmLancamentosResumo.img_voltarClick(Sender: TObject);
begin
  Close;
end;

end.
