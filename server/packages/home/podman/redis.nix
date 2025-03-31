{ hostname, config, ... }: {
  services.podman.containers.redis = 
    ((import ../../../../lib/podman.nix) {
      inherit hostname;
      image = "docker.io/library/redis:alpine";
      name = "redis";
      volumes = [
        "${config.home.homeDirectory}/.podman/redis:/data"
      ];
    });
}
