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
    let
      mount-android = pkgs.writeShellScriptBin "mount-android" ''
        jmtpfs -l;
        echo -n "Enter <busLocation>,<devNum> (two numbers separated by a single comma and no space) to mount:"
        read devid;
        mount=~/Mounts/Android/$devid;
        if [ -z "$(ls -A $mount 2> /dev/null)" ]; then
            mkdir -p $mount;
            jmtpfs -device=$devid $mount
        else
            echo "Directory $mount is not empty."
        fi
      '';
    in
    {
      home.packages = lib.mkMerge [
        (lib.mkIf (androidStudio) [ unfreeUnstable.android-studio ])
        (lib.mkIf (heimdall) [ pkgs.heimdall-gui ])
        [
          pkgs.android-tools
          pkgs.scrcpy
          mount-android
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
