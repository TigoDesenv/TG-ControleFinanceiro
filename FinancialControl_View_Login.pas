unit FinancialControl_View_Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.TabControl,
  System.Actions, FMX.ActnList, uPermissions, FMX.MediaLibrary.Actions,
  FinancialControl_View_Principal,
  FireDAC.comp.Client,
  FireDAC.DApt,
  Data.DB,
  uFuncoesTeclado,
  {$IFDEF ANDROID}
  FMX.VirtualKeyboard, FMX.Platform,
  {$ENDIF}
  FMX.StdActns, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, Datasnap.DBClient, FireDAC.Comp.DataSet;

type
  TFrmLogin = class(TForm)
    Layout2: TLayout;
    img_login_logo: TImage;
    Layout1: TLayout;
    RoundRect1: TRoundRect;
    edt_login_email: TEdit;
    StyleBook1: TStyleBook;
    Layout3: TLayout;
    RoundRect2: TRoundRect;
    edt_login_senha: TEdit;
    Layout4: TLayout;
    rectLogin: TRoundRect;
    Label1: TLabel;
    TabControl1: TTabControl;
    TabLogin: TTabItem;
    TabConta: TTabItem;
    Layout5: TLayout;
    Layout6: TLayout;
    RoundRect4: TRoundRect;
    edt_cad_nome: TEdit;
    Layout7: TLayout;
    RoundRect5: TRoundRect;
    edt_cad_senha: TEdit;
    Layout8: TLayout;
    rectContaProximo: TRoundRect;
    Label2: TLabel;
    Layout9: TLayout;
    RoundRect7: TRoundRect;
    TabFoto: TTabItem;
    Layout10: TLayout;
    circEditarFoto: TCircle;
    Layout11: TLayout;
    rectConta: TRoundRect;
    Label3: TLabel;
    TabEscolher: TTabItem;
    Layout12: TLayout;
    Label4: TLabel;
    imgFotoCamera: TImage;
    imgFotoGaleria: TImage;
    Layout13: TLayout;
    imgCriarContaVoltar: TImage;
    Layout14: TLayout;
    Image1: TImage;
    Layout15: TLayout;
    Layout16: TLayout;
    lblLogin: TLabel;
    lblCriarConta: TLabel;
    Rectangle1: TRectangle;
    ActionList1: TActionList;
    actConta: TChangeTabAction;
    actEscolher: TChangeTabAction;
    actFoto: TChangeTabAction;
    actLogin: TChangeTabAction;
    Layout17: TLayout;
    Layout18: TLayout;
    lblLoginInicio: TLabel;
    Label6: TLabel;
    Rectangle2: TRectangle;
    actLibrary: TTakePhotoFromLibraryAction;
    actCamera: TTakePhotoFromCameraAction;
    edt_cad_email: TEdit;
    Timer1: TTimer;
    Circle1: TCircle;
    Circle2: TCircle;
    procedure lblCriarContaClick(Sender: TObject);
    procedure lblLoginInicioClick(Sender: TObject);
    procedure rectContaProximoClick(Sender: TObject);
    procedure imgCriarContaVoltarClick(Sender: TObject);
    procedure circEditarFotoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgFotoCameraClick(Sender: TObject);
    procedure imgFotoGaleriaClick(Sender: TObject);
    procedure imgEscolherVoltarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure rectLoginClick(Sender: TObject);
    procedure rectContaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure actLibraryDidFinishTaking(Image: TBitmap);
    procedure actCameraDidFinishTaking(Image: TBitmap);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Permissao : TTGPermissions;
    procedure TrataPermissao(Sender: TObject);
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;
  AlterandoFoto: Boolean;

implementation

{$R *.fmx}

uses
  cUsuario,
  DM_FinancialControl;

procedure TFrmLogin.actCameraDidFinishTaking(Image: TBitmap);
begin
  circEditarFoto.Fill.Bitmap.Bitmap := Image;

  ActFoto.Execute;
end;

procedure TFrmLogin.actLibraryDidFinishTaking(Image: TBitmap);
begin
  circEditarFoto.Fill.Bitmap.Bitmap := Image;

  ActFoto.Execute;
end;

procedure TFrmLogin.circEditarFotoClick(Sender: TObject);
begin
  actEscolher.Execute;
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmLogin := nil;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  Permissao := TTGPermissions.Create;
  AlterandoFoto := False;
  if AlterandoFotoLogin then
    AlterandoFoto := True;
end;

procedure TFrmLogin.FormDestroy(Sender: TObject);
begin
  Permissao.DisposeOf;
end;

