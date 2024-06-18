unit cUsuario;

interface

uses
  FireDAC.comp.Client,
  FireDAC.DApt,
  System.SysUtils,
  FMX.Graphics;

type
  TUsuario = class
    private
      Fconnection: TFDConnection;
      FEMAIL: String;
      FSENHA: String;
      FNOME: String;
      FID_USUARIO: Integer;
      FIND_LOGIN: String;
      FFOTO: TBitMap;

    public
      constructor Create(connection: TFDConnection);
      property ID_USUARIO : Integer read FID_USUARIO write FID_USUARIO;
      property NOME : String read FNOME write FNOME;
      property EMAIL : String read FEMAIL write FEMAIL;
      property SENHA : String read FSENHA write FSENHA;
      property IND_LOGIN : String read FIND_LOGIN write FIND_LOGIN;
      property FOTO : TBitMap read FFOTO write FFOTO;

      function ListarUsuario(out erro: String): TFDQuery;
      function ValidarLogin(out erro: String): Boolean;
      function Inserir(out erro: String): Boolean;
      function Alterar(out erro: String): Boolean;
      function Excluir(out erro: String): Boolean;
      function Logout(out erro: string): boolean;
  end;

implementation

{ TCategoria }

function TUsuario.Alterar(out erro: String): Boolean;
var
  qry: TFDQuery;
begin
  // Validações
  if NOME = '' then
  begin
    erro := 'Informe o Nome do Usuário';
    Result := False;
    Exit;
  end;
  if EMAIL = '' then
  begin
    erro := 'Informe o E-mail do Usuário';
    Result := False;
    Exit;
  end;
  if SENHA = '' then
  begin
    erro := 'Informe a Senha do Usuário';
    Result := False;
    Exit;
  end;

  try
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := Fconnection;

      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('UPDATE TAB_USUARIO SET NOME = :NOME, EMAIL = :EMAIL,');
        SQL.Add('SENHA = :SENHA, IND_LOGIN = :IND_LOGIN, FOTO = :FOTO');
        SQL.Add('WHERE ID_USUARIO = :ID_USUARIO');
        ParamByName('NOME').Value := NOME;
        ParamByName('EMAIL').Value := EMAIL;
        ParamByName('SENHA').Value := SENHA;
        ParamByName('IND_LOGIN').Value := IND_LOGIN;
        ParamByName('FOTO').Assign(FOTO);
        ExecSQL;
      end;

      Result := True;
      erro := '';

    except on ex:exception do
    begin
      Result := False;
      erro := 'Erro ao Alterar Usuário: ' + ex.Message;
    end;
    end;
  finally
    qry.DisposeOf;
  end;
end;

constructor TUsuario.Create(connection: TFDConnection);
begin
  Fconnection := connection;
end;

function TUsuario.Excluir(out erro: String): Boolean;
var
  qry: TFDQuery;
begin
  try
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := Fconnection;

   // Valida se categoria tem lancamentos
      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('DELETE FROM TAB_USUARIO');
        SQL.Add('WHERE ID_USUARIO = :ID_USUARIO');
        ParamByName('ID_USUARIO').Value := ID_USUARIO;
        ExecSQL;
      end;

      Result := True;
      erro := '';

    except on ex:exception do
    begin
      Result := False;
      erro := 'Erro ao Excluir Usuário: ' + ex.Message;
    end;
    end;
  finally
    qry.Free;
  end;
end;

function TUsuario.Inserir(out erro: String): Boolean;
var
  qry: TFDQuery;
begin
  // Validações
  if NOME = '' then
  begin
    erro := 'Informe o Nome do Usuário';
    Result := False;
    Exit;
  end;

