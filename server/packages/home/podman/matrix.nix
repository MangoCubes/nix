{ config, lib, ... }:
{
  services.podman.containers.element = (
    (import ../../../../lib/podman.nix) {
      hostname = "element";
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
    }
  );
  home.activation.matrix = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DIR=${config.home.homeDirectory}/.podman/matrix
    if [ ! -d "$DIR" ]; then
      mkdir -p $DIR/uploads
      mkdir -p $DIR/media
    fi
  '';
  services.podman.containers.matrix = (
    (import ../../../../lib/podman.nix) {
      hostname = "matrix";
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
    }
  );
}
