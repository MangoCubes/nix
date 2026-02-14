{ username, ... }:
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.src_valid_mark" = 1;
  };

  home-manager.users."${username}" =
    {
      config,
      inputs,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.secrets.server-main.home.proton-exit
        ((import ../../../lib/podman.nix) ({
          dependsOn = [ "traefik" ];
          domain = null;
          network = [ "proxy" ];
          image = "lscr.io/linuxserver/wireguard:latest";
          name = "proton-exit";
          addCapabilities = [ "NET_ADMIN" ];
          devices = [ "/dev/net/tun:/dev/net/tun" ];
          environment = {
            "PUID" = "1000";
            "PGID" = "1000";
            "TZ" = "Etc/UTC";
            # "SERVERURL" = "wireguard.domain.com"; # optional
            "SERVERPORT" = "51825"; # optional
            # "PEERS" = "1"; # optional
            # "PEERDNS" = "auto"; # optional
            # "INTERNAL_SUBNET" = "10.13.13.0"; # optional
            # "ALLOWEDIPS" = "0.0.0.0/0"; # optional
            # "PERSISTENTKEEPALIVE_PEERS" = ""; # optional
            # "LOG_CONFS" = "true"; # optional
          };
          # // (
          #   if useInternalDns then
          #     {
          #       "DNS_KEEP_NAMESERVER" = "on";
          #     }
          #   else
          #     { }
          # );
          volumes = [
            "${config.home.homeDirectory}/.config/sops-nix/secrets/wireguard/exit.conf:/config/wg0.conf"
          ];
          ports = [ "51825:51825/udp" ];
        }))
      ];
    };
}
