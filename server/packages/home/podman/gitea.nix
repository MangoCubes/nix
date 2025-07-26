{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.secrets.server-main.home.gitea ];
  home.activation.gitea = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/.podman/gitea
  '';
  services.podman.containers.gitea = (
    (import ../../../../lib/podman.nix) {
      image = "gitea/gitea:latest";
      name = "gitea";
      volumes = [
        "${config.home.homeDirectory}/.podman/gitea:/data"
        "/etc/timezone:/etc/timezone:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        "USER_UID" = "1000";
        "USER_GID" = "1000";
        "GITEA__database__DB_TYPE" = "mysql";
        "GITEA__database__HOST" = "mariadb:3306";
        "GITEA__database__NAME" = "giteadb";
        "GITEA__database__USER" = "gitea";
        "GITEA__repository__DEFAULT_BRANCH" = "master";
      };
      domain = [
        {
          routerName = "gitea";
          type = 2;
          url = "git.local";
          port = 3000;
        }
      ];
      environmentFile = [ ''${config.home.homeDirectory}/.config/sops-nix/secrets/gitea'' ];
    }
  );
}
