{
  networking.firewall.enable = true;
  imports = [
    ./noswap.nix
  ];
  custom.device.type = "server";
  custom.traefik.enable = true;
}
