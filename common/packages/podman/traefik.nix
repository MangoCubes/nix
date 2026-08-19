{
  dynamic ? { },
  static ? { },
  pkgs,
  username,
  lib,
  inputs,
  hostname,
  ...
}:
let
  dynamicFile = (pkgs.formats.yaml { }).generate "config.yml" (
    lib.attrsets.recursiveUpdate {
      http = {
        # routers.syncthing = {
        #   rule = "Host(`sync.${hostname}.local`)";
        #   service = "s-syncthing";
        #   # middlewares = [ "m-ip" ];
        #   entryPoints = [ "websecure" ];
        #   tls.certResolver = "localca";
        # };
        # services.s-syncthing.loadBalancer = {
        #   servers = [
        #     { url = "http://host.containers.internal:8384"; }
        #   ];
        # };
        serversTransports = {
          internalTransport.rootCAs = [ "/etc/traefik/ssl/cert.crt" ];
        };
        middlewares = {
          m-ip.ipAllowList.sourceRange = [ "100.64.0.0/10" ];
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
        # TODO: Fix "cannot validate certificate for 10.10.0.14 because it doesn't contain any IP SAN"
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
          websecure = {
            address = ":443";
          };
        };

        certificatesResolvers.localca.acme = {
          caServer = "https://ca.int/acme/intranet/directory";
          email = "traefik@mail.int";
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
          network = [ "proxy" ];
          image = "traefik";
          ports = [
            "80:80"
            "443:443"
          ];
          autoStart = true;
          volumes = [
            "${staticFile { inherit config; }}:/etc/traefik/traefik.yaml"
            "${dynamicFile}:/etc/traefik/config.yaml"
            "traefik:/etc/traefik/ssl"
            "/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt"
            "${inputs.secrets.res}/keys/root.crt:/etc/ssl/certs/home.crt"
            "/run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock"
          ];
          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.traefik-dashboard.rule" = "Host(`proxy.${hostname}.local`)";
            "traefik.http.routers.traefik-dashboard.entrypoints" = "websecure";
            "traefik.http.routers.traefik-dashboard.service" = "api@internal";
            "traefik.http.routers.traefik-dashboard.tls" = "true";
            "traefik.http.routers.traefik-dashboard.tls.certResolver" = "localca";

            # "traefik.http.routers.dashboard.middlewares" = "m-ip@file";
          };
        };
        networks.proxy = {
          autoStart = true;
          subnet = config.custom.podman.subnet;
        };
      };
    };
}
