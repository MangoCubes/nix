{
  networking.firewall.enable = true;
  imports = [
    ./noswap.nix
  ];
  custom.traefik.enable = true;
}
