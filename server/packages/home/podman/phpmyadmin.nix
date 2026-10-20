{
  custom.podman.containers.phpmyadmin = {
    dependsOn = [ "mariadb" ];
    image = "lscr.io/linuxserver/phpmyadmin";
    environment = {
      "PUID" = "1000";
      "PGID" = "1000";
      "PMA_HOST" = "mariadb";
      "PMA_ABSOLUTE_URI" = "https://db.int";
    };
    domain = [
      {
        url = "db.int";
        port = 80;
      }
    ];
  };
}
