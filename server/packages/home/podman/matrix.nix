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
      image = "matrixdotorg/synapse";
      name = "matrix";
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
        ${pkgs.rootlesskit}/bin/rootlesskit chown 991:991 -R ${config.home.homeDirectory}/.podman/matrix
      '';
}
