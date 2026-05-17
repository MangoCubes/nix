{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.server-home
    ./home.nix
    ./traefik.nix
  ];
  system.stateVersion = "25.11";
}
