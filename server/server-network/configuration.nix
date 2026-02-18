# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.server-network
    ./home.nix
    ./traefik.nix

    ../packages/podman/adguard.nix
    ../packages/podman/headscale.nix
    ../packages/podman/netbird.nix
    ../base/configuration.nix

    inputs.secrets.server-network.restic
    ../packages/restic.nix

  ];
}
