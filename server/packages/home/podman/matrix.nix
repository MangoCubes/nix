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
          rule =
            "Host(`matrix.skew.ch`) && (PathRegexp(`^/_matrix/client/([^/]+)/(login|logout|refresh)`) || PathPrefix(`/oauth2`))";
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
      ''
        DIR=${config.home.homeDirectory}/.podman/matrix
        if [ ! -d "$DIR" ]; then
          ${pkgs.rootlesskit}/bin/rootlesskit mkdir -p $DIR/uploads
          ${pkgs.rootlesskit}/bin/rootlesskit mkdir -p $DIR/media
        fi
        ${pkgs.rootlesskit}/bin/rootlesskit rm -f ${config.home.homeDirectory}/.podman/matrix/homeserver.yaml
        ${pkgs.rootlesskit}/bin/rootlesskit cp ${config.home.homeDirectory}/.config/sops-nix/secrets/matrix/homeserver.yaml ${config.home.homeDirectory}/.podman/matrix/homeserver.yaml
        ${pkgs.rootlesskit}/bin/rootlesskit rm -f ${config.home.homeDirectory}/.podman/matrix/skew.ch.signing.key
        ${pkgs.rootlesskit}/bin/rootlesskit cp ${config.home.homeDirectory}/.config/sops-nix/secrets/matrix/skew.ch.signing.key ${config.home.homeDirectory}/.podman/matrix/skew.ch.signing.key
        ${pkgs.rootlesskit}/bin/rootlesskit rm -f ${config.home.homeDirectory}/.podman/matrix/skew.ch.log.config
        ${pkgs.rootlesskit}/bin/rootlesskit cp ${config.home.homeDirectory}/.config/sops-nix/secrets/matrix/skew.ch.log.config ${config.home.homeDirectory}/.podman/matrix/skew.ch.log.config

        ${pkgs.rootlesskit}/bin/rootlesskit rm -f ${config.home.homeDirectory}/.podman/matrix/mas.yaml
        ${pkgs.rootlesskit}/bin/rootlesskit cp ${config.home.homeDirectory}/.config/sops-nix/secrets/matrix/mas.yaml ${config.home.homeDirectory}/.podman/matrix/mas.yaml
        ${pkgs.rootlesskit}/bin/rootlesskit rm -f ${config.home.homeDirectory}/.podman/matrix/hookshot.yaml
        ${pkgs.rootlesskit}/bin/rootlesskit cp ${config.home.homeDirectory}/.config/sops-nix/secrets/matrix/hookshot.yaml ${config.home.homeDirectory}/.podman/matrix/hookshot.yaml
        ${pkgs.rootlesskit}/bin/rootlesskit rm -f ${config.home.homeDirectory}/.podman/matrix-hookshot/registration.yml
        ${pkgs.rootlesskit}/bin/rootlesskit cp ${config.home.homeDirectory}/.config/sops-nix/secrets/matrix/hookshot.yaml ${config.home.homeDirectory}/.podman/matrix-hookshot/registration.yml
        ${pkgs.rootlesskit}/bin/rootlesskit rm -f ${config.home.homeDirectory}/.podman/matrix-hookshot/config.yml
        ${pkgs.rootlesskit}/bin/rootlesskit cp ${./matrix/hookshot.yaml} ${config.home.homeDirectory}/.podman/matrix-hookshot/config.yml

        ${pkgs.rootlesskit}/bin/rootlesskit chown 991:991 -R ${config.home.homeDirectory}/.podman/matrix
        ${pkgs.rootlesskit}/bin/rootlesskit chown 65532:65532 ${config.home.homeDirectory}/.podman/matrix/mas.yaml
      '';
}
