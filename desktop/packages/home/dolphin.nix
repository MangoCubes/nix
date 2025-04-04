{ unstable, config, ... }:
{
  xdg.configFile."kdeglobals".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/kde/kdeglobals";
  xdg.configFile."dolphinrc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/kde/dolphinrc";
  home.packages = (
    with unstable.kdePackages;
    [
      dolphin
      qtsvg
      ark
      breeze-icons
      kio-fuse
      kio-extras
      kio-admin
      qt6ct
    ]
  );
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
  systemd.user.services.dolphin = {
    Unit = {
      Description = "Dolphin file manager";
      PartOf = [ "graphical-session.target" ];
    };
    Environment = {
      QT_QPA_PLATFORM = "wayland";
      PATH = "/run/current-system/sw/bin/";
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.FileManager1";
      # Maybe use this later
      # PATH=$PATH:${lib.makeBinPath [ pkgs.gawk pkgs.coreutils pkgs.acpi ]}
      ExecStart = "${unstable.kdePackages.dolphin}/bin/dolphin --daemon";
    };
  };
}
