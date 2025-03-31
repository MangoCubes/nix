{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.main
    ./boot.nix
    ./home.nix
    (import ../packages/android.nix { androidStudio = true; })
    ../../common/packages/rclone.nix
  ];
  hardware.opentabletdriver.enable = true;
}
