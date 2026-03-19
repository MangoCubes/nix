{ username, lib, ... }:
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = lib.mkForce 53;
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
          domain = [
            {
              routerName = "adguard";
              type = 2;
              url = "dns.local";
              port = 80;
            }
          ];
        })
      ];
    };
}
