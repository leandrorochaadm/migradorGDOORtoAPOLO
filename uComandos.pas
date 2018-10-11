unit uComandos;

interface

  function zerarcodigo(codigo: string; qtde: integer): string;
  procedure migrarCondicionalItem;
//  procedure teste(Sender: TObject);
  procedure log(txt: string);
  procedure migrarCondicionalCabecalho;



implementation

uses uDM, System.SysUtils,Vcl.Dialogs,Vcl.Forms , Unit1;

function zerarcodigo(codigo: string; qtde: integer): string;
begin
while Length(codigo) < qtde do codigo:= '0'+codigo;
Result := codigo;
end;


procedure migrarCondicionalItem;
var
posicao : integer;

  begin
  posicao:=1;


    with dm.qrOrigem, sql do
    begin
      Close;
      Clear;
      Text := 'select * from c000075';
      Open;
    end;

    with dm.qrDest, sql do
    begin
      Close;
      Clear;
      Text := 'update c000075 set CODIGO = :pNovoCod, CODNOTA = :pCODNOTA, CODPRODUTO = :pCODPRODUTO where CODIGO = :pCodigo';

      Form1.pb.Max:= dm.qrOrigem.RecordCount;

    try
    dm.qrOrigem.First;
     while not (dm.qrOrigem.Eof) do
     begin
      Form1.pb.Position:=posicao;
      dm.qrDest.ParamByName('pCodigo').AsString := dm.qrOrigem.FieldByName('CODIGO').AsString;
      dm.qrDest.ParamByName('pNovoCod').AsString := zerarcodigo(dm.qrOrigem.FieldByName('CODIGO').AsString,6);
      dm.qrDest.ParamByName('pCODNOTA').AsString := zerarcodigo(dm.qrOrigem.FieldByName('CODNOTA').AsString,6);
      dm.qrDest.ParamByName('pCODPRODUTO').AsString := zerarcodigo(dm.qrOrigem.FieldByName('CODPRODUTO').AsString,6);

      //log
      log(IntToStr(posicao)+' de '+IntToStr(dm.qrOrigem.RecordCount)+' -> '+
      'Condicional n. '+dm.qrOrigem.FieldByName('CODIGO').AsString+
      ' -> Produto '+
      dm.qrOrigem.FieldByName('CODPRODUTO').AsString);

      posicao:= posicao+1;
        dm.qrDest.ExecSQL;
        dm.qrOrigem.Next;
     end;

    except on E: Exception do
    ShowMessage(e.ToString);
    end;
  end;
end;

// procedure teste(Sender: TObject);
// begin
////   ShowMessage(TForm(sender).Name);
// end;

procedure log(txt: string);
begin
  form1.Memo1.Lines.Add(txt);
end;

procedure migrarCondicionalCabecalho;
var
posicao : integer;

  begin
  posicao:=1;


    with dm.qrOrigem, sql do
    begin
      Close;
      Clear;
      Text := 'select * from c000074';
      Open;
    end;

    with dm.qrDest, sql do
    begin
      Close;
      Clear;
      Text := 'update c000074 set CODIGO = :pNovoCod, CODNOTA = :pCODNOTA, CODPRODUTO = :pCODPRODUTO where CODIGO = :pCodigo';

      Form1.pb.Max:= dm.qrOrigem.RecordCount;

    try
    dm.qrOrigem.First;
     while not (dm.qrOrigem.Eof) do
     begin
      Form1.pb.Position:=posicao;
      dm.qrDest.ParamByName('pCodigo').AsString := dm.qrOrigem.FieldByName('CODIGO').AsString;
      dm.qrDest.ParamByName('pNovoCod').AsString := zerarcodigo(dm.qrOrigem.FieldByName('CODIGO').AsString,6);
      dm.qrDest.ParamByName('pCODNOTA').AsString := zerarcodigo(dm.qrOrigem.FieldByName('CODNOTA').AsString,6);
      dm.qrDest.ParamByName('pCODPRODUTO').AsString := zerarcodigo(dm.qrOrigem.FieldByName('CODPRODUTO').AsString,6);

      //log
      log(IntToStr(posicao)+' de '+IntToStr(dm.qrOrigem.RecordCount)+' -> '+
      'Condicional n. '+dm.qrOrigem.FieldByName('CODIGO').AsString+
      ' - Produto '+
      dm.qrOrigem.FieldByName('CODPRODUTO').AsString);

      posicao:= posicao+1;
        dm.qrDest.ExecSQL;
        dm.qrOrigem.Next;
     end;

    except on E: Exception do
    ShowMessage(e.ToString);
    end;
  end;
end;

end.
