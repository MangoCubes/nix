{
  inputs,
  config,
  ...
}:
let
  sshPort = "2222";
in
{
  imports = [ inputs.secrets.server-main.home.gitea ];
  custom.podman.containers.gitea = {
    dependsOn = [ "mariadb" ];
    image = "gitea/gitea:latest";
    disk.persistBackup = [ "gitea" ];
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
      "GITEA__server__SSH_PORT" = sshPort;
      "GITEA__server__SSH_LISTEN_PORT" = "22";
    };
    ports = [ "${sshPort}:22" ];
    domain = [
      {
        url = "git.int";
        port = 3000;
      }
    ];
    environmentFile = [ config.sops.secrets.gitea.path ];
  };
}
