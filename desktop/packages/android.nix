{
  androidStudio ? false,
  heimdall ? false,
}:
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
        (lib.mkIf (heimdall) [ pkgs.heimdall-gui ])
        [
          pkgs.android-tools
          pkgs.scrcpy
        ]
      ];
    };
}
// (
  if (heimdall) then
    {
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", ATTR{idProduct}=="6601", MODE="0666"
        SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", ATTR{idProduct}=="685d", MODE="0666"
        SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", ATTR{idProduct}=="68c3", MODE="0666"
      '';
    }
  else
    { }
)
