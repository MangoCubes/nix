{
  networking.firewall = {
    checkReversePath = "loose";
  };
  # Run the following two commands:
  #
  # sudo resolvectl dns nb-personal 127.0.0.153
  # sudo resolvectl domain nb-personal local int
  # sudo resolvectl dns <Default device> local int
  #
  # If `resolvectl` does not look like this:
  # Link 3 (nb-personal)
  #     Current Scopes: DNS
  #          Protocols: +DefaultRoute -LLMNR +mDNS -DNSOverTLS DNSSEC=no/unsupported
  # Current DNS Server: 127.0.0.153
  #        DNS Servers: 127.0.0.153
  #         DNS Domain: local int
  #      Default Route: yes
  services.resolved.enable = true;
  systemd.network.networks.nb-personal = {
    enable = true;
    dns = "127.0.0.153";
    domains = [
      "local"
      "int"
    ];
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
