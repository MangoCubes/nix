{ inputs, ... }:
{
  services.printing.enable = true;
  imports = [
    inputs.secrets.hw.work
    ./boot.nix
    ./home.nix
    # ./mounts.nix
    ../packages/rclone-school.nix
    ../packages/wireshark.nix
    # ../packages/waydroid.nix
    (import ../packages/android.nix { androidStudio = false; })
  ];
}
