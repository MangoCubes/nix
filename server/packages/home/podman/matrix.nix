{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.secrets.server-main.home.matrix
  ];
  custom.podman.containers = {
    # UID: 991
    element = {
      dependsOn = [ "traefik" ];
      image = "vectorim/element-web";
      environment = {
        ELEMENT_WEB_PORT = "8080";
      };
      domain = [
        {
          url = "chat.skew.ch";
          port = 8080;
        }
      ];
    };
    matrix-hookshot = {
      dependsOn = [ "matrix" ];
      image = "halfshot/matrix-hookshot:latest";
      domain = [
        {
          rule = "Host(`matrix.skew.ch`) && PathPrefix(`/webhook`)";
          certResolver = "letsencrypt";
          port = 9000;
        }
      ];
      volumes = [
        "${config.home.homeDirectory}/.podman/matrix-hookshot:/data"
      ];
    };
    mas = {
      dependsOn = [ "traefik" ];
      image = "ghcr.io/element-hq/matrix-authentication-service:latest";
      domain = [
        {
          url = "auth.skew.ch";
          port = 8080;
        }
        {
          rule = "Host(`matrix.skew.ch`) && (PathRegexp(`^/_matrix/client/([^/]+)/(login|logout|refresh)`) || PathPrefix(`/oauth2`))";
          certResolver = "letsencrypt";
          port = 8080;
        }
      ];
      volumes = [
        "${config.home.homeDirectory}/.podman/matrix/mas.yaml:/config.yaml"
      ];
    };
    matrix = {
      dependsOn = [ "traefik" ];
      image = "ghcr.io/element-hq/synapse";
      volumes = [
        "${config.home.homeDirectory}/.podman/matrix:/data"
      ];
      environment = {
        "SYNAPSE_CONFIG_PATH" = "/data/homeserver.yaml";
      };
      domain = [
        {
          url = "matrix.skew.ch";
          port = 8008;
        }
        {
          rule = "Host(`skew.ch`) && PathPrefix(`/_synapse`)";
          certResolver = "letsencrypt";
          port = 8008;
        }
      ];
    };
  };
  custom.web.".well-known/matrix/client/" = {
    content = "${./matrix/well-known}";
    type = "application/json";
    headers = {
      Access-Control-Allow-Origin = "*";
    };
    index = "well-known.json";
  };
  home.activation.matrix =
    lib.hm.dag.entryAfter
      [
        "podmanQuadletCleanup"
        "sops-nix"
        "writeBoundary"
      ]
      (
        builtins.replaceStrings
          [ "@rootlesskit@" "@hookshotConfig@" ]
          [ "${pkgs.rootlesskit}/bin/rootlesskit" "${./matrix/hookshot.yaml}" ]
          (builtins.readFile ./matrix/activation.sh)
      );
}
