{ config, ... }:
{
  custom.podman.containers.redis = {
    # UID: 999
    image = "docker.io/library/redis:alpine";
    volumes = [
      "${config.home.homeDirectory}/.podman/redis:/data"
    ];
  };
}
