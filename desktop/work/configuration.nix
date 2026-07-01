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
    allowedTCPPorts = [
      # Port for letting desktops to connect to me
      34669
      45371
    ];
    allowedUDPPorts = [
      # Port for letting desktops to connect to me
      5353
    ];
  };
}
