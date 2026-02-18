{ username, ... }:
{
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 3478 ];
  };

  home-manager.users."${username}" =

    {
      config,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.secrets.server-network.home.netbird
        ((import ../../../lib/podman.nix) {
          dependsOn = [ "traefik" ];
          image = "netbirdio/netbird-server:latest";
          name = "netbird-server";
          ports = [ "3478:3478/udp" ];
          volumes = [
            "netbird_data:/var/lib/netbird"
            "${config.home.homeDirectory}/.config/sops-nix/secrets/netbird/config.yaml:/etc/netbird/config.yaml"
          ];
          entrypoint = "/go/bin/netbird-server --config /etc/netbird/config.yaml";
          labels = {
            "traefik.enable" = "true";

            "traefik.http.routers.netbird-grpc.priority" = "1000";
            "traefik.http.routers.netbird-grpc.rule" =
              "\"Host(`vpn.skew.ch`) && (PathPrefix(`/signalexchange.SignalExchange/`) || PathPrefix(`/management.ManagementService/`))\"";
            "traefik.http.routers.netbird-grpc.entrypoints" = "websecure";
            "traefik.http.routers.netbird-grpc.tls" = "true";
            "traefik.http.routers.netbird-grpc.tls.certResolver" = "letsencrypt";
            "traefik.http.routers.netbird-grpc.service" = "netbird-server-h2c";

            "traefik.http.services.netbird-server-h2c.loadbalancer.server.port" = "80";
            "traefik.http.services.netbird-server-h2c.loadbalancer.server.scheme" = "h2c";

            "traefik.http.routers.netbird-backend.priority" = "1000";
            "traefik.http.routers.netbird-backend.rule" =
              "\"Host(`vpn.skew.ch`) && (PathPrefix(`/relay`) || PathPrefix(`/ws-proxy/`) || PathPrefix(`/api`) || PathPrefix(`/oauth2`))\"";
            "traefik.http.routers.netbird-backend.entrypoints" = "websecure";
            "traefik.http.routers.netbird-backend.tls" = "true";
            "traefik.http.routers.netbird-backend.tls.certResolver" = "letsencrypt";
            "traefik.http.routers.netbird-backend.service" = "netbird-server";

            "traefik.http.services.netbird-server.loadbalancer.server.port" = "80";
          };
        })
        ((import ../../../lib/podman.nix) {
          dependsOn = [ "traefik" ];
          image = "netbirdio/dashboard:latest";
          name = "netbird-dashboard";
          environmentFile = [ "${config.home.homeDirectory}/.config/sops-nix/secrets/netbird/env.conf" ];
          domain = [
            {
              routerName = "netbird-dashboard";
              type = 1;
              url = "vpn.skew.ch";
              port = 80;
            }
          ];
        })
      ];
    };
}
