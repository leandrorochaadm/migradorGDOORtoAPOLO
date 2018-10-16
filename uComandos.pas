unit uComandos;

interface

uses
  System.SysUtils, Vcl.Dialogs;

function zerarcodigo(codigo: string; qtde: integer): string;
procedure migrarCondicionalItem;
// procedure teste(Sender: TObject);
procedure log(txt: string);
procedure migrarCondicionalCabecalho;
function verSequencia(tabela:string):integer;
procedure atualizarSequencia(tabela:string; add:integer);


implementation

uses uDM, Vcl.Forms, Unit1;

function zerarcodigo(codigo: string; qtde: integer): string;
begin
  while Length(codigo) < qtde do
    codigo := '0' + codigo;
  Result := codigo;
end;

function verSequencia(tabela:string):integer;
begin
with dm.qrCommon, sql do
  begin
    Close;
    Clear;
    Text := 'select sequencia from c000000 c where c.codigo ='+tabela;
    Open;
  end;
  Result:= dm.qrCommon.FieldByName('SEQUENCIA').AsInteger;
end;

procedure atualizarSequencia(tabela:string; add:integer);
begin
//with dm.qrCommon, sql do
//  begin
//    Close;
//    Clear;
//    Text := 'update c000000 c set c.SEQUENCIA = c.SEQUENCIA+'+add+' where c.CODIGO='+tabela;
//    ExecSQL;
//  end;

end;

procedure migrarCondicionalCabecalho;
var
  posicao: integer;
const
sqlOrigem: String = 'SELECT '+
    'COND.controle AS CODIGO, '+
    '000099 AS CODCAIXA, '+
    '''000001'' as CODVENDEDOR, '+
    'COND.data as DATA , '+
    'COND.codcliente as codcliente, '+
    'COND.valortotal AS TOTAL, '+
    '9 AS TIPO, '+
    '1 AS SITUACAO, '+
    '1 AS ATACADO_VAREJO, '+
    '0 AS RETORNO, '+
    '''Condicional'' as OBS '+
    'FROM tcondicional  COND '+
    'where cond.controle in (select it.codcondicional from titemcondicional it)';



  sqlDest: String = 'INSERT INTO C000074 (CODIGO,CODCAIXA,CODVENDEDOR,DATA,CODCLIENTE,TOTAL,TIPO,SITUACAO,ATACADO_VAREJO,RETORNO,OBS ' +
  ' ) VALUES ( '+
    ':pCODIGO, '+
    ':pCODCAIXA, '+
    ':pCODVENDEDOR, '+
    ':pDATA, '+
    ':pCODCLIENTE, '+
    ':pTOTAL, '+
    ':pTIPO, '+
    ':pSITUACAO, '+
    ':pATACADO_VAREJO, '+
    ':pRETORNO, '+
    ':pOBS '+
    ' ) ';

begin
  posicao := 1;
//  ShowMessage(sqlOrigem +
//  chr(13) + chr(10)+
//  chr(13) + chr(10)+
//  sqlDest);


  with dm.qrOrigem, sql do
  begin
    Close;
    Clear;
    Text := sqlOrigem;
    Open;
  end;

  with dm.qrDest, sql do
  begin
    Close;
    Clear;
    Text := sqlDest;
//    Open;
  end;

  Form1.pb.Max := dm.qrOrigem.RecordCount;
//  ShowMessage(INTTOSTR(verSequencia('000075')));

  try
    dm.qrOrigem.First;
    while not(dm.qrOrigem.Eof) do
    begin
      Form1.pb.Position := posicao;
      dm.qrDest.ParamByName('pCODIGO').AsString :=
        zerarcodigo(IntToStr(dm.qrOrigem.FieldByName('CODIGO').AsInteger),6);

      dm.qrDest.ParamByName('pCODCAIXA').AsString :=  '000099';
//
      dm.qrDest.ParamByName('pCODVENDEDOR').AsString :=  '000001';
////        zerarcodigo(IntToStr(dm.qrOrigem.FieldByName('CODVENDEDOR').AsInteger),6);
////
      dm.qrDest.ParamByName('pDATA').AsDate :=
        dm.qrOrigem.FieldByName('DATA').AsDateTime;
//
      dm.qrDest.ParamByName('pcodcliente').AsString :=
        zerarcodigo(IntToStr(dm.qrOrigem.FieldByName('codcliente').AsInteger),6);

      dm.qrDest.ParamByName('pTOTAL').AsFloat :=
        dm.qrOrigem.FieldByName('TOTAL').AsFloat;

      dm.qrDest.ParamByName('pTIPO').AsInteger :=   9;
////        dm.qrOrigem.FieldByName('TIPO').AsInteger ;
//
      dm.qrDest.ParamByName('pSITUACAO').AsInteger :=  1;
////        dm.qrOrigem.FieldByName('SITUACAO').AsInteger;
//
      dm.qrDest.ParamByName('pATACADO_VAREJO').AsInteger :=    1;
////        dm.qrOrigem.FieldByName('ATACADO_VAREJO').AsInteger;
//
      dm.qrDest.ParamByName('pRETORNO').AsInteger :=  0;
////        dm.qrOrigem.FieldByName('RETORNO').AsInteger;
//
      dm.qrDest.ParamByName('pOBS').AsString :=   'Condicional';
