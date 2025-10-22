{
  pkgs,
  username,
  inputs,
  config,
  ...
}:
let
  user = "restic";
in
{
  home-manager.users."${username}" =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.restic ];
      imports = [ ./restic/options.nix ];
    };
  imports = [
    inputs.secrets.server-main.restic
    ./restic/options.nix
  ];
  users.users."${user}".isNormalUser = true;
  services.restic.backups = {
    backblaze = {
      inherit user;
      initialize = true;
      package = pkgs.writeShellScriptBin "restic" ''
        export B2_ACCOUNT_ID=$(<"/run/secrets/restic/account-id")
        export B2_ACCOUNT_KEY=$(<"/run/secrets/restic/account-key")
        exec /run/wrappers/bin/restic "$@"
      '';
      paths =
        config.custom.backups.backblaze
        ++ [
          "${config.users.users.${username}.home}/.podman/shared/backups/"
          # "${config.users.users.${username}.home}/.podman/mariadb"
          # "${config.users.users.${username}.home}/.podman/postgres"
        ]
        ++ config.home-manager.users."${username}".custom.backups.backblaze;
      repositoryFile = "/run/secrets/restic/repo";
      passwordFile = "/run/secrets/restic/key";
      timerConfig = {
        OnUnitActiveSec = "1h";
      };

      pruneOpts = [
        # For the last 7 days, keep only one most recent copy within a day
        "--keep-daily 7"
        "--keep-weekly 10"
        "--keep-yearly 25"
      ];
    };
  };
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = user;
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

}
