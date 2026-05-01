{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
let
  syncDirs = [
    "Temp"
    "Documents/Important"
    "Documents/School/6-1"
    "Documents/School/Research/Current"
    "Documents/School/Research/Templates"
    "Documents/School/TA"
    "Documents/School/Work/2026"
    "Projects/ampterm"
    "Projects/dragevac"
    "Projects/School"
  ];
  syncCmd =
    dir:
    "mkdir -p ${config.home.homeDirectory}/Nextcloud/${dir} && ${pkgs.nextcloud-client}/bin/nextcloudcmd -u $NC_USER -p $NC_PASSWORD -h --exclude ${config.home.homeDirectory}/Sync/GeneralConfig/Nextcloud/exclude.lst --path /${dir} ${config.home.homeDirectory}/Nextcloud/${dir} https://cloud.skew.ch";
  syncScript =
    let
      allCmds = (builtins.concatStringsSep "\n" (builtins.map syncCmd syncDirs));
    in
    pkgs.writeShellScriptBin "sync-script" ''
      NC_USER=$(${pkgs.libsecret}/bin/secret-tool lookup Use Nextcloud_Username)
      NC_PASSWORD=$(${pkgs.libsecret}/bin/secret-tool lookup Use Nextcloud_Password)
      ${allCmds}
    '';
in
{
  home.packages = [
    syncScript
  ];
  imports = [ inputs.secrets.hm.nextcloud ];
  systemd.user = {
    services = {
      rclone-cloud = {
        Unit = {
          Description = "Mount Nextcloud drive automatically";
        };
        Service = {
          Type = "notify";
          ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Mounts/Cloud";
          ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/sops-nix/secrets/rclone-cloud --vfs-cache-mode full mount \"cloud:\" %h/Mounts/Cloud";
          Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
          ExecStop = "/bin/fusermount -u %h/Mounts/Cloud";
        };
        Install.WantedBy = lib.mkForce [ "default.target" ];
      };
      nextcloud-autosync = {
        Unit = {
          Description = "Auto sync Nextcloud";
          After = "network-online.target";
        };
        Service = {
          Type = "simple";
          ExecStart = "${syncScript}/bin/sync-script";
          TimeoutStopSec = "300";
          KillMode = "process";
          KillSignal = "SIGINT";
        };
        Install.WantedBy = [ "multi-user.target" ];
      };
    };
    timers.nextcloud-autosync = {
      Unit.Description = "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 60 minutes";
      Timer.OnBootSec = "3min";
      Timer.OnUnitActiveSec = "10min";
      Install.WantedBy = [
        "multi-user.target"
        "timers.target"
      ];
    };
    startServices = true;
  };
}
