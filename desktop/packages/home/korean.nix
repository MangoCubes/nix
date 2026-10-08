{
  pkgs,
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
    };
  };
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-hangul
        fcitx5-gtk
      ];
      waylandFrontend = true;
      settings = {
        globalOptions = {
          "Hotkey/EnumerateForwardKeys"."0" = "Hangul";
          "Hotkey/EnumerateGroupForwardKeys"."0" = "Control+Alt+Hangul";
          Behavior = {
            ShareInputState = "All";
            showInputMethodInformationWhenFocusIn = true;
            CompactInputMethodInformation = false;
            ShowFirstInputMethodInformation = false;
            DefaultPageSize = 10;
          };
        };

        inputMethod = {
          "Groups/0" = {
            Name = "한국어";
            "Default Layout" = "us";
            DefaultIM = "hangul";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "hangul";
          "Groups/1" = {
            Name = "日本語";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/1/Items/0".Name = "mozc";
          "Groups/1/Items/1".Name = "keyboard-us";
          GroupOrder = {
            "0" = "한국어";
            "1" = "日本語";
          };
        };

        addons = {
          classicui.globalSection = {
            "Vertical Candidate List" = true;
            Font = ''"FiraCode Nerd Font 10"'';
            MenuFont = ''"FiraCode Nerd Font 10"'';
            TrayFont = ''"FiraCode Nerd Font 10"'';
            TrayOutlineColor = "#47c8c0";
            TrayTextColor = "#5a676b";
            Theme = "default-dark";
            DarkTheme = "plasma";
          };
          clipboard = {
            globalSection."Number of entries" = 30;
            sections.TriggerKey."0" = "Control+Alt+V";
          };
          quickphrase.sections.TriggerKey."0" = "Control+Alt+Q";
          unicode.sections = {
            TriggerKey."0" = "Control+Alt+U";
            DirectUnicodeMode."0" = "Control+Alt+Shift+U";
          };
        };
      };
    };
  };
  home.sessionVariables = {
    # GTK_IM_MODULE = "wayland";
    QT_IM_MODULE = "fcitx";
    QT_IM_MODULES = "fcitx;wayland;ibus";
    XMODIFIERS = "@im=fcitx";
  };
}
