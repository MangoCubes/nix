{ config, ... }:
{
  custom.podman.containers = [
    {
      dependsOn = [
        "traefik"
        "mariadb"
      ];
      image = "lscr.io/linuxserver/phpmyadmin";
      name = "phpmyadmin";
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
          type = "local";
          url = "db.int";
          port = 80;
        }
      ];
    }
  ];
}
