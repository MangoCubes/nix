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
  xdg.configFile."Kvantum".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/themeing/Kvantum";
  home.packages = (
    with unstable.kdePackages;
    [
      filelight
      dolphin
      qtsvg
      breeze-icons
      okular
    ]
  );
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "kvantum";
  };

  # xdg.configFile = {
  #   "Kvantum/kvantum.kvconfig".text = ''
  #     [General]
  #     theme=GraphiteNordDark
  #   '';
  #   "Kvantum/GraphiteNord".source = "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
  # };
}
