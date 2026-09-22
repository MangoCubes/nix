{
  config,
  unstable,
  ...
}:
{
  home.packages = [
    unstable.awww
  ];
  systemd.user.services.awww = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Unit = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
      Description = "awww-daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      # Type = "oneshot";
      ExecStart = "${unstable.awww}/bin/awww-daemon";
      ExecStartPost = "${unstable.awww}/bin/awww img ${config.custom.wallpaper}";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
