{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.secrets.server-main.home.immich
    ((import ../../../../lib/postgresql.nix) {
      image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
      secretEnvPath = config.sops.secrets.immich.path;
      name = "immich";
      inherit config;
    })
  ];
  custom.podman.containers.immich = {
    disk.persistBackup = [
      "immich/data"
      "immich/backups"
    ];
    dependsOn = [
      "redis"
      "postgresql-immich"
    ];
    image = "ghcr.io/immich-app/immich-server:release";
    volumes = [
      "${config.home.homeDirectory}/.podman/immich/data:/data"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environmentFile = [ config.sops.secrets.immich.path ];
    domain = [
      {
        url = "pics.skew.ch";
        port = 2283;
      }
    ];
  };
}
