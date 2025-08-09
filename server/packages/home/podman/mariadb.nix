{
  lib,
  config,
  inputs,
  ...
}:
{
  home.activation.mariadb = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DIR=${config.home.homeDirectory}/.podman/mariadb
    if [ ! -d "$DIR" ]; then
      mkdir -p $DIR
    fi
  '';

  imports = [
    inputs.secrets.hm.other
    ((import ../../../../lib/podman.nix) {
      dependsOn = null;
      image = "mariadb:lts";
      name = "mariadb";
      volumes = [
        "${config.home.homeDirectory}/.podman/mariadb:/var/lib/mysql"
      ];
      ports = [
        "3306:3306"
      ];
      environmentFile = [ ''${config.home.homeDirectory}/.config/sops-nix/secrets/mariadb'' ];
    })
  ];
}
