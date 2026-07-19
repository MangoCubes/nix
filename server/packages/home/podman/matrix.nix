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
    # UID: 991
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "vectorim/element-web";
      name = "element";
      environment = {
        ELEMENT_WEB_PORT = "8080";
      };
      domain = [
        {
          routerName = "element";
          type = 1;
          url = "chat.skew.ch";
          port = 8080;
        }
      ];
    })
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "ghcr.io/element-hq/matrix-authentication-service:latest";
      name = "mas";
      labels = {
        "traefik.enable" = "true";

        "traefik.http.routers.mas-legacy.rule" =
          "Host(`matrix.skew.ch`) && (PathRegexp(`^/_matrix/client/([^/]+)/(login|logout|refresh)`) || PathPrefix(`/oauth2`))";
        "traefik.http.routers.mas-legacy.entrypoints" = "websecure";
        "traefik.http.routers.mas-legacy.tls" = "true";
        "traefik.http.routers.mas-legacy.tls.certResolver" = "letsencrypt";
        "traefik.http.routers.mas-legacy.service" = "s-mas";
      };
      volumes = [
        "${config.home.homeDirectory}/.podman/matrix/mas.yaml:/config.yaml"
      ];
      domain = [
        {
          routerName = "mas";
          type = 1;
          url = "auth.skew.ch";
          port = 8080;
        }
      ];
    })
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "ghcr.io/element-hq/synapse";
      name = "matrix";
      labels = {
        "traefik.http.routers.matrix-auth.rule" = "Host(`skew.ch`) && PathPrefix(`/_synapse`)";
        "traefik.http.routers.matrix-auth.entrypoints" = "websecure";
        "traefik.http.routers.matrix-auth.tls" = "true";
        "traefik.http.routers.matrix-auth.tls.certResolver" = "letsencrypt";
        "traefik.http.routers.matrix-auth.service" = "s-matrix";
      };
      volumes = [
        "${config.home.homeDirectory}/.podman/matrix:/data"
      ];
      environment = {
        "SYNAPSE_CONFIG_PATH" = "/data/homeserver.yaml";
      };
      domain = [
        {
          routerName = "matrix";
          type = 1;
          url = "matrix.skew.ch";
          port = 8008;
        }
      ];
    })
  ];
  custom.web.content.".well-known/matrix/client" = "${./matrix/well-known.json}";
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

        ${pkgs.rootlesskit}/bin/rootlesskit chown 991:991 -R ${config.home.homeDirectory}/.podman/matrix
        ${pkgs.rootlesskit}/bin/rootlesskit chown 65532:65532 ${config.home.homeDirectory}/.podman/matrix/mas.yaml
      '';
}
