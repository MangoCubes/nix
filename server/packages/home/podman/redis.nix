{ config, ... }:
{
  custom.podman.containers = [
    # UID: 999
    {
      dependsOn = null;
      image = "docker.io/library/redis:alpine";
      name = "redis";
      volumes = [
        "${config.home.homeDirectory}/.podman/redis:/data"
      ];
    }
  ];
}
