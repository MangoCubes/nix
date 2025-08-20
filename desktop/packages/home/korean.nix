{
  pkgs,
  config,
  lib,
  ...
}:
{
  xdg = {
    desktopEntries."org.fcitx.fcitx5-migrator" = {
      noDisplay = true;
      name = "";
    };
    configFile = {
      "gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-im-module=fcitx
      '';
      "gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-im-module=fcitx
      '';
      "fcitx5".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/fcitx5";
    };
  };
  i18n.inputMethod = {
    # type = "fcitx5";
    # enable = true;
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-hangul
        fcitx5-gtk
      ];
      waylandFrontend = true;
    };
  };
  # fcitx5 will be started manually
  systemd.user.services.fcitx5-daemon.Install.WantedBy = lib.mkForce [ ];
  home.sessionVariables = {
    # GTK_IM_MODULE = "wayland";
    QT_IM_MODULE = "fcitx";
    QT_IM_MODULES = "fcitx;wayland;ibus";
    XMODIFIERS = "@im=fcitx";
  };
}
# users.users."${config.username}".extraGroups = [ "input" "uinput" ];
