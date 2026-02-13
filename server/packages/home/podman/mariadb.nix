{
  config,
  inputs,
  ...
}:
{
  # UID: 999
  imports = [
    inputs.secrets.hm.other
    ((import ../../../../lib/podman.nix) {
      daily = "podman exec -it mariadb mariadb-dump --user=root --password=$MYSQL_ROOT_PASSWORD --lock-tables --all-databases > ${config.home.homeDirectory}/.podman/shared/backups/mariadb.sql";
      dependsOn = null;
      image = "mariadb:lts";
      name = "mariadb";
      volumes = [
        "${config.home.homeDirectory}/.podman/mariadb:/var/lib/mysql"
        "${config.home.homeDirectory}/.podman/shared/backups/mariadb:/var/lib/backups"
      ];
      ports = [
        "3306:3306"
      ];
      environmentFile = [ "${config.home.homeDirectory}/.config/sops-nix/secrets/mariadb" ];
    })
  ];
}
