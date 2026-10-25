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
    ./networking.nix
  ];
  custom = {
    android.enable = true;
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
