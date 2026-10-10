{ inputs, ... }:
{
  imports = [
    inputs.secrets.desktop.laptop2
    ./boot.nix
    ./home.nix
    ./networking.nix
    ../packages/wireshark.nix
  ];
  custom.device = {
    type = "laptop";
    monitors = [
      {
        x = 1920;
        y = 1200;
      }
    ];
  };
  custom.android.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandlePowerKey = "ignore";
  };
  services.logrotate.checkConfig = false;
  system.stateVersion = "24.11";
}
