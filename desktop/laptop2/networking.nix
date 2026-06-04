{ inputs, ... }:
{
  imports = [
    inputs.secrets.networks.wifi
  ];
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      45919
    ];
  };
  services.avahi = {
    enable = true;
  };
}
