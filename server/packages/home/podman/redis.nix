{ config, ... }:
{
  services.podman.containers.redis = (
    (import ../../../../lib/podman.nix) {
      image = "docker.io/library/redis:alpine";
      name = "redis";
      volumes = [
        "${config.home.homeDirectory}/.podman/redis:/data"
      ];
    }
  );
}
