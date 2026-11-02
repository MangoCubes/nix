{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.secrets.server-main.home.atuin ];
  custom.podman.containers.atuin = {
    postgresql = {
      image = "postgres:17";
      secretEnvPath = config.sops.secrets.atuin-db.path;
    };
    dependsOn = [ "postgresql-atuin" ];
    image = "ghcr.io/atuinsh/atuin:latest";
    domain = [
      {
        url = "sh.skew.ch";
        port = 8888;
      }
    ];
    exec = "start";
    environment = {
      "ATUIN_HOST" = "0.0.0.0";
      "ATUIN_OPEN_REGISTRATION" = "true";
      "RUST_LOG" = "info,atuin_server=debug";
    };
    environmentFile = [ config.sops.secrets.atuin-db.path ];
  };
}
