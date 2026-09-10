[
  {
    window-rule = {
      match._props = {
        app-id = "floorp$";
        title = "^Picture-in-Picture$";
      };
      open-floating = true;
    };
  }
  {
    window-rule = {
      match._props.app-id = "org.kde.kdeconnect.daemon";
      open-floating = true;
      open-fullscreen = false;
      default-floating-position._props = {
        x = 0;
        y = 0;
        relative-to = "top-left";
      };
      default-column-width.proportion = 1.0;
      default-window-height.proportion = 1.0;

      tiled-state = true;

      focus-ring.off._props = { };
      border.off._props = { };
      shadow.off._props = { };
      draw-border-with-background = false;
    };
  }
  {
    window-rule = {
      match._props = {
        app-id = "floorp$";
        title = "Extension";
      };
      open-floating = true;
    };
  }
  # Block out all KeepassXC windows from screen capture
  {
    window-rule = {
      match._props = {
        app-id = ''^org\\.keepassxc\\.KeePassXC$'';
      };
      block-out-from = "screen-capture";
    };
  }
  # Make unlock prompt float
  {
    window-rule = {
      match._props = {
        app-id = ''^org\\.keepassxc\\.KeePassXC$'';
        title = "Unlock Database";
      };
      open-floating = true;
    };
  }
  # Make main KeepassXC dialog to open in a dedicated space, and make it maximised
  {
    window-rule = {
      match._props = {
        title = "Locked";
        app-id = ''^org\\.keepassxc\\.KeePassXC$'';
      };
      open-on-workspace = "security";
      open-focused = true;
      open-maximized = true;
    };
  }
  {
    window-rule = {
      match._props = {
        app-id = "scrcpy";
      };
      block-out-from = "screen-capture";
      default-column-width._props = { };
    };
  }
  {
    window-rule = {
      match._props = {
        app-id = "ghidra";
      };
      default-column-width._props = { };
      open-floating = true;
    };
  }
  {
    window-rule = {
      _children = [
        {
          exclude._props = {
            is-active = true;
          };
        }
        {
          exclude._props = {
            is-focused = true;
          };
        }
        {
          exclude._props = {
            is-urgent = true;
          };
        }
      ];
      opacity = 0.8;
    };
  }
  {
    window-rule = {
      clip-to-geometry = true;
    };
  }
]
