{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.laptop2
    ./boot.nix
    ./home.nix
    (import ../packages/android.nix { androidStudio = false; })
    ../packages/wireshark.nix
  ];
  services.logind.lidSwitch = "suspend";
  services.logrotate.checkConfig = false;
  system.stateVersion = "24.11";
}
