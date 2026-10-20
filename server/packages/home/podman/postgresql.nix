{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.secrets.server.packages.home.podman.other ];
  custom.podman.containers.postgresql = {
    image = "postgres:17";
    disk = {
      persistOnly = [ "postgres/scripts" ];
      persistBackup = [ "postgres/data" ];
    };
    volumes = [
      "${config.home.homeDirectory}/.podman/postgres/data:/var/lib/postgresql/data"
      "${config.home.homeDirectory}/.podman/postgres/scripts:/var/lib/postgresql/scripts"
    ];
    environmentFile = [ config.sops.secrets.postgresql.path ];
  };
}
