{ secrets, ... }:
{
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  imports = [
    secrets.hw.server-home
    secrets.server-home.config
    secrets.server-home.restic
    ../packages/restic.nix
    ./traefik.nix
    ./home.nix
  ];
  system.stateVersion = "25.11";
}
