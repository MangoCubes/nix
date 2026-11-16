{ secrets, ... }:
{
  networking.firewall.enable = true;
  security.pam.sshAgentAuth.enable = true;
  imports = [
    secrets.server.common
    ./noswap.nix
  ];
  custom.device.type = "server";
  custom.traefik.enable = true;
}
