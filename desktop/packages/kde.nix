{ username, ... }:
{
  programs.partition-manager.enable = true;
  home-manager.users."${username}" =
    {
      unstable,
      config,
      ...
    }:
    {
      dconf.settings."org/gnome/desktop/interface".icon-theme = "breeze-dark";
      xdg.configFile."kdeglobals".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/kde/kdeglobals";
      xdg.configFile."dolphinrc".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/kde/dolphinrc";
      xdg.configFile."Kvantum".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/kde/Kvantum";
      home.packages =
        (with unstable.kdePackages; [
          dolphin
          breeze-icons
        ])
        ++ [
          unstable.kdiff3
        ];
      qt = {
        enable = true;
        platformTheme.name = "kde";
        style.name = "kvantum";
      };
    };
}
