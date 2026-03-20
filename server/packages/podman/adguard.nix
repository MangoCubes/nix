{ username, ... }:
{
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 3553 ];
  };
  home-manager.users."${username}" =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [
        ((import ../../../lib/podman.nix) {
          dependsOn = null;
          image = "adguard/adguardhome";
          name = "adguard";
          needRoot = true;
          volumes = [
            "${config.home.homeDirectory}/.podman/adguard:/opt/adguardhome/conf"
            "dns:/opt/adguardhome/work"
          ];
          ip4 = config.custom.podman.dnsProvider;
          # This needs to be specified, otherwise podman's internal DNS stops working.
          ports = [ "3553:3553/udp" ];

          domain = [
            {
              routerName = "adguard";
              type = 1;
              url = "dns.skew.ch";
              port = 80;
            }
          ];
        })
      ];
    };
}
