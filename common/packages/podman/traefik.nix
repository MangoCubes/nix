{
  pkgs,
  username,
  lib,
  inputs,
  config,
  ...
}:
let
  dynamicFile = (pkgs.formats.yaml { }).generate "config.yml" (
    lib.attrsets.recursiveUpdate {
      http = {
        serversTransports = {
          internalTransport.rootCAs = [ "/etc/traefik/ssl/cert.crt" ];
        };
        middlewares = {
          m-ip.ipAllowList.sourceRange = [ "100.64.0.0/10" ];
          m-redir.redirectscheme.scheme = "https";
        };
      };
    } config.custom.traefik.dynamic
  );
  staticFile = (pkgs.formats.yaml { }).generate "traefik.yaml" (
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

      certificatesResolvers.letsencrypt.acme = {
        email = "postmaster@skew.ch";
        storage = "/etc/traefik/ssl/letsencrypt.json";
        httpChallenge.entryPoint = "web";
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
    } config.custom.traefik.static
  );
in
{
  options.custom.traefik = {
    enable = lib.mkEnableOption "Traefik reverse proxy";
    dynamic = lib.mkOption {
      type = (pkgs.formats.yaml { }).type;
      default = { };
    };
    static = lib.mkOption {
      type = (pkgs.formats.yaml { }).type;
      default = { };
    };
  };

  config = lib.mkIf config.custom.traefik.enable {
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
      { config, osConfig, ... }:
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
              "${staticFile}:/etc/traefik/traefik.yaml"
              "${dynamicFile}:/etc/traefik/config.yaml"
              "traefik:/etc/traefik/ssl"
              "/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt"
              "${inputs.secrets.res}/keys/root.crt:/etc/ssl/certs/home.crt"
              "/run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock"
            ];
            labels = {
              "traefik.enable" = "true";
              "traefik.http.routers.traefik-dashboard.rule" =
                "Host(`proxy.${osConfig.networking.hostName}.local`)";
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
  };
}
