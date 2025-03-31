{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.laptop2
    ./boot.nix
    ./home.nix
    ../packages/wireshark.nix
  ];
  services.logind.lidSwitch = "suspend";
  services.logrotate.checkConfig = false;
  system.stateVersion = "24.11";
}
