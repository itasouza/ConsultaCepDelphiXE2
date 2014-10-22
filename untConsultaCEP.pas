unit untConsultaCEP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL,IdHashMessageDigest, IdTCPConnection,
  IdTCPClient, IdHTTP;

type
  TfrmConsultaCEP = class(TForm)
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    btnOK: TBitBtn;
    editCep: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    XMLDocument1: TXMLDocument;
    Label2: TLabel;
    editCaminho: TEdit;
    XMLDocument2: TXMLDocument;
    Memo2: TMemo;
    SSLIO: TIdSSLIOHandlerSocketOpenSSL;
    IdHTTP: TIdHTTP;
    procedure btnOKClick(Sender: TObject);

  private
    { Private declarations }

        function MD5(const texto: string): string;
        procedure ConsultaCEP(pCEP, pChave, pPath: String);
        procedure ConsultaIBGE(pCEP, pChave, pPath: String);
        Procedure ConsultaWebService(pSenha, pLogin, ippdLogin :string);
        procedure ConsultaWebServiceNfePaulista(usuario, senha, cnpj, categoriausuario, nomearquivo, conteudo, obs: string; tipo:Boolean);
  public
    { Public declarations }
  end;

var
  frmConsultaCEP: TfrmConsultaCEP;

implementation

{$R *.dfm}

{ TfrmConsultaCEP }

procedure TfrmConsultaCEP.btnOKClick(Sender: TObject);
begin
  if editCep.Text = '' then
   begin
     ShowMessage('adicionar um cep...');
   end
   else
     begin
       ConsultaCEP(editCep.Text,'xxxx', editCaminho.Text);
       ConsultaIBGE(editCep.Text,'xxx', editCaminho.Text);
     end;

end;

procedure TfrmConsultaCEP.ConsultaCEP(pCEP, pChave, pPath: String);
var
  tempXML :IXMLNode;
  tempNodePAI :IXMLNode;
  tempNodeFilho :IXMLNode;
  I :Integer;
begin
   Memo1.Clear;
   XMLDocument1.FileName := 'http://www.devmedia.com.br/devware/cep/service/?cep='+pCEP+'&chave='+pChave+'&formato=xml';
   XMLDocument1.Active := true;
   if DirectoryExists(pPath) then
     // XMLDocument1.SaveToFile(pPath+FormatDateTime('ddmmyyyy_hhmmss', Now)+ '.xml');
      tempXML := XMLDocument1.DocumentElement;


   tempNodePAI := tempXML.ChildNodes.FindNode('logradouro');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo1.Lines.Add('Logradouro ...: ' +  tempNodeFilho.Text);
   end;
   tempNodePAI := tempXML.ChildNodes.FindNode('bairro');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo1.Lines.Add('Bairro ...: ' +  tempNodeFilho.Text);
   end;
   tempNodePAI := tempXML.ChildNodes.FindNode('cidade');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo1.Lines.Add('Cidade ...: ' + tempNodeFilho.Text);
   end;

   tempNodePAI := tempXML.ChildNodes.FindNode('uf');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo1.Lines.Add('UF ...: ' +  tempNodeFilho.Text);
   end;

   tempNodePAI := tempXML.ChildNodes.FindNode('unidade');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo1.Lines.Add('Unidade ...: ' +  tempNodeFilho.Text);
   end;

   tempNodePAI := tempXML.ChildNodes.FindNode('cpc');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo1.Lines.Add('cpc ...: ' +  tempNodeFilho.Text);
   end;

end;



procedure TfrmConsultaCEP.ConsultaIBGE(pCEP, pChave, pPath: String);
var
  tempXML :IXMLNode;
  tempNodePAI :IXMLNode;
  tempNodeFilho :IXMLNode;
  I :Integer;
begin
   Memo2.Clear;

                             //http://www.devmedia.com.br/devware/ibgecode/service/?cep=21760120&chave=WJLK1CA62Q&formato=xml
   XMLDocument2.FileName := 'http://www.devmedia.com.br/devware/ibgecode/service/?cep='+pCEP+'&chave='+pChave+'&formato=xml';
   XMLDocument2.Active := true;
   if DirectoryExists(pPath) then
     // XMLDocument1.SaveToFile(pPath+FormatDateTime('ddmmyyyy_hhmmss', Now)+ '.xml');
   tempXML := XMLDocument2.DocumentElement;

   tempNodePAI := tempXML.ChildNodes.FindNode('codigomunicipio');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo2.Lines.Add('Codigo Municipio ...: ' +  tempNodeFilho.Text);
   end;
   tempNodePAI := tempXML.ChildNodes.FindNode('cidade');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo2.Lines.Add('Cidade ...: ' + tempNodeFilho.Text);
   end;
   tempNodePAI := tempXML.ChildNodes.FindNode('uf');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo2.Lines.Add('UF ...: ' +  tempNodeFilho.Text);
   end;

end;



procedure TfrmConsultaCEP.ConsultaWebService(pSenha, pLogin, ippdLogin: string);
var
  tempXML :IXMLNode;
  tempNodePAI :IXMLNode;
  tempNodeFilho :IXMLNode;
  I :Integer;
