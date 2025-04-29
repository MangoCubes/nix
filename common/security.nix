{ inputs, ... }:
{
  # My root certificate is trusted by default
  security.pki.certificateFiles = [
    "${inputs.secrets.res}/keys/root.crt"
  ];
  # CVE-2025-32438
  systemd.shutdownRamfs.enable = false;
}
