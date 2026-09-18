{ config, ... }:
{
  custom.podman.containers.phpmyadmin = {
    dependsOn = [
      "traefik"
      "mariadb"
    ];
    image = "lscr.io/linuxserver/phpmyadmin";
    volumes = [
      "${config.home.homeDirectory}/.podman/volumes/phpmyadmin:/config"
    ];
    environment = {
      "PUID" = "1000";
      "PGID" = "1000";
      "PMA_HOST" = "mariadb";
      "PMA_ABSOLUTE_URI" = "https://db.int";
    };
    domain = [
      {
        routerName = "pma";
        url = "db.int";
        port = 80;
      }
    ];
  };
}
