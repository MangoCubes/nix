{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.secrets.hm.other ];
  home.activation.mariadb = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DIR=${config.home.homeDirectory}/.podman/mariadb
    if [ ! -d "$DIR" ]; then
      mkdir -p $DIR
    fi
  '';

  services.podman.containers.mariadb = (
    (import ../../../../lib/podman.nix) {
      image = "mariadb:lts";
      name = "mariadb";
      volumes = [
        "${config.home.homeDirectory}/.podman/mariadb:/var/lib/mysql"
      ];
      domain = [
        {
          routerName = "db";
          type = 2;
          url = "local";
          port = 3306;
        }
      ];
      environmentFile = [ ''${config.home.homeDirectory}/.config/sops-nix/secrets/mariadb'' ];
    }
  );
}
