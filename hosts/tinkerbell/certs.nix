{ ... }: {

  security.pki.certificateFiles = [
    ./certs/cert_ISA_GP_Intermediate.pem
    ./certs/cert_ISA_GP_Root.pem
    ./certs/cert_ISA_SSL-FWD-Trust.pem
    ./certs/wk1.cer
    ./certs/wk2.cer
    ./certs/wk3.cer
  ];
}
