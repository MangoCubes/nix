{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.laptop
    ./boot.nix
    ./home.nix
    ../packages/wireshark.nix
    ../../common/packages/rclone-mega.nix
  ];
  services.logind.lidSwitch = "suspend";
}
