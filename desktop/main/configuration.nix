{ inputs, ... }:
{
  imports = [
    inputs.secrets.desktop.main
    # inputs.secrets.networks.wg-mitm
    ./boot.nix
    ./home.nix
    ./security.nix
    # ../packages/mikuboot.nix
    ../packages/wireshark.nix
    ../packages/nvidia.nix
    ./networking.nix
  ];
  custom = {
    android.enable = true;
    tablet.enable = true;
    device = {
      type = "desktop";
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