procedure TFrmLogin.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
{$IFDEF ANDROID}
var
    FService : IFMXVirtualKeyboardService;
{$ENDIF}
begin
{$IFDEF ANDROID}
  if (Key = vkHardwareBack) then
  begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
      IInterface(FService));

    if (FService <> nil) and
      (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
    begin
      // Botao back pressionado e teclado visivel...
      // (apenas fecha o teclado)
      TabControl1.Margins.Bottom := 0;
    end
    else
    begin
      // Botao back pressionado e teclado NAO visivel...

      if TabControl1.ActiveTab = TabConta then
      begin
        Key := 0;
        ActLogin.Execute
      end
      else if TabControl1.ActiveTab = TabFoto then
      begin
        Key := 0;
        ActConta.Execute
      end
      else if TabControl1.ActiveTab = TabEscolher then
      begin
        Key := 0;
        ActFoto.Execute;
      end;
    end;
  end;
{$ENDIF}
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  if not AlterandoFoto then
  begin
    TabControl1.ActiveTab := TabLogin;
    Timer1.Enabled := True;
  end;
  if AlterandoFoto then
  begin
    TabControl1.ActiveTab := TabFoto;
    Label3.Text := 'Confirmar Altera��o';
  end;
end;

procedure TFrmLogin.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  //TabControl1.Margins.Bottom := 0;
end;

procedure TFrmLogin.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  TabControl1.Margins.Bottom := 160;
end;

procedure TFrmLogin.imgCriarContaVoltarClick(Sender: TObject);
begin
  actConta.Execute;
end;

procedure TFrmLogin.imgEscolherVoltarClick(Sender: TObject);
begin
  actFoto.Execute;
end;

procedure TFrmLogin.imgFotoCameraClick(Sender: TObject);
begin
  Permissao.Camera(actCamera, TrataPermissao);
end;

procedure TFrmLogin.imgFotoGaleriaClick(Sender: TObject);
begin
  Permissao.PhotoLibrary(actLibrary, TrataPermissao);
end;

procedure TFrmLogin.lblCriarContaClick(Sender: TObject);
begin
  actConta.Execute;
end;

procedure TFrmLogin.lblLoginInicioClick(Sender: TObject);
begin
  actLogin.Execute;
end;

procedure TFrmLogin.rectContaClick(Sender: TObject);
var
  User: TUsuario;
  Erro: String;
begin
  try
    User := TUsuario.Create(dmFinancialControl.Conexao);

    if not AlterandoFoto then
    begin
      User.NOME := edt_cad_nome.Text;
      User.EMAIL := edt_cad_email.Text;
      User.SENHA := edt_cad_senha.Text;
      USer.IND_LOGIN := 'S';
      User.FOTO := circEditarFoto.Fill.Bitmap.Bitmap;
//      User.FOTO := circle1.Fill.Bitmap.Bitmap;

      // Excluir conta existente...
      if not User.Excluir(Erro) then
      begin
        ShowMessage(Erro + '00');
        TabControl1.ActiveTab := TabConta;
        Exit;
      end;

      // Cadastrar novo usu�rio...
      if not User.Inserir(Erro) then
      begin
        ShowMessage(Erro + '01');
        TabControl1.ActiveTab := TabConta;
        Exit;
      end;
    end
    else
    begin
      User.BuscaUsuarioLogado(Erro);
//      User.FOTO := circle2.Fill.Bitmap.Bitmap;
      User.FOTO := circEditarFoto.Fill.Bitmap.Bitmap;

      if not User.Alterar(Erro) then
      begin
        ShowMessage(Erro + '03');
        TabControl1.ActiveTab := TabConta;
        Exit;
      end;
      FrmPrincipal.CarregaIcone;
    end;
  finally
    User.DisposeOf;
  end;

  if not Assigned(FrmPrincipal) then
    Application.CreateForm(TFrmPrincipal, FrmPrincipal);

  Application.MainForm := FrmPrincipal;
  FrmPrincipal.Show;
  FrmLogin.Close;
end;

procedure TFrmLogin.rectContaProximoClick(Sender: TObject);
begin
  actFoto.Execute;
end;

procedure TFrmLogin.rectLoginClick(Sender: TObject);
var
  User: TUsuario;
  Erro: String;
begin
  try
    User := TUsuario.Create(dmFinancialControl.Conexao);
    User.EMAIL := edt_login_email.Text;
    User.SENHA := edt_login_senha.Text;

    if not User.ValidarLogin(Erro) then
    begin
      ShowMessage(Erro);
      Exit;
    end;

  finally
    User.DisposeOf;
  end;

  if not Assigned(FrmPrincipal) then
    Application.CreateForm(TFrmPrincipal, FrmPrincipal);

  Application.MainForm := FrmPrincipal;
  FrmPrincipal.Show;
  FrmLogin.Close;
end;

procedure TFrmLogin.Timer1Timer(Sender: TObject);
var
  User: TUsuario;
  Erro: String;
  qryAux: TFDQuery;
begin
  Timer1.Enabled := False;

  // Valida se usuario ja esta logado
  try
    User := TUsuario.Create(dmFinancialControl.Conexao);
    qryAux := TFDQuery.Create(nil);

    qryAux := User.ListarUsuario(Erro);

    if qryAux.FieldByName('IND_LOGIN').AsString <> 'S' then
      Exit;

  finally
    User.DisposeOf;
    qryAux.DisposeOf;
  end;

  if not Assigned(FrmPrincipal) then
    Application.CreateForm(TFrmPrincipal, FrmPrincipal);

  Application.MainForm := FrmPrincipal;
  FrmPrincipal.Show;
  FrmLogin.Close;
end;

procedure TFrmLogin.TrataPermissao(Sender: TObject);
begin
  ShowMessage('Voc� n�o possui permiss�o de acesso para esse recurso.');
end;

end.
