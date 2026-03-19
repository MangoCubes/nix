{
  networking.firewall = {
    checkReversePath = "loose";
  };
  # Run sr netbird-personal-login to initialise
  services.resolved = {
    enable = true;
    domains = [ "local" ];
    llmnr = "false";
    extraConfig = "DNSStubListener=no";
  };
  services.netbird = {
    clients = {
      personal = {
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
