{ inputs, ... }:
{
  imports = [
    inputs.secrets.desktop.main
    # inputs.secrets.networks.wg-mitm
    ./boot.nix
    ./home.nix
    ./security.nix
    # ../packages/mikuboot.nix
    ../base/configuration.nix
    ../packages/virtualbox.nix
    ../packages/wireshark.nix
    ../packages/tablet.nix
    ../packages/nvidia.nix
    ./networking.nix
  ];
  custom.android = {
    enable = true;
    androidStudio = true;
  };
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandlePowerKey = "poweroff";
  };
}
