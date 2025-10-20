{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.secrets.server-main.home.immich
    ((import ../../../../lib/podman.nix) {
      activation = ''
        mkdir -p ${config.home.homeDirectory}/.podman/immich/data
      '';
      dependsOn = [
        "traefik"
        "redis"
        "postgresql"
      ];
      image = "ghcr.io/immich-app/immich-server:release";
      name = "immich";
      volumes = [
        "${config.home.homeDirectory}/.podman/immich/data:/data"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environmentFile = [ ''${config.home.homeDirectory}/.config/sops-nix/secrets/immich'' ];
      domain = [
        {
          routerName = "immich";
          type = 1;
          url = "pics.skew.ch";
          port = 2283;
        }
      ];
    })
  ];
}
