{
  username,
  config,
  lib,
  ...
}:
let
  cfg = config.custom.features.tablet;
in
{
  options.custom.features.tablet = {
    enable = lib.mkEnableOption "Enable tablet driver";
  };

  config = lib.mkIf cfg.enable {
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

  };
}
