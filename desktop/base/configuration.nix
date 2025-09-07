# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  imports = [
    ./environment.nix
    ./home.nix
    ./networking.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./boot.nix
    ../packages/kmonad.nix
    ../packages/bluetooth.nix
    ../packages/fonts.nix
    ../packages/greetd.nix
    ../packages/kdeconnect.nix
    ../packages/traefik.nix
    ../packages/swaylock.nix
    ../packages/ydotool.nix
  ];
  powerManagement.enable = true;
  programs.nix-ld.enable = true;
  boot.kernelParams = [ "mem_sleep_default=s2idle" ];
  systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
    #   AllowHybridSleep=no
    #   AllowSuspendThenHibernate=no
  '';
  systemd.services.NetworkManager-wait-online.enable = false;
}
