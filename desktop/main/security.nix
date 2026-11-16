{ secrets, ... }:
{
  security.pki.certificateFiles = [
    "${secrets.res}/keys/mitm/mitm.pem"
  ];
}
