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
      xdg.desktopEntries.android-studio = {
        comment = "The official Android IDE";
        icon = "android-studio";
        name = "Android Studio (stable channel)";
        terminal = false;
        categories = [
          "Development"
          "IDE"
        ];
        exec = ''env _JAVA_AWT_WM_NONREPARENTING=1 _JAVA_AWT_WM_NONREPARENTING=1 AWT_TOOLKIT=MToolkit GDK_BACKEND=x11 LANG=en_US.UTF-8 QT_QPA_PLATFORM=xcb android-studio'';
      };

      home.packages = lib.mkMerge [
        (lib.mkIf (androidStudio) [ unfreeUnstable.android-studio ])
        [
          pkgs.scrcpy
        ]
        (lib.mkIf (heimdall) [ pkgs.heimdall-gui ])
      ];
    };
  programs.adb.enable = true;
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
