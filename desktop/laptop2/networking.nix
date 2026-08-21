{ inputs, ... }:
{
  imports = [
    inputs.secrets.networks.wifi
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