//  if EMAIL = '' then
//  begin
//    erro := 'Informe o E-mail do Usuário';
//    Result := False;
//    Exit;
//  end;

  if SENHA = '' then
  begin
    erro := 'Informe a Senha do Usuário';
    Result := False;
    Exit;
  end;

  try
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := Fconnection;

      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('INSERT INTO TAB_USUARIO (NOME, EMAIL, SENHA, IND_LOGIN, FOTO)');
        SQL.Add('VALUES (:NOME, :EMAIL, :SENHA, :IND_LOGIN, :FOTO)');
        ParamByName('NOME').Value := NOME;
        ParamByName('EMAIL').Value := EMAIL;
        ParamByName('SENHA').Value := SENHA;
        ParamByName('IND_LOGIN').Value := IND_LOGIN;
        ParamByName('FOTO').Assign(FOTO);
        ExecSQL;
      end;

      Result := True;
      erro := '';

    except on ex:exception do
    begin
      Result := False;
      erro := 'Erro ao Inserir Usuário: ' + ex.Message;
    end;
    end;
  finally
    qry.DisposeOf;
  end;
end;

function TUsuario.ListarUsuario(out erro: String): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Fconnection;

    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT * FROM TAB_USUARIO');
      SQL.Add('WHERE 1 = 1');

      if ID_USUARIO > 0 then
      begin
        SQL.Add('AND ID_USUARIO > 0');
        ParamByName('ID_USUARIO').Value := ID_USUARIO;
      end;

      if EMAIL <> '' then
      begin
        SQL.Add('AND EMAIL > 0');
        ParamByName('EMAIL').Value := EMAIL;
      end;

      if SENHA <> '' then
      begin
        SQL.Add('AND SENHA > 0');
        ParamByName('SENHA').Value := SENHA;
      end;

      Active := True;
    end;

    Result := qry;
    erro := '';
  except on ex:exception do
  begin
    Result := nil;
    erro := 'Erro ao Consultar Usuário: ' + ex.Message;
  end;
  end;
end;

function TUsuario.Logout(out erro: string): boolean;
var
  qryAux: TFDQuery;
begin
  try
    qryAux := TFDQuery.Create(nil);
    qryAux.Connection := Fconnection;

    try
      with qryAux do
      begin
        Active := false;
        sql.Clear;
        sql.Add('UPDATE TAB_USUARIO');
        SQL.Add('SET IND_LOGIN = ''N''');
        ExecSQL;
      end;

      Result := true;
      erro := '';

    except on ex:exception do
    begin
      Result := false;
      erro := 'Erro ao fazer logout: ' + ex.Message;
    end;
    end;
  finally
      qryAux.DisposeOf;
  end;
end;

function TUsuario.ValidarLogin(out erro: String): Boolean;
var
  qryAux: TFDQuery;
begin
  // Validações
  if EMAIL = '' then
  begin
    Erro := 'Informe o E-mail do Usuário';
    Result := False;
    Exit;
  end;

  if SENHA = '' then
  begin
    Erro := 'Informe a Senha do Usuário';
    Result := False;
    Exit;
  end;

  try
    qryAux := TFDQuery.Create(nil);
    qryAux.Connection := Fconnection;
    try
      with qryAux do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('SELECT * FROM TAB_USUARIO');
        SQL.Add('WHERE EMAIL = :EMAIL');
        SQL.Add('AND SENHA = :SENHA');
        ParamByName('EMAIL').Value := EMAIL;
        ParamByName('SENHA').Value := SENHA;
        Active := True;

        if qryAux.RecordCount = 0 then
        begin
          Result := False;
          Erro := 'Email ou Senha Inválido';
          Exit;
        end;

        Active := False;
        SQL.Clear;
        SQL.Add('UPDATE TAB_USUARIO');
        SQL.Add('SET IND_LOGIN = ''S''');
        ExecSQL;
      end;

      Result := True;
      Erro := '';
    except on ex:exception do
    begin
      Result := False;
      Erro := 'Erro ao Validar Login: ' + ex.Message;
    end;
    end;
  finally
    qryAux.DisposeOf;
  end;

end;

end.
