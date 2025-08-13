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
        "${config.home.homeDirectory}/.podman/matrix/homeserver.yaml:/data/homeserver.yaml"
        "${config.home.homeDirectory}/.podman/matrix/skew.ch.signing.key:/data/skew.ch.signing.key"
        "${config.home.homeDirectory}/.podman/matrix/uploads:/data/uploads"
        "${config.home.homeDirectory}/.podman/matrix/media:/data/media"
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
          mkdir -p $DIR/uploads
          mkdir -p $DIR/media
        fi
        rm -f ${config.home.homeDirectory}/.podman/matrix/homeserver.yaml
        cp ${config.home.homeDirectory}/.config/sops-nix/secrets/matrix/homeserver.yaml ${config.home.homeDirectory}/.podman/matrix/homeserver.yaml
        rm -f ${config.home.homeDirectory}/.podman/matrix/skew.ch.signing.key
        cp ${config.home.homeDirectory}/.config/sops-nix/secrets/matrix/skew.ch.signing.key ${config.home.homeDirectory}/.podman/matrix/skew.ch.signing.key
        ${pkgs.rootlesskit}/bin/rootlesskit chown 1000:1000 ${config.home.homeDirectory}/.podman/matrix/homeserver.yaml
        ${pkgs.rootlesskit}/bin/rootlesskit chown 1000:1000 ${config.home.homeDirectory}/.podman/matrix/skew.ch.signing.key
      '';
}
