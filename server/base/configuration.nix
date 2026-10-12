{
  networking.firewall.enable = true;
  security.pam.sshAgentAuth.enable = true;
  imports = [
    ./noswap.nix
  ];
  custom.device.type = "server";
  custom.traefik.enable = true;
}
