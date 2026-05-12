{ inputs, ... }:
{
  imports = [
    inputs.secrets.hw.laptop
    ./boot.nix
    ./home.nix
    ./networking.nix
    ../packages/wireshark.nix
    ../packages/sunshine.nix
    ../base/configuration.nix
    (import ../packages/android.nix {
      androidStudio = false;
      heimdall = false;
    })
  ];
  services.logind.lidSwitch = "suspend";
}
