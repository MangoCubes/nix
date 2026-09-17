# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, ... }:
{
  imports = [
    inputs.secrets.desktop.configuration
    ./environment.nix
    ./home.nix
    ./networking.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./boot.nix
    ./sound.nix
    ../packages/kmonad.nix
    ../packages/bluetooth.nix
    ../packages/fonts.nix
    ../packages/greeter.nix
    ../packages/swaylock.nix
    ../packages/ydotool.nix
  ];
  custom.traefik.enable = true;
  powerManagement.enable = true;
  programs.nix-ld.enable = true;
  boot.kernelParams = [ "mem_sleep_default=s2idle" ];
  systemd.services.NetworkManager-wait-online.enable = false;
}
