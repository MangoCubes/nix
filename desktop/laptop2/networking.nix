{ inputs, ... }:
{
  imports = [
    inputs.secrets.networks.wifi
  ];
}
