{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.secrets.server-main.home.atuin
  ];
  custom.podman.containers = [
    {
      dependsOn = [
        "traefik"
        "postgresql"
      ];
      image = "ghcr.io/atuinsh/atuin:latest";
      name = "atuin";
      domain = [
        {
          routerName = "atuin";
          type = "global";
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
      environmentFile = [ "${config.home.homeDirectory}/.config/sops-nix/secrets/atuin-db" ];
    }
  ];
}
