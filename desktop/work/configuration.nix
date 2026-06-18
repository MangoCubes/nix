{ inputs, ... }:
{
  services.printing.enable = true;
  imports = [
    inputs.secrets.hw.work
    ./boot.nix
    ./home.nix
    ../packages/wireshark.nix
    ../base/configuration.nix
    (import ../packages/android.nix {
      androidStudio = false;
      heimdall = false;
    })
  ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8080 ];
  };
}
