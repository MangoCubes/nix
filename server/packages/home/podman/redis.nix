{ config, ... }:
{
  custom.podman.containers.redis = {
    # UID: 999
    dependsOn = null;
    image = "docker.io/library/redis:alpine";
    volumes = [
      "${config.home.homeDirectory}/.podman/redis:/data"
    ];
  };
}
