{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      nextcloud-client
      inotify-tools
      libsecret
    ]
  );
  imports = [ inputs.secrets.hm.nextcloud ];
  systemd.user = {
    timers.nextcloud-autosync = {
      Unit = {
        Description = "Timer to delay Nextcloud auto-sync";
        After = [ "graphical-session.target" ];
      };
      Timer.OnActiveSec = "3min";
      Install.WantedBy = [ "graphical-session.target" ];
    };
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
      };
      nextcloud-autosync = {
        Unit = {
          Description = "Auto sync Nextcloud";
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStartPre = "${pkgs.python3}/bin/python ${./nextcloud/init.py}";
          ExecStart = "${pkgs.python3}/bin/python ${./nextcloud/watch.py}";
          Restart = "always";
          RestartSec = "10";
        };
      };
    };
    startServices = true;
  };
}
