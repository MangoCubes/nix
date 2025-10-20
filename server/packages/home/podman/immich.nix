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
    ((import ../../../../lib/postgresql.nix) {
      image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
      secretEnvPath = ''${config.home.homeDirectory}/.config/sops-nix/secrets/immich'';
      name = "immich";
      inherit config;
    })
  ];
}
