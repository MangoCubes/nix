{
  networking.firewall = {
    checkReversePath = "loose";
  };
  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDNS = [ "1.1.1.1#cloudflare-dns.com" ];
  };
  # Needed for netbird to set DNS
  security.polkit.enable = true;
  services.netbird = {
    clients = {
      personal = {
        port = 51830;
        dns-resolver = {
          port = 53;
          address = "127.0.0.153";
        };
        openFirewall = true;

        environment = {
          NB_CONFIG = "/var/lib/netbird-personal/config.json";
          NB_MANAGEMENT_URL = "https://vpn.skew.ch";
          NB_ADMIN_URL = "https://vpn.skew.ch";
        };
      };
    };
  };
}
