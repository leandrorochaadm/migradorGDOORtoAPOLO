unit uComandos;

interface

  function zerarcodigo(codigo: string; qtde: integer): string;
  procedure migrar;


implementation

uses uDM, System.SysUtils,Vcl.Dialogs ;

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
//    Open;

  end;

//  pb.Max:= dm.qrOrigem.RecordCount;

  try
  dm.qrOrigem.First;
   while not (dm.qrOrigem.Eof) do
   begin
//    pb.Position:=posicao;
    dm.qrDest.ParamByName('pCodigo').AsString := dm.qrOrigem.FieldByName('CODIGO').AsString;
    dm.qrDest.ParamByName('pNovoCod').AsString := zerarcodigo(dm.qrOrigem.FieldByName('CODIGO').AsString,6);
    dm.qrDest.ParamByName('pCODNOTA').AsString := zerarcodigo(dm.qrOrigem.FieldByName('CODNOTA').AsString,6);
    dm.qrDest.ParamByName('pCODPRODUTO').AsString := zerarcodigo(dm.qrOrigem.FieldByName('CODPRODUTO').AsString,6);
//    Label2.Caption:= IntToStr(posicao)+' de '+IntToStr(dm.qrOrigem.RecordCount) ;

    posicao:= posicao+1;
      dm.qrDest.ExecSQL;
      dm.qrOrigem.Next;
   end;

  except on E: Exception do
  ShowMessage(e.ToString);
  end;



//       testarQr;
// Label2.Caption := 'Contagem de registros' + IntToStr(qrOrigem.RecordCount);

end;
end.
