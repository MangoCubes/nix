{
  config,
  ...
}:
{
  imports = [
    # UID: 33
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "ampache/ampache:latest";
      name = "ampache-test";
      domain = [
        {
          routerName = "ampache-test";
          url = "music.local";
          type = 2;
          port = 80;
        }
      ];
      volumes = [
        "${config.home.homeDirectory}/.podman/ampache-test/config:/var/www/config"
        "${config.home.homeDirectory}/.podman/ampache-test/media:/media"
        "${config.home.homeDirectory}/.podman/ampache-test/database:/var/lib/mysql"
      ];
    })
  ];
}
