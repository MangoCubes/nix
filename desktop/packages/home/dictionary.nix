{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.hunspell
  ];
  home.sessionVariables.DICPATH = "${config.home.homeDirectory}/Sync/LinuxConfig/Dictionary";
}
