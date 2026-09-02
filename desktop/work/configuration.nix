{ inputs, unfreeUnstable, ... }:
{
  virtualisation.vmware.host = {
    package = unfreeUnstable.vmware-workstation;
    enable = true;
  };
  services.printing.enable = true;
  imports = [
    inputs.secrets.hw.work
    ./boot.nix
    ./home.nix
    ../packages/avahi.nix
    ../packages/wireshark.nix
    ../packages/mitmproxy-wifi.nix
    ../../common/troubleshooting.nix
    (import ../packages/android.nix {
      androidStudio = false;
      heimdall = false;
    })
  ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # Port for letting desktops to connect to me
      # 34669
      # 45371
      8770
    ];
    allowedUDPPorts = [
      # Port for letting desktops to connect to me
      5353
    ];
  };
}
