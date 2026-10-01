{ config, pkgs, ... }:
let
  mergepasswords = pkgs.writeShellScriptBin "mergepasswords" (
    builtins.readFile ./keepassxc/mergepasswords.sh
  );
in
{
  xdg.configFile."keepassxc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/keepassxc";
  home.packages = [
    pkgs.keepassxc
    pkgs.libsecret
    mergepasswords
  ];
}
