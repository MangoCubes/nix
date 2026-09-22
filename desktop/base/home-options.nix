{
  lib,
  config,
  inputs,
  ...
}:
{
  options.custom.wallpaper = lib.mkOption {
    type = lib.types.str;
    default =
      if config.custom.device.presentation then
        "${inputs.secrets.res}/media/wallpaper/sc2.png"
      else
        "${inputs.secrets.res}/media/wallpaper/miku.png";
  };

  options.custom.microsoftTeams = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
}
