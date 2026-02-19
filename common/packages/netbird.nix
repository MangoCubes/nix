{ inputs, hostname, ... }:
{
  # environment.sessionVariables = {
  #   QT_QPA_PLATFORM = "wayland";
  # };
  imports = [
    (inputs.secrets.networks.netbird { inherit hostname; })
  ];
  services.netbird = {
    clients = {
      personal = {
        login = {
          enable = true;
          setupKeyFile = "/run/secrets/netbird";
        };
        ui.enable = true;
        port = 51820;
        environment = {
          NB_CONFIG = "/var/lib/netbird-personal/config.json";
          NB_MANAGEMENT_URL = "https://vpn.skew.ch";
          NB_ADMIN_URL = "https://vpn.skew.ch";
        };
      };
    };
  };
}
