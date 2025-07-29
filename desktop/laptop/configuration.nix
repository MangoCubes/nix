{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.laptop
    ./boot.nix
    ./home.nix
    ../packages/wireshark.nix
    ../../common/packages/rclone-mega.nix
    ../packages/sunshine.nix
    ../base/configuration.nix
    (import ../packages/android.nix {
      androidStudio = false;
      heimdall = false;
    })
  ];
  services.logind.lidSwitch = "suspend";
}
