{ inputs, ... }:
{
  imports = [
    inputs.secrets.desktop.main
    # inputs.secrets.networks.wg-mitm
    ./boot.nix
    ./home.nix
    ./security.nix
    ../packages/wireshark.nix
    ../packages/nvidia.nix
    ../packages/sunshine.nix
    ../packages/games.nix
    ./networking.nix
  ];
  custom = {
    android = {
      androidStudio = true;
      enable = true;
    };
    tablet.enable = true;
    device = {
      type = "desktop";
      keyboard = "/dev/input/by-id/usb-GIGABYTE_USB-HID_Keyboard_AP0000000003-event-kbd";
      monitors = [
        {
          x = 1920;
          y = 1080;
        }
      ];
    };
  };
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandlePowerKey = "poweroff";
  };
}
