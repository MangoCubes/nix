{ inputs, ... }:
{
  services.printing.enable = true;
  imports = [
    inputs.secrets.hw.work
    # ../packages/mitmproxy-wifi.nix
    ./boot.nix
    ./home.nix
    # ../packages/rclone-school.nix
    ../packages/wireshark.nix
    ../base/configuration.nix
    (import ../packages/android.nix {
      androidStudio = false;
      heimdall = false;
    })
  ];
}
