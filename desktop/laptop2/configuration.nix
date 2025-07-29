{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.laptop2
    ../base/configuration.nix
    ../packages/mitmproxy-wifi.nix
    ./boot.nix
    ./home.nix
    ./networking.nix
    (import ../packages/android.nix { androidStudio = false; })
    ../packages/wireshark.nix
    ../packages/saleae.nix
  ];
  services.logind = {
    lidSwitch = "suspend";
    extraConfig = ''
      # don’t shutdown when power button is short-pressed
      HandlePowerKey=ignore
    '';
  };
  services.logrotate.checkConfig = false;
  system.stateVersion = "24.11";
}
