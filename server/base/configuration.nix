{ inputs, ... }:
{
  networking.firewall.enable = true;
  security.pam.sshAgentAuth.enable = true;
  imports = [
    inputs.secrets.server
    ./noswap.nix
  ];
  custom.device.type = "server";
  custom.traefik.enable = true;
}
