{ pkgs, config, ... }:
{
  home.packages = (
    with pkgs;
    [
      playerctl
      niri
    ]
  );
  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/niri/config.kdl";
}
