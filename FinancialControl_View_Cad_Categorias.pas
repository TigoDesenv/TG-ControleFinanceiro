unit FinancialControl_View_Cad_Categorias;

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
  FMX.Edit,
  FMX.ListBox,
  FMX.DialogService,
  Classe_Categoria,
  DM_FinancialControl,
  FireDAC.comp.Client,
  FireDAC.DApt,
  Data.DB,
  FinancialControl_View_Categorias;

type
  TFrmCategoriasCad = class(TForm)
    Layout1: TLayout;
    lbl_titulo: TLabel;
    img_voltar: TImage;
    img_save: TImage;
    Layout2: TLayout;
    Label2: TLabel;
    edt_DescricaoCategoria: TEdit;
    Line1: TLine;
    Label1: TLabel;
    lb_icone: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    img_selecao: TImage;
    rect_Delete: TRectangle;
    img_Delete: TImage;
    procedure img_voltarClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure img_saveClick(Sender: TObject);
    procedure img_DeleteClick(Sender: TObject);
  private
    icone_selecionado: TBitmap;
    indice_selecionado: Integer;
    procedure SelecionaIcone(img: TImage);
    { Private declarations }
  public
    { Public declarations }
    Modo: String; //I (INCLUSÃO) / A (ALTERAÇÃO)
    // Depois criar um enumerdado
    Id_Cat: Integer;
  end;

var
  FrmCategoriasCad: TFrmCategoriasCad;

implementation

{$R *.fmx}

uses
  FinancialControl_View_Principal;

procedure TFrmCategoriasCad.SelecionaIcone(img: TImage);
begin
  icone_selecionado := img.Bitmap; // Salvei o icone selecionado...
  indice_selecionado := TListBoxItem(img.Parent).Index;

  img_selecao.Parent := img.Parent;
end;

procedure TFrmCategoriasCad.FormResize(Sender: TObject);
begin
  lb_icone.Columns := Trunc(lb_icone.Width / 80);
end;

procedure TFrmCategoriasCad.FormShow(Sender: TObject);
var
  Cat: TCategoria;
  Qry: TFDQuery;
  Erro: String;
  Item: TListBoxItem;
begin
  if Modo = 'I' then
  begin
    rect_Delete.Visible := False;
    edt_DescricaoCategoria.Text := '';
    SelecionaIcone(Image1);
  end
  else
  begin
    try
      rect_Delete.Visible := True;
      Cat := TCategoria.Create(dmFinancialControl.Connection);
      Cat.ID_CATEGORIA := Id_Cat;

      Qry := cat.ListarCategoria(erro);

      edt_DescricaoCategoria.Text := Qry.FieldByName('DESCRICAO').AsString;

      // Icone........
      Item := lb_icone.ItemByIndex(Qry.FieldByName('INDICE_ICONE').AsInteger);
      img_selecao.Parent := Item;
    finally
      Qry.DisposeOf;
      Cat.DisposeOf;
    end;
  end;
end;

procedure TFrmCategoriasCad.Image1Click(Sender: TObject);
begin
  SelecionaIcone(TImage(Sender));
end;

procedure TFrmCategoriasCad.img_DeleteClick(Sender: TObject);
var
  Cat: TCategoria;
  Erro: String;
begin
  TDialogService.MessageDialog('Confirma Exclusão?',
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
          Cat := TCategoria.Create(dmFinancialControl.Connection);
          Cat.ID_CATEGORIA := Id_Cat;

//        Cat.Excluir(Erro);
//        Outra Forma de Fazer o que está acima
          if not Cat.Excluir(Erro) then
          begin
            ShowMessage(Erro);
            Abort;
          end;

          FrmCategorias.ListarCategorias;
          Close;
        finally
          Cat.DisposeOf;
        end;
      end;
    end);
end;

procedure TFrmCategoriasCad.img_saveClick(Sender: TObject);
var
  Cat: TCategoria;
  Erro: String;
begin

  try
    Cat := TCategoria.Create(dmFinancialControl.Connection);
    Cat.DESCRICAO := edt_DescricaoCategoria.Text;
    Cat.ICONE := icone_selecionado;
    Cat.INDICE_ICONE := indice_selecionado;

    if Modo = 'I' then
      Cat.Inserir(erro)
    else
    begin
      Cat.ID_CATEGORIA := Id_Cat;
      Cat.Alterar(erro);
    end;

    if erro <> '' then
    begin
      ShowMessage(erro);
      Exit;
    end;

    FrmCategorias.ListarCategorias;
    Close;

  finally
    Cat.DisposeOf;
  end;
end;

procedure TFrmCategoriasCad.img_voltarClick(Sender: TObject);
begin
  close;
end;

end.
