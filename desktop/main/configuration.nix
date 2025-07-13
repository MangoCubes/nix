{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.main
    ./boot.nix
    ./home.nix
    (import ../packages/android.nix { androidStudio = true; })
    ../../common/packages/rclone-mega.nix
    ../packages/steam.nix
    ../packages/wireshark.nix
    ../packages/tablet.nix
    ../packages/nvidia.nix
  ];
}
