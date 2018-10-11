unit uComandos;

interface

  function zerarcodigo(codigo: string; qtde: integer): string;
  procedure migrar;


implementation

function zerarcodigo(codigo: string; qtde: integer): string;
begin
while Length(codigo) < qtde do codigo:= '0'+codigo;
Result := codigo;
end;


procedure migrar;
var
posicao : integer;

begin
posicao:=0;


  with qrOrigem, sql do
  begin
    Close;
    Clear;
    Text := 'select * from c000075';
    Open;
  end;

  with qrDest, sql do
  begin
    Close;
    Clear;
    Text := 'update c000075 set CODIGO = :pNovoCod, CODNOTA = :pCODNOTA, CODPRODUTO = :pCODPRODUTO where CODIGO = :pCodigo';
//    Open;

  end;

  pb.Max:= qrOrigem.RecordCount;

  try
  qrOrigem.First;
   while not (qrOrigem.Eof) do
   begin
    pb.Position:=posicao;
    qrDest.ParamByName('pCodigo').AsString := qrOrigem.FieldByName('CODIGO').AsString;
    qrDest.ParamByName('pNovoCod').AsString := zerarcodigo(qrOrigem.FieldByName('CODIGO').AsString,6);
    qrDest.ParamByName('pCODNOTA').AsString := zerarcodigo(qrOrigem.FieldByName('CODNOTA').AsString,6);
    qrDest.ParamByName('pCODPRODUTO').AsString := zerarcodigo(qrOrigem.FieldByName('CODPRODUTO').AsString,6);
    Label2.Caption:= IntToStr(posicao)+' de '+IntToStr(qrOrigem.RecordCount) ;

    posicao:= posicao+1;
      qrDest.ExecSQL;
      qrOrigem.Next;
   end;

  except on E: Exception do
  ShowMessage(e.ToString);
  end;



//       testarQr;
// Label2.Caption := 'Contagem de registros' + IntToStr(qrOrigem.RecordCount);

end;
end.
