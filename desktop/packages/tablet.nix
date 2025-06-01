{ username, ... }:
{
  hardware.opentabletdriver.enable = true;
  home-manager.users."${username}" =
    {
      config,
      ...
    }:
    {
      xdg.configFile."OpenTabletDriver/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/tablet/settings.json";
    };

}
