{ secrets, ... }:
{
  imports = [
    secrets.networks.wifi
  ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # Port for letting desktops to connect to me
      8770
    ];
    allowedUDPPorts = [
      # Port for letting desktops to connect to me
      5353
    ];
  };
}
