{
  username,
  pkgs,
  inputs,
  ...
}:
# podman exec vpn headscale nodes register --user main --key mkey:<KEY>
let
  policy = ./headscale/policy.json;
  config = (
    (pkgs.formats.yaml { }).generate "config.yml" ((import ./headscale/config.nix) { inherit inputs; })
  );
in
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
  };
  home-manager.users."${username}" = {
    # List all targets using systemctl list-units --type target
    services.podman.containers.vpn = {
      image = "headscale/headscale";
      autoStart = true;
      exec = "serve";
      network = "proxy";
      volumes = [
        "${config}:/etc/headscale/config.yaml"
        "${policy}:/etc/headscale/policy.json"
        "vpn:/var/lib/headscale"
      ];
      extraConfig.Quadlet.DefaultDependencies = false;
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.vpn.rule" = "Host(`newvpn.skew.ch`)";
        "traefik.http.routers.vpn.entrypoints" = "websecure";
        "traefik.http.routers.vpn.service" = "s-vpn";
        "traefik.http.services.s-vpn.loadbalancer.server.port" = "8080";
        "traefik.http.routers.vpn.tls" = "true";
      };
    };
  };
}
