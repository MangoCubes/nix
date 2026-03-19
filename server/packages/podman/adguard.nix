{ username, lib, ... }:
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = lib.mkForce 53;
  };
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 53 ];
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
          ports = [ "53:53/udp" ];

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
