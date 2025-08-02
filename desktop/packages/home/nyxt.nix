{ pkgs, config, ... }:
let
  nyxttemp = pkgs.writeShellScriptBin "nyxttemp" ''nyxt -p nosave -c ${config.home.homeDirectory}/.config/nyxt/config.lisp -S'';
in
{
  home.packages = [
    pkgs.nyxt
    nyxttemp
  ];
  xdg.configFile."nyxt".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/Nyxt";
}