begin

        //function logar()
        //{
        //    var url = "http://172.21.44.14:15080/aiwservices/v1/login";
        //    var user = document.getElementById("login").value;
        //    var pass = document.getElementById("senha").value;
        //    var requestHeader = "ippdLogin";
        //    var requestHeaderValue = "<login name=\"" + user + "\" pwd=\"" + pass + "\" lang=\"pt_BR\" />";
        //    solicitacao = "Logar";
        //    fazRequisicao(url, requestHeader, requestHeaderValue, "GET");
        // http://10.197.20.75:15080/aiwservices/v1/login&ippdLogin<login name=gilberto.mota\pwd=224@iniciar\lang=pt_BR>GET
        //}



   Memo2.Clear;
   //XMLDocument2.FileName := 'http://172.21.44.14:15080/aiwservices/v1/login/'+ippdLogin/?cep='+pCEP+'&chave='+pChave+'&formato=xml';
   //XMLDocument2.FileName := 'http://www.devmedia.com.br/devware/ibgecode/service/?cep='+pCEP+'&chave='+pChave+'&formato=xml';
   //XMLDocument2.Active := true;


    {
   if DirectoryExists(pPath) then
     // XMLDocument1.SaveToFile(pPath+FormatDateTime('ddmmyyyy_hhmmss', Now)+ '.xml');
   tempXML := XMLDocument2.DocumentElement;

   tempNodePAI := tempXML.ChildNodes.FindNode('codigomunicipio');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo2.Lines.Add('Codigo Municipio ...: ' +  tempNodeFilho.Text);
   end;
   tempNodePAI := tempXML.ChildNodes.FindNode('cidade');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo2.Lines.Add('Cidade ...: ' + tempNodeFilho.Text);
   end;
   tempNodePAI := tempXML.ChildNodes.FindNode('uf');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo2.Lines.Add('UF ...: ' +  tempNodeFilho.Text);
   end;
   }
end;


procedure TfrmConsultaCEP.ConsultaWebServiceNfePaulista(usuario, senha, cnpj, categoriausuario, nomearquivo,
                                                        conteudo, obs: string; tipo:Boolean);
var
  tempXML :IXMLNode;
  tempNodePAI :IXMLNode;
  tempNodeFilho :IXMLNode;
  I :Integer;

begin

   XMLDocument1.FileName := ' <?xml version="1.0" encoding="utf-8"?>'+#13#10;
   XMLDocument1.FileName := ' <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlnsoap12="http://www.w3.org/2003/05/soap-envelope">'+#13#10;
   XMLDocument1.FileName := ' <soap12:Header>'+#13#10;
   XMLDocument1.FileName := ' <Autenticacao Usuario='+QuotedStr(usuario)+' '+#13#10;
   XMLDocument1.FileName := ' Senha='+QuotedStr(senha)+' '+#13#10;
   XMLDocument1.FileName := ' CNPJ='+QuotedStr(cnpj)+' '+#13#10;
   XMLDocument1.FileName := ' CategoriaUsuario='+QuotedStr(categoriausuario)+' '+#13#10;
   XMLDocument1.FileName := ' xmlns="https://www.nfp.sp.gov.br/ws" />'+#13#10;
   XMLDocument1.FileName := ' </soap12:Header>'+#13#10;
   XMLDocument1.FileName := '  <soap12:Body>'+#13#10;
   XMLDocument1.FileName := '    <Enviar xmlns="https://www.nfp.sp.gov.br/ws">'+#13#10;
   XMLDocument1.FileName := '      <NomeArquivo>'+nomearquivo+'</NomeArquivo>'+#13#10;
   XMLDocument1.FileName := '      <ConteudoArquivo>'+conteudo+'</ConteudoArquivo>'+#13#10;
   if tipo = True then
   XMLDocument1.FileName := '    <EnvioNormal>true</EnvioNormal>'+#13#10
   else
   XMLDocument1.FileName := '    <EnvioNormal>false</EnvioNormal>'+#13#10;

   XMLDocument1.FileName := '      <Observacoes>'+obs+'</Observacoes>'+#13#10;
   XMLDocument1.FileName := '    </Enviar>'+#13#10;
   XMLDocument1.FileName := '  </soap12:Body>'+#13#10;
   XMLDocument1.FileName := ' </soap12:Envelope>'+#13#10;

   XMLDocument1.FileName := ' <?xml version="1.0" encoding="utf-8"?>'+#13#10;
   XMLDocument1.FileName := ' <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlnsoap12="http://www.w3.org/2003/05/soap-envelope">'+#13#10;
   XMLDocument1.FileName := '   <soap12:Body>'+#13#10;
   XMLDocument1.FileName := '     <EnviarResponse xmlns="https://www.nfp.sp.gov.br/ws">'+#13#10;
   XMLDocument1.FileName := '       <EnviarResult>string</EnviarResult>'+#13#10;
   XMLDocument1.FileName := '     </EnviarResponse>'+#13#10;
   XMLDocument1.FileName := '   </soap12:Body>'+#13#10;
   XMLDocument1.FileName := ' </soap12:Envelope>';

   XMLDocument1.Active := true;

   tempXML := XMLDocument1.DocumentElement;

   {
   tempNodePAI := tempXML.ChildNodes.FindNode('codigomunicipio');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo2.Lines.Add('Codigo Municipio ...: ' +  tempNodeFilho.Text);
   end;
   tempNodePAI := tempXML.ChildNodes.FindNode('cidade');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo2.Lines.Add('Cidade ...: ' + tempNodeFilho.Text);
   end;
   tempNodePAI := tempXML.ChildNodes.FindNode('uf');
   for i := 0 to tempNodePAI.ChildNodes.Count - 1 do
   begin
      tempNodeFilho := tempNodePAI.ChildNodes[i];
      memo2.Lines.Add('UF ...: ' +  tempNodeFilho.Text);
   end;
   }

end;

function TfrmConsultaCEP.MD5(const texto: string): string;
 var
  idmd5: TIdHashMessageDigest5;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  try
    result := idmd5.HashStringAsHex(texto);
  finally
    idmd5.Free;
  end;
end;

end.
