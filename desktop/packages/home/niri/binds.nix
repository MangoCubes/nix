{
  binds = {
    "Mod+T" = {
      _props = {
        hotkey-overlay-title = "Open a Terminal: Kitty";
      };
      spawn = "kitty";
    };
    "Mod+Shift+B" = {
      _props = {
        hotkey-overlay-title = "Open Temporary Nyxt";
      };
      spawn = "browser";
    };
    "Mod+E" = {
      spawn._args = [
        "kitty"
        "-o"
        "confirm_os_window_close=0"
        "yazi"
      ];
    };
    "Mod+Shift+E" = {
      spawn = "dolphin";
    };
    "Mod+Shift+T" = {
      spawn = "emacs-org";
    };
    "Mod+Shift+W" = {
      focus-workspace = "windows";
    };
    "Mod+S" = {
      spawn = "rofi-search";
    };
    "Mod+R" = {
      spawn._args = [
        "rofi"
        "-show"
        "drun"
      ];
    };
    "Mod+N" = {
      spawn._args = [
        "rofi"
        "-show"
        "nix"
        "-modes"
        "\"nix:rofi-env\""
      ];
    };
    "Mod+Shift+N" = {
      spawn._args = [
        "rofi-env"
        "NixConfig"
      ];
    };
    "Mod+Ctrl+B" = {
      spawn._args = [
        "rofi"
        "-show"
        "browser"
        "-modes"
        "\"browser:rofi-browser\""
      ];
    };
    "Mod+B" = {
      spawn._args = [
        "wlr-which-key"
        "qute"
      ];
    };
    "Mod+D" = {
      spawn._args = [
        "rofi"
        "-show"
        "devices"
        "-modes"
        "\"devices:rofi-removable\""
      ];
    };
    "Mod+Space" = {
      spawn._args = [
        "rofi"
        "-show"
        "calc"
      ];
    };
    "Mod+Shift+Slash" = {
      show-hotkey-overlay._props = { };
    };
    "Mod+L" = {
      spawn = "swaylock";
    };
    "Mod+Left" = {
      focus-column-left._props = { };
    };
    "Mod+Down" = {
      focus-window-or-workspace-down._props = { };
    };
    "Mod+Up" = {
      focus-window-or-workspace-up._props = { };
    };
    "Mod+Right" = {
      focus-column-right._props = { };
    };
    "Mod+Ctrl+A" = {
      focus-column-left._props = { };
    };
    "Mod+Ctrl+S" = {
      focus-window-or-workspace-down._props = { };
    };
    "Mod+Ctrl+W" = {
      focus-window-or-workspace-up._props = { };
    };
    "Mod+Ctrl+D" = {
      focus-column-right._props = { };
    };
    "Mod+Shift+Left" = {
      move-column-left._props = { };
    };
    "Mod+Shift+Down" = {
      move-window-down-or-to-workspace-down._props = { };
    };
    "Mod+Shift+Up" = {
      move-window-up-or-to-workspace-up._props = { };
    };
    "Mod+Shift+Right" = {
      move-column-right._props = { };
    };
    "Mod+Shift+Home" = {
      move-column-to-first._props = { };
    };
    "Mod+Shift+End" = {
      move-column-to-last._props = { };
    };
    "Mod+Ctrl+Left" = {
      focus-monitor-left._props = { };
    };
    "Mod+Ctrl+Down" = {
      focus-monitor-down._props = { };
    };
    "Mod+Ctrl+Up" = {
      focus-monitor-up._props = { };
    };
    "Mod+Ctrl+Right" = {
      focus-monitor-right._props = { };
    };
    "Mod+Home" = {
      focus-column-first._props = { };
    };
    "Mod+End" = {
      focus-column-last._props = { };
    };
    "Mod+Shift+Ctrl+Left" = {
      move-column-to-monitor-left._props = { };
    };
    "Mod+Shift+Ctrl+Down" = {
      move-column-to-monitor-down._props = { };
    };
    "Mod+Shift+Ctrl+Up" = {
      move-column-to-monitor-up._props = { };
    };
    "Mod+Shift+Ctrl+Right" = {
      move-column-to-monitor-right._props = { };
    };
    "Mod+Shift+U" = {
      move-column-to-workspace-down._props = { };
    };
    "Mod+Shift+I" = {
      move-column-to-workspace-up._props = { };
    };
    "Mod+Ctrl+U" = {
      move-workspace-down._props = { };
    };
    "Mod+Ctrl+I" = {
      move-workspace-up._props = { };
    };
    "Mod+O" = {
      _props = {
        repeat = false;
      };
      toggle-overview._props = { };
    };
    "Mod+Q" = {
      _props = {
        repeat = false;
      };
      close-window._props = { };
    };
    "Mod+Shift+Q" = {
      _props = {
        repeat = false;
      };
      spawn = "killclick";
    };
    "Mod+WheelScrollDown" = {
      _props = {
        cooldown-ms = 150;
      };
      focus-workspace-down._props = { };
    };
    "Mod+WheelScrollUp" = {
      _props = {
        cooldown-ms = 150;
      };
      focus-workspace-up._props = { };
    };
    "Mod+Ctrl+WheelScrollDown" = {
      _props = {
        cooldown-ms = 150;
      };
      move-column-to-workspace-down._props = { };
    };
    "Mod+Ctrl+WheelScrollUp" = {
      _props = {
        cooldown-ms = 150;
      };
      move-column-to-workspace-up._props = { };
    };
    "Mod+WheelScrollRight" = {
      focus-column-right._props = { };
    };
    "Mod+WheelScrollLeft" = {
      focus-column-left._props = { };
    };
    "Mod+Ctrl+WheelScrollRight" = {
      move-column-right._props = { };
    };
    "Mod+Ctrl+WheelScrollLeft" = {
      move-column-left._props = { };
    };
    "Mod+Shift+WheelScrollDown" = {
      focus-column-right._props = { };
    };
    "Mod+Shift+WheelScrollUp" = {
      focus-column-left._props = { };
    };
    "Mod+Ctrl+Shift+WheelScrollDown" = {
      move-column-right._props = { };
    };
    "Mod+Ctrl+Shift+WheelScrollUp" = {
      move-column-left._props = { };
    };
    "Mod+1" = {
      focus-workspace = "one";
    };
    "Mod+2" = {
      focus-workspace = "two";
    };
    "Mod+3" = {
      focus-workspace = "three";
    };
    "Mod+4" = {
      focus-workspace = "four";
    };
    "Mod+5" = {
      focus-workspace = "five";
    };
    "Mod+6" = {
      focus-workspace = "six";
    };
    "Mod+K" = {
      focus-workspace = "security";
    };
    "Mod+Shift+1" = {
      move-column-to-workspace = "one";
    };
    "Mod+Shift+2" = {
      move-column-to-workspace = "two";
    };
    "Mod+Shift+3" = {
      move-column-to-workspace = "three";
    };
    "Mod+Shift+4" = {
      move-column-to-workspace = "four";
    };
    "Mod+Shift+5" = {
      move-column-to-workspace = "five";
    };
    "Mod+Shift+6" = {
      move-column-to-workspace = "six";
    };
    "Mod+Tab" = {
      focus-workspace-previous._props = { };
    };
    "Mod+BracketLeft" = {
      consume-or-expel-window-left._props = { };
    };
    "Mod+BracketRight" = {
      consume-or-expel-window-right._props = { };
    };
    "Mod+Shift+BracketLeft" = {
      consume-window-into-column._props = { };
    };
    "Mod+Shift+BracketRight" = {
      expel-window-from-column._props = { };
    };
    "Mod+J" = {
      switch-preset-column-width._props = { };
    };
    "Mod+Shift+J" = {
      switch-preset-window-height._props = { };
    };
    "Mod+Ctrl+J" = {
      reset-window-height._props = { };
    };
    "Mod+F" = {
      maximize-column._props = { };
    };
    "Mod+Shift+F" = {
      fullscreen-window._props = { };
    };
    "Mod+Ctrl+F" = {
      expand-column-to-available-width._props = { };
    };
    "Mod+C" = {
      center-column._props = { };
    };
    "Mod+Shift+C" = {
      center-visible-columns._props = { };
    };
    "Mod+Minus" = {
      set-column-width = "-10%";
    };
    "Mod+Equal" = {
      set-column-width = "+10%";
    };
    "Mod+Shift+Minus" = {
      set-window-height = "-10%";
    };
    "Mod+Shift+Equal" = {
      set-window-height = "+10%";
    };
    "Mod+Shift+V" = {
      toggle-window-floating._props = { };
    };
    "Mod+V" = {
      switch-focus-between-floating-and-tiling._props = { };
    };
    "Mod+W" = {
      spawn._args = [
        "wlr-which-key"
        "niri"
      ];
    };
    "Mod+A" = {
      spawn._args = [
        "wlr-which-key"
        "action"
      ];
    };
    "Mod+Shift+A" = {
      spawn._args = [
        "wlr-which-key"
        "autosetup"
      ];
    };
    "Mod+Shift+R" = {
      spawn._args = [
        "wlr-which-key"
        "advrun"
      ];
    };
    "Mod+M" = {
      spawn._args = [
        "wlr-which-key"
        "media"
      ];
    };
    "Mod+Shift+M" = {
      focus-workspace = "media";
    };
    "Mod+TouchpadScrollDown" = {
      spawn._args = [
        "wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.02+"
      ];
    };
    "Mod+TouchpadScrollUp" = {
      spawn._args = [
        "wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.02-"
      ];
    };
    "XF86AudioRaiseVolume" = {
      _props = {
        allow-when-locked = true;
      };
      spawn._args = [
        "wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.1+"
      ];
    };
    "XF86AudioLowerVolume" = {
      _props = {
        allow-when-locked = true;
      };
      spawn._args = [
        "wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "0.1-"
      ];
    };
    "XF86AudioMute" = {
      _props = {
        allow-when-locked = true;
      };
      spawn._args = [
        "wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SINK@"
        "toggle"
      ];
    };
    "XF86AudioMicMute" = {
      _props = {
        allow-when-locked = true;
      };
      spawn._args = [
        "wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SOURCE@"
        "toggle"
      ];
    };
    "Print" = {
      screenshot._props = { };
    };
    "Shift+Print" = {
      screenshot-screen = {
        _props = {
          write-to-disk = false;
        };
      };
    };
    "Alt+Print" = {
      screenshot-window = {
        _props = {
          write-to-disk = false;
        };
      };
    };
    "Ctrl+Shift+Print" = {
      screenshot-screen._props = { };
    };
    "Ctrl+Alt+Print" = {
      screenshot-window._props = { };
    };
    "XF86Tools" = {
      screenshot._props = { };
    };
    "Shift+XF86Tools" = {
      screenshot-screen = {
        _props = {
          write-to-disk = false;
        };
      };
    };
    "Alt+XF86Tools" = {
      screenshot-window = {
        _props = {
          write-to-disk = false;
        };
      };
    };
    "Ctrl+Shift+XF86Tools" = {
      screenshot-screen._props = { };
    };
    "Ctrl+Alt+XF86Tools" = {
      screenshot-window._props = { };
    };
    "Mod+Escape" = {
      _props = {
        allow-inhibiting = false;
      };
      toggle-keyboard-shortcuts-inhibit._props = { };
    };
    "Mod+Shift+Escape" = {
      quit._props = { };
    };
    "Ctrl+Alt+Delete" = {
      quit._props = { };
    };
    "Mod+Shift+P" = {
      power-off-monitors._props = { };
    };
  };
}
