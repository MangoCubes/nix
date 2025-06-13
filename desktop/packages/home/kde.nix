{
  pkgs,
  unstable,
  config,
  ...
}:
{
  # Run polkit service
  # I use KDE polkit because it allows selecting a user
  systemd.user.services.polkit = {
    Unit.Description = "KDE polkit";
    Install = {
      WantedBy = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  xdg.configFile."kdeglobals".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/kde/kdeglobals";
  xdg.configFile."dolphinrc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/kde/dolphinrc";
  xdg.configFile."qt6ct".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/qt6ct";
  home.packages = (
    with unstable.kdePackages;
    [
      dolphin
      qtsvg
      ark
      breeze-icons
      kio-fuse
      kio-extras
      kio-admin
      qt6ct
      okular
    ]
  );
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
