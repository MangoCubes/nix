{
  config,
  inputs,
  pkgs,
  lib,
  colours,
  ...
}:
let
  toKDL = lib.hm.generators.toKDL { };
  genNodes = nodes: builtins.concatStringsSep "\n" (builtins.map toKDL nodes);
  spawnAtStartup = args: { spawn-at-startup._args = args; };
  killclick = pkgs.writeShellScriptBin "killclick" "kill -9 $(niri msg pick-window | grep PID | tail -n 1 | awk '{print $NF}')";
  killcurrent = pkgs.writeShellScriptBin "killcurrent" "kill -9 $(niri msg focused-window | grep PID | tail -n 1 | awk '{print $NF}')";
  findwsid = pkgs.writeShellScriptBin "findwsid" ''
    niri msg -j workspaces | ${pkgs.jq}/bin/jq ".[] | select(.name == \"$1\")".id
  '';
  openconfig = pkgs.writeShellScriptBin "openconfig" (
    builtins.replaceStrings [ "@findwsid@" "@jq@" ] [ "${findwsid}/bin/findwsid" "${pkgs.jq}/bin/jq" ] (
      builtins.readFile ./niri/openconfig.sh
    )
  );
  qrscan = pkgs.writeShellScriptBin "qrscan" ''
    selected_area=$(${pkgs.slurp}/bin/slurp) && ${pkgs.grim}/bin/grim -g "$selected_area" - | ${pkgs.zbar}/bin/zbarimg - | tee >(${pkgs.notify-desktop}/bin/notify-desktop "QR Code Captured" "$(cat)") | wl-copy;
  '';
  openmedia = pkgs.writeShellScriptBin "openmedia" (
    builtins.replaceStrings
      [ "@findwsid@" "@jq@" "@amptermCmd@" ]
      [
        "${findwsid}/bin/findwsid"
        "${pkgs.jq}/bin/jq"
        (config.custom.terminal.genCmd {
          command = "ampterm";
          title = "ampterm";
          detached = true;
        })
      ]
      (builtins.readFile ./niri/openmedia.sh)
  );
  mon1 = "DP-1";
  mon2 = "HDMI-A-2";
  multiMonitors = (builtins.length config.custom.device.monitors) != 1;
  mkOutput = name: x: extra: {
    output = {
      _args = [ name ];
      scale = config.custom.device.scale;
      transform = "normal";
      position._props = {
        inherit x;
        y = 0;
      };
    }
    // extra;
  };
  gesture = toKDL {
    gestures.hot-corners.off._props = { };
  };
  input = toKDL {
    input = {
      keyboard = {
        xkb._props = { };
        repeat-delay = 200;
        repeat-rate = 50;
        numlock._props = { };
      };
      touchpad = {
        tap._props = { };
        natural-scroll._props = { };
        accel-speed = 0.5;
        accel-profile = "flat";
      };
      mouse = {
        accel-speed = 0.25;
        accel-profile = "flat";
      };
      trackpoint = {
        accel-speed = 0.5;
        accel-profile = "flat";
      };
      touch = {
        map-to-output = "eDP-1";
      };
      warp-mouse-to-focus._props = { };
      focus-follows-mouse._props = {
        max-scroll-amount = "0%";
      };
    };
  };
  outputs = genNodes (
    if multiMonitors then
      [
        (mkOutput mon1 0 { mode = "3840x2160@59.997"; })
        (mkOutput mon2 1920 { mode = "3840x2160@59.997"; })
      ]
    else
      [ (mkOutput "eDP-1" 0 { }) ]
  );
  hotkeyOverlay = toKDL {
    hotkey-overlay = {
      skip-at-startup._props = { };
    };
  };
  layout = toKDL {
    layout = {
      always-center-single-column._props = { };
      tab-indicator = {
        width = 4;
        gap = 4;
        length._props = {
          total-proportion = 1.0;
        };
        position = "left";
        place-within-column._props = { };
      };
      gaps = 4;
      center-focused-column = "on-overflow";
      preset-window-heights._children = [
        {
          proportion = 1.0;
        }
      ];
      preset-column-widths._children = [
        {
          proportion = 0.5;
        }
        {
          proportion = 0.9;
        }
      ];
      default-column-width = {
        proportion = 0.9;
      };
      focus-ring = {
        off._props = { };
        width = 4;
        active-color = "#${colours.base.miku}";
      };
      border = {
        width = 4;
        active-color = "#${colours.base.miku}";
        inactive-color = "#${colours.base.lightBg}";
        urgent-color = "#${colours.base.teto}";
      };
      struts._props = { };
    };
  };
  singleNodes = genNodes (
    (builtins.map spawnAtStartup [
      [
        "keepassxc"
        "~/Sync/Passwords/Passwords.kdbx"
      ]
      [ "niri-adv-rules" ]
      [ "xwayland-satellite" ]
      [
        "niri"
        "msg"
        "action"
        "focus-workspace"
        "one"
      ]
      [ "loademacs" ]
    ])
    ++ [
      {
        blur = {
          passes = 3;
          offset = 3;
          noise = 0.02;
          saturation = 1.5;
        };
      }
      {
        environment.DISPLAY._args = [
          ":0"
        ];
      }
      { prefer-no-csd._props = { }; }
      { screenshot-path = "~/Sync/QuickSecure/Pictures/Screenshot from %Y-%m-%d %H-%M-%S.png"; }
    ]
    ++ lib.optionals multiMonitors [
      (spawnAtStartup [
        "niri"
        "msg"
        "action"
        "focus-workspace"
        "two"
      ])
    ]
  );
  windowRule = genNodes (import ./niri/window-rule.nix);
  workspace = genNodes (
    let
      buildWs = (ws: { workspace._args = [ ws ]; });
      buildWsMon =
        mon:
        (ws: {
          workspace = {
            _args = [ ws ];
            open-on-output = mon;
          };
        });
      buildWsMon1 = buildWsMon mon1;
      buildWsMon2 = buildWsMon mon2;
    in
    (builtins.map buildWs [
      "security"
      "media"
      "config"
      "scratch"
    ])
    ++ (
      if multiMonitors then
        (builtins.map buildWsMon1 [
          "one"
          "three"
          "five"
          "urgent"
        ])
        ++ (builtins.map buildWsMon2 [
          "two"
          "four"
          "six"
        ])
      else
        (builtins.map buildWs [
          "one"
          "two"
          "three"
          "four"
          "five"
          "six"
          "urgent"
        ])
    )
  );
  recent-windows = toKDL ((import ./niri/recent-windows.nix) { inherit colours; });
  # cursor = lib.hm.generators.toKDL { } { cursor.plugin = "${./niri/cursor.lua}"; };
  cursor = toKDL {
    cursor.plugin = "${config.home.homeDirectory}/.config/niri/cursor.lua";
  };
  binds = toKDL ((import ./niri/binds.nix) { inherit config inputs pkgs; });
  clipboard = toKDL {
    clipboard.disable-primary._props = { };
  };
  niriConfig = builtins.concatStringsSep "\n" [
    recent-windows
    gesture
    input
    outputs
    layout
    singleNodes
    windowRule
    workspace
    binds
    clipboard
    hotkeyOverlay
    cursor
  ];
in
{
  imports = [
    inputs.niri-adv-rules.homeManager
  ];
  home.packages = [
    killclick
    killcurrent
    findwsid
    openconfig
    openmedia
    qrscan
  ]
  ++ (with pkgs; [
    playerctl
  ])
  ++ [
    inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  xdg.configFile."niri/config.kdl".text = niriConfig;
  xdg.configFile."niri-adv-rules/config.json".text = ''
    [{"Window":{"conditions":[{"IsFloating":true},{"AppID":{"id":"org.keepassxc.KeePassXC","invert":false}}],"actions":[{"MoveToWorkspace":null}]}}]
  '';
}
