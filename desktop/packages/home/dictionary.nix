{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.hunspell
  ];
  home.sessionVariables.DICPATH = "${config.custom.bookmarks.LinuxConfig.path}/Dictionary";
}
