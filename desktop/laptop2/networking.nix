{ inputs, ... }:
{
  imports = [
    inputs.secrets.networks.wifi
  ];
  services.avahi = {
    enable = true;
  };
}
