{ config, lib, ... }:
{
  imports = [
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
        "${config.home.homeDirectory}/Sync/Secrets/matrix:/data"
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
  home.activation.matrix = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DIR=${config.home.homeDirectory}/.podman/matrix
    if [ ! -d "$DIR" ]; then
      mkdir -p $DIR/uploads
      mkdir -p $DIR/media
    fi
  '';
}
