{ inputs, ... }:
{
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  imports = [
    inputs.secrets.hw.server-home
    ./home.nix
    ./traefik.nix
    ./proxmox.nix
  ];
  system.stateVersion = "25.11";
}
