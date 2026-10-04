{
  inputs,
  config,
  ...
}:
{
  custom.backups.backblaze = [ "${config.home.homeDirectory}/.podman/gitea" ];
  imports = [ inputs.secrets.server-main.home.gitea ];
  custom.podman.containers.gitea = {
    dependsOn = [
      "traefik"
      "mariadb"
    ];
    image = "gitea/gitea:latest";
    volumes = [
      "${config.home.homeDirectory}/.podman/gitea:/data"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environment = {
      "USER_UID" = "1000";
      "USER_GID" = "1000";
      "GITEA__repository__DEFAULT_BRANCH" = "master";
      "GITEA__server__DOMAIN" = "git.int";
      "GITEA__server__SSH_DOMAIN" = "git.int";
      "GITEA__server__ROOT_URL" = "https://git.int";
    };
    domain = [
      {
        url = "git.int";
        port = 3000;
      }
    ];
    environmentFile = [ config.sops.secrets.gitea.path ];
  };
}
