{
  dynamic ? { },
  static ? { },
  pkgs,
  username,
  lib,
}:
let
  dynamicFile = (pkgs.formats.yaml { }).generate "config.yml" (
    lib.attrsets.recursiveUpdate {
      http = {
        serversTransports = {
          internalTransport.rootCAs = [ "/etc/traefik/ssl/cert.crt" ];
        };
        middlewares = {
          m-ip.ipAllowList.sourceRange = [ "100.64.0.0/16" ];
          m-redir.redirectscheme.scheme = "https";
        };
      };
    } dynamic
  );
in
let
  staticFile =
    { config }:
    (pkgs.formats.yaml { }).generate "traefik.yaml" (
      lib.attrsets.recursiveUpdate {
        # TODO: Fix this
        serversTransport.insecureSkipVerify = true;
        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entrypoint = {
              to = "websecure";
              scheme = "https";
              permanent = true;
            };
          };
          websecure.address = ":443";
        };

        certificatesResolvers.localca.acme = {
          caServer = "https://ca.local/acme/intranet/directory";
          email = "traefik@mail.local";
          tlsChallenge = true;
          storage = "/etc/traefik/ssl/local.json";
        };

        log.level = "ERROR";

        api.dashboard = true;
        api.insecure = false;
        accessLog.format = "common";
        providers = {
          docker.endpoint = "unix:///run/user/1000/podman/podman.sock";
          file = {
            filename = "/etc/traefik/config.yaml";
            watch = false;
          };
        };
      } static
    );
in
{
  # Ensure port is being listened using lsof -i :80
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 80;
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
  };
  home-manager.users."${username}" =
    { config, ... }:
    {
      services.podman = {
        containers.traefik = {
          image = "traefik";
          ports = [
            "80:80"
            "443:443"
          ];
          # autoStart = true;
          network = "proxy";
          volumes = [
            "${staticFile { inherit config; }}:/etc/traefik/traefik.yaml"
            "${dynamicFile}:/etc/traefik/config.yaml"
            "traefik:/etc/traefik/ssl"
            "/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt"
            "${../../../secrets/res/keys/root.crt}:/etc/ssl/certs/home.crt"
            "/run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock"
          ];
          labels = {
            "traefik.enable" = "true";
            # "traefik.http.routers.dashboard.rule" = "Host(\\`proxy.local\\`)";
            # "traefik.http.routers.dashboard.entrypoints" = "websecure";
            # "traefik.http.routers.dashboard.service" = "api@internal";
            # "traefik.http.routers.dashboard.tls" = "true";
            # "traefik.http.routers.dashboard.middlewares" = "m-ip@file";
          };
        };
        networks.proxy = {
          autoStart = true;
          subnet = "10.10.0.0/24";
        };
      };
    };
}
