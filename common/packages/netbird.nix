{ inputs, hostname, ... }:
{
  imports = [
    (inputs.secrets.networks.netbird { inherit hostname; })
  ];
  networking.firewall = {
    checkReversePath = "loose";
  };
  services.resolved.enable = true;
  services.netbird = {
    clients = {
      personal = {
        login = {
          enable = true;
          setupKeyFile = "/run/secrets/netbird";
        };
        ui.enable = true;
        port = 51830;
        environment = {
          NB_CONFIG = "/var/lib/netbird-personal/config.json";
          NB_MANAGEMENT_URL = "https://vpn.skew.ch";
          NB_ADMIN_URL = "https://vpn.skew.ch";
        };
      };
    };
  };
}
