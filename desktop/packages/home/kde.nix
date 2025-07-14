{
  unstable,
  config,
  ...
}:
{
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
