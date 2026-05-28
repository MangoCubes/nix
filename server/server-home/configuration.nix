{ inputs, ... }:
{
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  imports = [
    inputs.secrets.hw.server-home
    inputs.secrets.server-home
    ./traefik.nix
  ];
  system.stateVersion = "25.11";
}
