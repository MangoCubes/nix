{
  lib,
  pkgs,
  username,
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
    ./restic/options.nix
  ];
  users.groups.restic = { };
  users.users."${user}" = {
    group = "restic";
    isSystemUser = true;
  };
  services.restic.backups = {
    backblaze = {
      inherit user;
      initialize = true;
      package = pkgs.writeShellScriptBin "restic" ''
        export B2_ACCOUNT_ID=$(<"${config.sops.secrets.restic-account-id.path}")
        export B2_ACCOUNT_KEY=$(<"${config.sops.secrets.restic-account-key.path}")
        exec /run/wrappers/bin/restic "$@"
      '';
      paths =
        config.custom.backups.backblaze
        ++ [
          "${config.users.users.${username}.home}/.podman/shared/backups/"
        ]
        ++ config.home-manager.users."${username}".custom.backups.backblaze;
      repositoryFile = config.sops.secrets.restic-repo.path;
      passwordFile = config.sops.secrets.restic-key.path;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
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
    source = lib.getExe pkgs.restic;
    owner = "restic";
    group = "restic";
    permissions = "500";
    capabilities = "cap_dac_read_search+ep";
  };
}
