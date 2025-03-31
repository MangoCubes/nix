{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.laptop
    ./boot.nix
    ./home.nix
    ../packages/wireshark.nix
    ../../common/packages/rclone.nix
  ];
  services.logind.lidSwitch = "suspend";
}
