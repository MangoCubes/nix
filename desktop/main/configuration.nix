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
    (import ../packages/android.nix { androidStudio = true; })
    ../packages/virtualbox.nix
    ../packages/wireshark.nix
    ../packages/tablet.nix
    ../packages/nvidia.nix
    ./networking.nix
  ];
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandlePowerKey = "poweroff";
  };
}
