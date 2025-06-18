{ inputs, ... }:
{
  services.printing.enable = true;
  imports = [
    inputs.secrets.hw.work
    ./boot.nix
    ./home.nix
    # ./mounts.nix
    ../packages/wireshark.nix
    ../packages/waydroid.nix
    (import ../packages/android.nix { androidStudio = true; })
  ];
}
