{ pkgs, config, ... }:
let
  browser = pkgs.writeShellScriptBin "browser" ''qutebrowser --temp-basedir -C ${config.home.homeDirectory}/.config/qutebrowser/config.py $@'';
in
{
  home.packages = [
    pkgs.qutebrowser
    browser
  ];
  xdg.configFile."qutebrowser/config.py".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/qute/config.py";
}
