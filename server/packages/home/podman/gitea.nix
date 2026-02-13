{
  inputs,
  config,
  ...
}:
{
  custom.backups.backblaze = [
    "${config.home.homeDirectory}/.podman/gitea"
  ];
  imports = [
    # UID: 1000
    inputs.secrets.server-main.home.gitea
    ((import ../../../../lib/podman.nix) {
      dependsOn = [
        "traefik"
        "mariadb"
      ];
      image = "gitea/gitea:latest";
      name = "gitea";
      volumes = [
        "${config.home.homeDirectory}/.podman/gitea:/data"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        "USER_UID" = "1000";
        "USER_GID" = "1000";
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
      environmentFile = [ "${config.home.homeDirectory}/.config/sops-nix/secrets/gitea" ];
    })
  ];
}
