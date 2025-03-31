{ hostname, ... }:
{
  services.podman.containers.phpmyadmin = (
    (import ../../../../lib/podman.nix) {
      inherit hostname;
      image = "lscr.io/linuxserver/phpmyadmin";
      name = "phpmyadmin";
      volumes = [
        "pma:/config"
      ];
      environment = {
        "PUID" = "1000";
        "PGID" = "1000";
        "PMA_HOST" = "mariadb";
        "PMA_ABSOLUTE_URI" = "https://db.local";
      };
      domain = [
        {
          routerName = "phpmyadmin";
          type = 2;
          url = "db.local";
          port = 80;
        }
      ];
    }
  );
}
