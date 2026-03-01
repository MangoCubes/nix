{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.secrets.hm.other
    ((import ../../../../lib/podman.nix) {
      dependsOn = [
        "traefik"
        "postgresql"
      ];
      image = "dpage/pgadmin4";
      name = "pgadmin";
      # Change owner to 5050
      activation = ''
        ${pkgs.rootlesskit}/bin/rootlesskit chown 5050:5050 -R ${config.home.homeDirectory}/.podman/pgadmin
      '';
      volumes = [
        "${config.home.homeDirectory}/.podman/pgadmin:/var/lib/pgadmin"
      ];
      domain = [
        {
          routerName = "pgadmin";
          type = 2;
          url = "pg.local";
          port = 5050;
        }
      ];
      environmentFile = [ "${config.home.homeDirectory}/.config/sops-nix/secrets/pgadmin" ];
    })
  ];
}
