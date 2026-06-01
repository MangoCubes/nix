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
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandlePowerKey = "ignore";
  };
  services.logrotate.checkConfig = false;
  system.stateVersion = "24.11";
}
