{ username, ... }:
{
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 3553 ];
  };
  home-manager.users."${username}" =
    {
      config,
      ...
    }:
    {
      custom.podman.containers.adguard = {
        image = "adguard/adguardhome";
        needRoot = true;
        mounts = [
          {
            inside = "/opt/adguardhome/conf";
            outside = "adguard";
          }
        ];
        volumes = [ "/opt/adguardhome/work" ];
        ip4 = config.custom.podman.dnsProvider;
        # This needs to be specified, otherwise podman's internal DNS stops working.
        ports = [ "3553:3553/udp" ];

        domain = [
          {
            url = "dns.skew.ch";
            port = 80;
          }
        ];
      };
    };
}
