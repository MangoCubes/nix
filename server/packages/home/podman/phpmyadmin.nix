{ config, ... }:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
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
        "PMA_ABSOLUTE_URI" = "https://pma.local";
      };
      domain = [
        {
          routerName = "pma";
          type = 2;
          url = "pma.local";
          port = 80;
        }
      ];
    })
  ];
}
