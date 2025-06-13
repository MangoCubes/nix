{
  lib,
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
    unstable.swww
  ];
  # systemd.user.services.swww = {
  #   # Install = {
  #   #   WantedBy = [ "graphical-session.target" ];
  #   # };
  #
  #   # Unit = {
  #   #   ConditionEnvironment = "WAYLAND_DISPLAY";
  #   #     Description = "swww-daemon";
  #   #   PartOf = [ "graphical-session.target" ];
  #   #   After = [ "graphical-session.target" ];
  #   # };
  #
  #   Service = {
  #     # Type = "oneshot";
  #     ExecStart = "${unstable.swww}/bin/swww-daemon";
  #     ExecStartPost = "${unstable.swww}/bin/swww img ${img}";
  #     Restart = "always";
  #     RestartSec = 10;
  #   };
  # };
  # # home.activation.swww =
  # #   lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  # #     ${unstable.swww}/bin/swww img --transition-type center --transition-step 90 ${img}
  # #   '';
  home.sessionVariables = {
    WALLPAPER = "${img}";
  };
  home.activation.swww = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${unstable.swww}/bin/swww img --transition-type center --transition-step 90 ${img}
  '';

}
