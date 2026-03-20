{
  networking.firewall = {
    checkReversePath = "loose";
  };
  # Run resolvectl default-route nb-personal true if necessary
  services.resolved = {
    enable = true;
    domains = [
      "local"
      "int"
    ];
    fallbackDns = [
      "107.175.189.176"
      "1.1.1.1"
    ];
    llmnr = "false";
  };
  services.netbird = {
    clients = {
      personal = {
        port = 51830;
        dns-resolver = {
          port = 53;
          address = "127.0.0.153";
        };
        environment = {
          NB_CONFIG = "/var/lib/netbird-personal/config.json";
          NB_MANAGEMENT_URL = "https://vpn.skew.ch";
          NB_ADMIN_URL = "https://vpn.skew.ch";
        };
      };
    };
  };
}
