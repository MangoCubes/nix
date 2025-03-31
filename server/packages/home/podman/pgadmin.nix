{
  hostname,
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.secrets.hm.other ];
  # Change owner to 5050
  home.activation.pgadmin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p /home/main/.podman/pgadmin
  '';
  services.podman.containers.pgadmin = (
    (import ../../../../lib/podman.nix) {
      inherit hostname;
      image = "dpage/pgadmin4";
      name = "pgadmin";
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
      environmentFile = [ ''${config.home.homeDirectory}/.config/sops-nix/secrets/pgadmin'' ];
    }
  );
}
