{ config, ... }:
{
  # Import is basically "merge these files into this file"
  # This allows you to split files into multiple parts
  imports = [
    ./time.nix
    ./users.nix
    ./environment.nix
    ./security.nix
    ./home.nix
    ./packages/netbird.nix
    ./nix.nix
    ./packages/zsh.nix
    ./packages/ssh.nix
    ./packages/podman.nix
    ./packages/podman/traefik.nix
  ];
  config.custom.ssh = config.custom.device.type != "vm";
  config.custom.podman = config.custom.device.type != "vm";
}
