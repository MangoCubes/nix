{ config, ... }:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = null;
      image = "docker.io/library/redis:alpine";
      name = "redis";
      volumes = [
        "${config.home.homeDirectory}/.podman/redis:/data"
      ];
    })
  ];
}
