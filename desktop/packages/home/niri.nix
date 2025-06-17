{
  pkgs,
  config,
  device,
  hostname,
  ...
}:
let
  configFile = if hostname == "work" then "config-work.kdl" else "config.kdl";
in

{
  home.packages = (
    with pkgs;
    [
      playerctl
      niri
    ]
  );
  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/niri/${configFile}";
}
