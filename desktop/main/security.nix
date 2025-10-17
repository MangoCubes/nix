{ inputs, ... }:
{
  security.pki.certificateFiles = [
    "${inputs.secrets.res}/keys/mitm/mitm.pem"
  ];
}
