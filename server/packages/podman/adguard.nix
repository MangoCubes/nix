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
      home.activation.adguard = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ${config.home.homeDirectory}/.podman/adguard
      '';
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
          # This needs to be specified, otherwise podman's internal DNS stops working.
          ports = [ "100.64.0.3:53:53/udp" ];
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