////        dm.qrOrigem.FieldByName('OBS').AsString;

      // log
      log(IntToStr(posicao) + ' de ' + IntToStr(dm.qrOrigem.RecordCount) +
        ' -> ' + 'Condicional n. ' + dm.qrOrigem.FieldByName('CODIGO').AsString
        + ' -> Cliente ' + dm.qrOrigem.FieldByName('CODCLIENTE').AsString);

      posicao := posicao + 1;
      dm.qrDest.ExecSQL;
      dm.qrOrigem.Next;
    end;

  except
    on E: Exception do
      ShowMessage(E.ToString);
  end;

end;





procedure log(txt: string);
begin
  Form1.Memo1.Lines.Add(txt);
end;


//##############################################################################################################################################

//##############################################################################################################################################


procedure migrarCondicionalItem;
var
  posicao: integer;
const
sqlOrigem: String = 'SELECT '+
    'IT.controle AS CODIGO, '+
    'IT.codcondicional AS CODNOTA, '+
    'IT.codproduto AS CODPRODUTO, '+
    'IT.valorunitario AS UNITARIO, '+
    'IT.valortotal AS TOTAL, '+
    'IT.cfop AS CFOP, '+
    'IT.datahoracadastro AS DATA, '+
    'IT.un AS UNIDADE, '+
    'IT.qtde, '+
    '2 AS MOVIMENTO '+
    'FROM titemcondicional  IT ';

sqlDest: String = 'INSERT INTO C000075 (CODIGO,CODNOTA,CODPRODUTO,UNITARIO,TOTAL,CFOP,DATA,UNIDADE,qtde,MOVIMENTO ' +
  ' ) VALUES ( '+
    ':pCODIGO, '+
    ':pCODNOTA, '+
    ':pCODPRODUTO, '+
    ':pUNITARIO, '+
    ':pTOTAL, '+
    ':pCFOP, '+
    ':pDATA, '+
    ':pUNIDADE, '+
    ':pqtde, '+
    ':pMOVIMENTO '+
//    ':pCODPRODUTO '+

    ' ) ';

begin
  posicao := 1;

//ShowMessage(sqlOrigem +
//  chr(13) + chr(10)+
//  chr(13) + chr(10)+
//  sqlDest);


  with dm.qrOrigem, sql do
  begin
    Close;
    Clear;
    Text := sqlOrigem;
    Open;
  end;

  with dm.qrDest, sql do
  begin
    Close;
    Clear;
    Text := sqlDest;

  end;

  Form1.pb.Max := dm.qrOrigem.RecordCount;

  try
    dm.qrOrigem.First;
    while not(dm.qrOrigem.Eof) do
    begin
      Form1.pb.Position := posicao;

//      ShowMessage( zerarcodigo(IntToStr(dm.qrOrigem.FieldByName('CODIGO').AsInteger), 6));

      dm.qrDest.ParamByName('pCODIGO').AsString :=
        zerarcodigo(IntToStr(dm.qrOrigem.FieldByName('CODIGO').AsInteger), 6);

      dm.qrDest.ParamByName('pCODNOTA').AsString :=
        zerarcodigo(IntToStr(dm.qrOrigem.FieldByName('CODNOTA').AsInteger), 6);

      dm.qrDest.ParamByName('pCODPRODUTO').AsString :=
        zerarcodigo(IntToStr(dm.qrOrigem.FieldByName('CODPRODUTO').AsInteger), 6);

      dm.qrDest.ParamByName('pUNITARIO').AsFloat :=
        dm.qrOrigem.FieldByName('UNITARIO').AsFloat;

      dm.qrDest.ParamByName('pTOTAL').AsFloat :=
        dm.qrOrigem.FieldByName('TOTAL').AsFloat;

      dm.qrDest.ParamByName('pCFOP').AsString :=
        dm.qrOrigem.FieldByName('CFOP').AsString;

      dm.qrDest.ParamByName('pTOTAL').AsFloat :=
        dm.qrOrigem.FieldByName('TOTAL').AsFloat;

      dm.qrDest.ParamByName('pDATA').AsDate :=
        dm.qrOrigem.FieldByName('DATA').AsDateTime;

      dm.qrDest.ParamByName('pUNIDADE').AsString :=
        dm.qrOrigem.FieldByName('UNIDADE').AsString;
//
      dm.qrDest.ParamByName('pqtde').AsFloat :=
        dm.qrOrigem.FieldByName('qtde').AsFloat;
//
      dm.qrDest.ParamByName('pMOVIMENTO').AsInteger :=
        dm.qrOrigem.FieldByName('MOVIMENTO').AsInteger;
//
//      dm.qrDest.ParamByName('pTOTAL').AsFloat :=
//        dm.qrOrigem.FieldByName('TOTAL').AsFloat;
//
//      dm.qrDest.ParamByName('pTOTAL').AsFloat :=
//        dm.qrOrigem.FieldByName('TOTAL').AsFloat;
//
//      dm.qrDest.ParamByName('pTOTAL').AsFloat :=
//        dm.qrOrigem.FieldByName('TOTAL').AsFloat;
//
//      dm.qrDest.ParamByName('pTOTAL').AsFloat :=
//        dm.qrOrigem.FieldByName('TOTAL').AsFloat;



      // log
      log(IntToStr(posicao) + ' de ' + IntToStr(dm.qrOrigem.RecordCount) +
        ' -> ' + 'Condicional n. ' + dm.qrOrigem.FieldByName('CODIGO').AsString+
        ' -> ' + 'Prod cod. ' + dm.qrOrigem.FieldByName('CODPRODUTO').AsString
        );

      posicao := posicao + 1;
      dm.qrDest.ExecSQL;
      dm.qrOrigem.Next;
    end;

//    atualizarSequencia('000075',posicao);

  except
    on E: Exception do
      ShowMessage(E.ToString);
  end;

end;

end.
