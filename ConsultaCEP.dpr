program ConsultaCEP;

uses
  Vcl.Forms,
  untConsultaCEP in 'untConsultaCEP.pas' {frmConsultaCEP};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmConsultaCEP, frmConsultaCEP);
  Application.Run;
end.
