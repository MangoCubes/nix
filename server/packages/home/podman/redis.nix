{ config, ... }:
{
  custom.podman.containers.redis = {
    # UID: 999
    image = "docker.io/library/redis:alpine";
    disk.persistOnly = [ "redis" ];
    volumes = [
      "${config.home.homeDirectory}/.podman/redis:/data"
    ];
  };
}
