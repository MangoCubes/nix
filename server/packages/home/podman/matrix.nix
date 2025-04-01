{ config, ... }:
{
  services.podman.containers.element = (
    (import ../../../../lib/podman.nix) {
      hostname = "element";
      image = "vectorim/element-web";
      name = "element";
      domain = [
        {
          routerName = "element";
          type = 1;
          url = "chat.skew.ch";
          port = 80;
        }
      ];
    }
  );
  services.podman.containers.matrix = (
    (import ../../../../lib/podman.nix) {
      hostname = "matrix";
      image = "matrixdotorg/synapse";
      name = "matrix";
      volumes = [
        "${config.home.homeDirectory}/.podman/matrix:/var/lib/matrix"
      ];
      domain = [
        {
          routerName = "matrix";
          type = 1;
          url = "matrix.skew.ch";
          port = 8080;
        }
      ];
    }
  );
}
