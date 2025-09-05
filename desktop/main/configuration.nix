{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.main
    # inputs.secrets.networks.wg-mitm
    ./boot.nix
    ./home.nix
    ../packages/mikuboot.nix
    ../base/configuration.nix
    (import ../packages/android.nix { androidStudio = true; })
    ../../common/packages/rclone-mega.nix
    ../packages/waydroid.nix
    # ../packages/steam.nix
    ../packages/wireshark.nix
    ../packages/tablet.nix
    ../packages/nvidia.nix
    ./networking.nix
  ];
}
