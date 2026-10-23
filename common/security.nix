{ inputs, ... }:
{
  security.pki = {
    # My root certificate is trusted by default
    certificateFiles = [ "${inputs.secrets.res}/keys/root.crt" ];
    caCertificateBlacklist = [
      "Comodo AAA Services root"
      "emSign ECC Root CA - G3"
    ];
  };
  # CVE-2025-32438
  systemd.shutdownRamfs.enable = false;
}
