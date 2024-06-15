unit Classe_Categoria;

interface

uses
  FireDAC.comp.Client,
  FireDAC.DApt,
  System.SysUtils,
  FMX.Graphics;

type
  TCategoria = class
    private
      Fconnection: TFDConnection;
      FID_CATEGORIA: Integer;
      FDESCRICAO: String;
      FICONE: TBitMap;
      FINDICE_ICONE: Integer;
    public
      constructor Create(connection: TFDConnection);
      property ID_CATEGORIA : Integer read FID_CATEGORIA write FID_CATEGORIA;
      property DESCRICAO : String read FDESCRICAO write FDESCRICAO;
      property ICONE : TBitMap read FICONE write FICONE;
      property INDICE_ICONE : Integer read FINDICE_ICONE write FINDICE_ICONE;

      function ListarCategoria(out erro: String): TFDQuery;
      function Inserir(out erro: String): Boolean;
      function Alterar(out erro: String): Boolean;
      function Excluir(out erro: String): Boolean;
  end;

implementation

{ TCategoria }

function TCategoria.Alterar(out erro: String): Boolean;
var
  qry: TFDQuery;
begin
  // Validações
  if ID_CATEGORIA <= 0 then
  begin
    erro := 'Informe o ID da categoria';
    Result := False;
    Exit;
  end;

  if Length(Trim(DESCRICAO)) = 0 then
  begin
    erro := 'Informe a descrição da categoria';
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
        SQL.Add('UPDATE TAB_CATEGORIA SET DESCRICAO = :DESCRICAO, ICONE = :ICONE,');
        SQL.Add('INDICE_ICONE = :INDICE_ICONE');
        SQL.Add('WHERE ID_CATEGORIA = :ID_CATEGORIA');
        ParamByName('DESCRICAO').AsString := DESCRICAO;
        ParamByName('ICONE').Assign(ICONE);
        ParamByName('ID_CATEGORIA').AsInteger := ID_CATEGORIA;
        ParamByName('INDICE_ICONE').Value := INDICE_ICONE;
        ExecSQL;
      end;

      Result := True;
      erro := '';

    except on ex:exception do
    begin
      Result := False;
      erro := 'Erro ao Alterar Categoria: ' + ex.Message;
    end;
    end;
  finally
    qry.DisposeOf;
  end;
end;

constructor TCategoria.Create(connection: TFDConnection);
begin
  Fconnection := connection;
end;

function TCategoria.Excluir(out erro: String): Boolean;
var
  qry: TFDQuery;
begin
  // Validações
  if ID_CATEGORIA <= 0 then
  begin
    erro := 'Informe o ID da categoria';
    Result := False;
    Exit;
  end;

  try
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := Fconnection;

   // Valida se categoria tem lancamentos
      with qry do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('SELECT * FROM TAB_LANCAMENTO');
        SQL.Add('WHERE ID_CATEGORIA = :ID_CATEGORIA');
        ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
        Active := True;

        if RecordCount > 0 then
        begin
          Result := False;
          erro := 'A categoria possui lançamentos e não pode ser excluída';
          Exit;
        end;

        Active := False;
        SQL.Clear;
        SQL.Add('DELETE FROM TAB_CATEGORIA ');
        SQL.Add('WHERE ID_CATEGORIA = :ID_CATEGORIA');
        ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
        ExecSQL;
      end;

      Result := True;
      erro := '';

    except on ex:exception do
    begin
      Result := False;
      erro := 'Erro ao Excluir Categoria: ' + ex.Message;
    end;
    end;
  finally
    qry.Free;
  end;
end;

function TCategoria.Inserir(out erro: String): Boolean;
var
  qry: TFDQuery;
begin
  // Validações
  if Length(Trim(DESCRICAO)) = 0 then
  begin
    erro := 'Informe a descrição da categoria';
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
        SQL.Add('INSERT INTO TAB_CATEGORIA (DESCRICAO, ICONE, INDICE_ICONE)');
        SQL.Add('VALUES (:DESCRICAO, :ICONE, :INDICE_ICONE)');
        ParamByName('DESCRICAO').Value := DESCRICAO;
        ParamByName('ICONE').Assign(ICONE);
        ParamByName('INDICE_ICONE').Value := INDICE_ICONE;
        ExecSQL;
      end;

      Result := True;
      erro := '';

    except on ex:exception do
    begin
      Result := False;
      erro := 'Erro ao Inserir Categoria: ' + ex.Message;
    end;
    end;
  finally
    qry.DisposeOf;
  end;
end;

function TCategoria.ListarCategoria(out erro: String): TFDQuery;
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
      SQL.Add('SELECT * FROM TAB_CATEGORIA');
      SQL.Add('WHERE ID_CATEGORIA > 0');

      if ID_CATEGORIA > 0 then
      begin
        SQL.Add('AND ID_CATEGORIA = :ID_CATEGORIA');
        ParamByName('ID_CATEGORIA').AsInteger := ID_CATEGORIA;
      end;

//      if Length(Trim(DESCRICAO)) > 0 then
//      begin
//        SQL.Add('AND DESCRICAO = :DESCRICAO');
//        ParamByName('DESCRICAO').AsString := DESCRICAO;
//      end;

      Active := True;
    end;

    Result := qry;
    erro := '';
  except on ex:exception do
  begin
    Result := nil;
    erro := 'Erro ao Consultar Categoria: ' + ex.Message;
  end;
  end;
end;

end.
