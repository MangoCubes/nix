{
  scale,
  monitors,
  presentation,
  pkgs,
  lib,
  config,
  ...
}:
let
  terminal = "kitty";
  fileManager = "kitty yazi";
  altFileManager = "dolphin";
  menu = "rofi -show drun";
  # textEditor = ''kitty nvim ~/Sync/Quick\ Sync/Org/main.org'';
  textEditor = ''kitty -d ${config.home.homeDirectory}/Sync/Notes/MD nvim .'';
  mod = "SUPER";
  # notes = ''kitty -d ${config.home.homeDirectory}/Sync/Notes/ nvim .'';
  emacsOrg = ''emacsclient -c --eval '(find-file "${config.home.homeDirectory}/Sync/Notes/Org/Main.org")' '';
  mail = ''emacsclient -c -e '(notmuch-search "tag:inbox")' '';
  pic =
    if presentation then
      "${config.home.homeDirectory}/.config/configMedia/wallpaper/sc2.png"
    else
      "${config.home.homeDirectory}/.config/configMedia/wallpaper/miku.png";
  lock = "keepassxc --lock && hyprlock";
in
{
  wayland.windowManager.hyprland = {
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # package = unstable.hyprland;
    # portalPackage = hyprpkg;
    systemd.variables = [ "--all" ];
    enable = true;
    settings = {
      monitor = ",preferred,auto,${toString scale}";
      exec-once = [
        terminal
        # I need Korean
        "fcitx5 &"
        # I also need nextcloud running
        # TODO: Make it a service?
        "nextcloud --background &"
        # Run KeepassXC in keepass workspace without swapping the current workspace
        "hyprctl dispatch exec [workspace name:keepass silent] keepassxc ${config.home.homeDirectory}/Sync/Passwords/Passwords.kdbx"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];
      # So that Super + Tab works
      binds.allow_workspace_cycles = true;
      bind =
        (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "${mod}, code:1${toString i}, workspace, ${toString ws}"
                "${mod} SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                "${mod} CTRL, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
              ]
            ) 10
          )
        )
        ++ [
          ''${mod}, Tab, workspace, previous''
          ''${mod}, Q, killactive,''
          # Click to kill a window
          ''${mod} SHIFT, Q, exec, hyprctl kill''
          ''${mod} SHIFT, escape, exit,''
          ''${mod}, V, togglefloating,''
          ''${mod}, J, togglesplit, dwindle''
          ''${mod}, F, fullscreen, 0''
          ''${mod}, left, movefocus, l''
          ''${mod}, right, movefocus, r''
          ''${mod}, up, movefocus, u''
          ''${mod}, down, movefocus, d''

        ]
        ++ (builtins.concatLists (
          builtins.map
            (
              key:
              let
                # Pictures will be stored in this directory
                picDir = "${config.home.homeDirectory}/Sync/Quick\\ Sync/Pictures";
                # Ensure this directory exists
                ensure = "${pkgs.coreutils}/bin/mkdir -p ${picDir}";
                # Set picture saving directory
                env = ''GRIM_DEFAULT_DIR=${picDir}'';
                # Make picture directory, set the environment variables, then run grim
                fullscreen = "${ensure} && ${env} ${pkgs.grim}/bin/grim";
                # Capture region with slurp, then get that area
                cropped = ''${fullscreen} -g "$(${pkgs.slurp}/bin/slurp)"'';
                # Given a language, extract text from it
                capture = lang: ''${pkgs.tesseract}/bin/tesseract stdin stdout -l ${lang}'';
                # Save content to XClip (I don't think it is working)
                saveToXClipImage = ''${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i'';
                # Copy text to XClip (I don't think it is working)
                saveToXClip = ''${pkgs.xclip}/bin/xclip -selection clipboard -i'';
              in
              [
                # Select an area, then capture text in it in English
                ''${mod}, ${key}, exec, ${cropped} - | ${capture "eng"} | wl-copy; wl-paste | ${saveToXClip}''
                # Select an area, then capture text in it in Korean
                ''${mod} SHIFT, ${key}, exec, ${cropped} - | ${capture "kor"} | wl-copy; wl-paste | ${saveToXClip}''
                # Capture the whole screen, then copy it to clipboard
                '', ${key}, exec, ${fullscreen} - | wl-copy; wl-paste | ${saveToXClipImage}''
                # Select an area, then copy it to clipboard
                ''SHIFT, ${key}, exec, ${cropped} - | wl-copy; wl-paste | ${saveToXClipImage}''
                # Capture the whole screen, then save it
                ''CTRL, ${key}, exec, ${fullscreen}''
                # Select an area, then save it
                ''CTRL SHIFT, ${key}, exec, ${cropped}''
              ]
            )
            [
              "Print"
              # FUCK YOU APPLE
              "code:191"
            ]
        ))
        ++ [
          ''${mod}, O, exec, ${emacsOrg}''
          ''${mod}, K, workspace, name:keepass''
          ''${mod} SHIFT, M, workspace, name:music''
          ''${mod} SHIFT, A, workspace, name:notes''
          ''${mod}, P, workspace, name:config''
          ''${mod}, C, swapactiveworkspaces, 0 1''
          ''${mod}, S, exec, rofi-search''

          ''${mod}, mouse_down, workspace, e+1''
          ''${mod}, mouse_up, workspace, e-1''

          ''${mod}, R, exec, ${menu}''
          ''${mod}, E, exec, ${fileManager}''
          ''${mod} SHIFT, E, exec, ${altFileManager}''
          ''${mod}, T, exec, ${terminal}''
          ''${mod}, M, exec, ${mail}''
          ''${mod}, L, exec, ${lock}''
          ''${mod}, N, exec, rofi -show nix -modes "nix:rofi-env"''
          ''${mod} SHIFT, N, exec, rofi-env NixConfig''
          ''${mod}, B, exec, rofi -show browser -modes "browser:rofi-browser"''
          ''${mod}, D, exec, rofi -show devices -modes "devices:rofi-removable"''

          ''${mod}, SPACE, exec, rofi -show calc''

          ''${mod} SHIFT, B, exec, mullvad-browser''
          ''${mod} SHIFT, F, exec, firefox''
          ''${mod} SHIFT, T, exec, ${textEditor}''
          ''${mod} SHIFT, V, exec, codium --password-store="gnome-libsecret"''

        ];
      bindm = [
        ''${mod}, mouse:272, movewindow''
        ''${mod}, mouse:273, resizewindow''
      ];
      # debug.disable_logs = false;
      xwayland.force_zero_scaling = true;
      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 4;
        "col.active_border" = "rgba(47c8c0ff)";
        "col.inactive_border" = "rgba(5a676bff)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };
      decoration = {
        rounding = 0;

        active_opacity = 1;
        inactive_opacity = 0.8;

        # drop_shadow = false;
        blur = {
          enabled = true;
          size = 10;
          passes = 2;

          vibrancy = 0.1696;
        };
      };
      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 3, myBezier"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 5, default"
          "borderangle, 1, 3, default"
          "fade, 1, 3, default"
          "workspaces, 1, 3, default"
        ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      # master.new_is_master = true;
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };
      input = {

        follow_mouse = 1;

        sensitivity = 0.5;
        accel_profile = "flat";
        touchpad.natural_scroll = true;

        repeat_rate = 50;
        repeat_delay = 200;
      };
      # HOWTO: Optional array part
      workspace =
        [
          "name:keepass, on-created-empty:keepassxc ${config.home.homeDirectory}/Sync/Passwords/Passwords.kdbx"
        ]
        ++ (lib.optionals (monitors == 2) [
          "1, monitor:DP-1, default:true"
          "3, monitor:DP-1, default:true"
          "5, monitor:DP-1, default:true"
          "7, monitor:DP-1, default:true"
          "9, monitor:DP-1, default:true"
          "2, monitor:DP-2, default:true"
          "4, monitor:DP-2, default:true"
          "6, monitor:DP-2, default:true"
          "8, monitor:DP-2, default:true"
          "10, monitor:DP-2, default:true"
        ]);
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        # Ensure KDE polkit is always floating
        "stayfocused, title:^rofi"
        "float, title:^rofi"
        # Ensure KDE polkit is always floating
        "stayfocused, class:^org.kde.polkit"
        "float, class:^org.kde.polkit"

        "stayfocused, title:^Unlock Database"
        "float, title:^Unlock Database"

      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ pic ];
      wallpaper = [ (", " + pic) ];
    };
  };
  # Run polkit service
  # I use KDE polkit because it allows selecting a user
  systemd.user.services.polkit = {
    Unit.Description = "KDE polkit";
    Install = {
      WantedBy = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = lock;
      };

      listener = [
        {
          timeout = 600;
          on-timeout = lock;
        }
      ];
    };
  };
  programs.hyprlock = {
    enable = true;
    settings = {
      input-field = {
        monitor = "";
        size = "300, 50";
        outline_thickness = 4;
        dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
        outer_color = "rgba(47c8c0ff)";
        inner_color = "rgba(000000ff)";
        font_color = "rgba(5a676bff)";
        fade_on_empty = true;
        fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
        placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
        hide_input = false;
        rounding = 0; # -1 means complete rounding (circle/oval)
        check_color = "rgb(204, 136, 34)";
        fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
        fail_timeout = 2000; # milliseconds before fail_text and fail_color disappears
        fail_transition = 300; # transition time in ms between normal outer_color and fail_color
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false; # change color if numlock is off
        swap_font_color = false; # see below

        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      background = {
        monitor = "";
        path = pic; # supports png, jpg, webp (no animations, though)
        color = "rgba(25, 20, 20, 1.0)";

        # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
        blur_passes = 1; # 0 disables blurring
        blur_size = 7;
        noise = 0.0117;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };
    };
  };
}
