{ inputs, ... }:
{
  security.pki = {
    # My root certificate is trusted by default
    certificateFiles = [ "${inputs.secrets.res}/keys/root.crt" ];
    caCertificateBlacklist = [
      "Comodo AAA Services root"
    ];
  };
  # CVE-2025-32438
  systemd.shutdownRamfs.enable = false;
}
