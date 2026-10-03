{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.custom.android;
in
{
  options.custom.android = {
    enable = lib.mkEnableOption "Enable Android tools and scrcpy";
    androidStudio = lib.mkEnableOption "Android Studio";
    heimdall = lib.mkEnableOption "Heimdall GUI and udev rules";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${username}" =
      { pkgs, unfreeUnstable, ... }:
      {
        home.packages = lib.mkMerge [
          [
            pkgs.android-tools
            pkgs.scrcpy
          ]
          (lib.mkIf cfg.androidStudio [ unfreeUnstable.android-studio ])
          (lib.mkIf cfg.heimdall [ pkgs.heimdall-gui ])
        ];
      };

    services.udev.extraRules = lib.mkIf cfg.heimdall ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", ATTR{idProduct}=="6601", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", ATTR{idProduct}=="685d", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", ATTR{idProduct}=="68c3", MODE="0666"
    '';
  };
}
