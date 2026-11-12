{
  config,
  inputs,
  ...
}:
{
  # UID: 999
  imports = [ inputs.secrets.server.packages.home.podman.other ];
  custom.podman.containers.mariadb = {
    daily = "podman exec -it mariadb mariadb-dump --user=root --password=$MYSQL_ROOT_PASSWORD --lock-tables --all-databases > ${config.home.homeDirectory}/.podman/shared/backups/mariadb.sql";
    image = "mariadb:lts";
    backup = [ "shared/backups/mariadb" ];
    mounts = [
      {
        inside = "/var/lib/mysql";
        outside = "mariadb";
      }
      {
        inside = "/var/lib/backups";
        outside = "shared/backups/mariadb";
      }
    ];
    ports = [
      "3306:3306"
    ];
    environmentFile = [ config.sops.secrets.mariadb.path ];
  };
}
