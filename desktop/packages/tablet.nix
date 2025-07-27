{ username, ... }:
{
  custom.features.tablet = true;
  hardware.opentabletdriver.enable = true;
  home-manager.users."${username}" =
    {
      config,
      ...
    }:
    {
      xdg.configFile."OpenTabletDriver/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/GeneralConfig/Tablet/Normal.json";
    };

}
