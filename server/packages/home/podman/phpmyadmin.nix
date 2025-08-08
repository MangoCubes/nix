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
        "pma:/config"
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
