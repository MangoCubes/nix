{
  device,
  config,
  unstable,
  ...
}:
let
  img =
    if device.presentation then
      "${config.home.homeDirectory}/.config/configMedia/wallpaper/sc2.png"
    else
      "${config.home.homeDirectory}/.config/configMedia/wallpaper/miku.png";
in
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
      ExecStartPost = "${unstable.awww}/bin/awww img ${img}";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
