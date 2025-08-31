{
  config,
  ...
}:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "ampache/ampache:nosql";
      name = "ampache";
      domain = [
        {
          routerName = "ampache";
          url = "music.skew.ch";
          type = 1;
          port = 80;
        }
      ];
      volumes = [
        #  "${config.home.homeDirectory}/.config/sops-nix/secrets/ampache:/var/www/config/ampache.cfg.php"
        "${config.home.homeDirectory}/.podman/ampache:/var/www/config"
        "${config.home.homeDirectory}/Mounts/media/Library/Music:/media"
      ];
    })
  ];
}
