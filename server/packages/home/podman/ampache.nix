{
  config,
  lib,
  ...
}:
{
  home.activation.ampache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/.podman/ampache
  '';
  # It doesn't work quite well because owner must be 100032
  #sops.secrets.ampache = {
  #  format = "binary";
  #  sopsFile = ./secrets/ampache.enc.php;
  #};

  services.podman.containers.ampache = (
    (import ../../../../lib/podman.nix) {
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
        "${config.home.homeDirectory}/Mount/media/Library/Music:/media"
      ];
    }
  );
}
