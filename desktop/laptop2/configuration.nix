{ inputs, ... }:
{
  imports = [
    inputs.secrets.desktop.laptop2
    ./boot.nix
    ./home.nix
    ./networking.nix
    ../packages/avahi.nix
    ../packages/wireshark.nix
  ];
  custom.device = {
    type = "laptop";
    keyboard = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    monitors = [
      {
        x = 1920;
        y = 1200;
      }
    ];
  };
  custom.android.enable = true;
  custom.hibernation.enable = true;
  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
  };
  services.logrotate.checkConfig = false;
  system.stateVersion = "24.11";
}
