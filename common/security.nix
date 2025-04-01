{ inputs, ... }:
{
  # My root certificate is trusted by default
  security.pki.certificateFiles = [
    "${inputs.secrets.res}/keys/root.crt"
  ];
}
