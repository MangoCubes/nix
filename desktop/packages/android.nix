{ androidStudio }:
{
  username,
  lib,
  pkgs,
  ...
}:
{
  home-manager.users."${username}" =
    { pkgs, unfreeUnstable, ... }:
    {
      home.packages = lib.mkMerge [
        (lib.mkIf (androidStudio) [ unfreeUnstable.android-studio ])
        [
          pkgs.scrcpy
        ]
      ];
    };
  programs.adb.enable = true;
}
