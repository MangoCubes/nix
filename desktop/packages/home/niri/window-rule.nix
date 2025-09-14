[
  {
    window-rule = {
      match._props = {
        app-id = "firefox$";
        title = "^Picture-in-Picture$";
      };
      open-floating = true;
    };
  }
  {
    window-rule = {
      match._props = {
        app-id = "firefox$";
        title = "^Extension";
      };
      open-floating = true;
    };
  }
  {
    window-rule = {
      match._props = {
        title = ''^*.kdbx \\[Locked\\]'';
        app-id = ''^org\\.keepassxc\\.KeePassXC$'';
      };
      open-on-workspace = "security";
      open-focused = false;
      open-maximized = true;
    };
  }
  {
    window-rule = {
      match._props = {
        app-id = ''^org\\.keepassxc\\.KeePassXC$'';
      };
      block-out-from = "screen-capture";
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
      match._props = {
        app-id = ".+freerdp";
      };
      open-maximized = true;
      open-fullscreen = false;
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
]
