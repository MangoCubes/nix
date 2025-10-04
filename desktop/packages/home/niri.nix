{
  inputs,
  pkgs,
  lib,
  device,
  colours,
  ...
}:
let
  killclick = pkgs.writeShellScriptBin "killclick" ''kill -9 $(niri msg pick-window | grep PID | tail -n 1 | awk '{print $NF}')'';
  findwsid = pkgs.writeShellScriptBin "findwsid" ''
    niri msg -j workspaces | ${pkgs.jq}/bin/jq ".[] | select(.name == \"$1\")".id
  '';
  # getwindowsbywsid = pkgs.writeShellScriptBin "getwindowsbywsid" ''
  #   niri msg -j windows | jq '.[] | select(.workspace_id == $1)'
  # '';
  openconfig = pkgs.writeShellScriptBin "openconfig" ''
    # WSID: ID of the workspace with the name "config"
    WSID=$(${findwsid}/bin/findwsid config)
    niri msg action focus-workspace config
    niri msg -j windows | ${pkgs.jq}/bin/jq -e ".[] | select(.workspace_id == $WSID and .title == \"NixConfig\")" > /dev/null || rofi-env NixConfig;
  '';
  multiMonitors = (builtins.length device.monitors) != 1;
  gesture = lib.hm.generators.toKDL { } {
    gestures.hot-corners.off._props = { };
  };
  input = lib.hm.generators.toKDL { } {
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
        accel-speed = 0.5;
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
  outputs = builtins.concatStringsSep "\n" (
    builtins.map (output: (lib.hm.generators.toKDL { } output)) (
      if multiMonitors then
        ([
          {
            output._args = [ "DP-1" ];
            output = {
              mode = "3840x2160@59.997";
              scale = device.scale;
              transform = "normal";
              position._props = {
                x = 0;
                y = 0;
              };
            };
          }
          {
            output._args = [ "DP-2" ];
            output = {
              mode = "3840x2160@59.997";
              scale = device.scale;
              transform = "normal";
              position._props = {
                x = 1920;
                y = 0;
              };
            };
          }
        ])
      else
        [
          {
            output._args = [ "eDP-1" ];
            output = {
              scale = device.scale;
              transform = "normal";
              position._props = {
                x = 0;
                y = 0;
              };
            };
          }
        ]
    )
  );
  layout = lib.hm.generators.toKDL { } {
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
  singleNodes = builtins.concatStringsSep "\n" (
    builtins.map (output: (lib.hm.generators.toKDL { } output)) (
      [
        {
          spawn-at-startup._args = [
            "niri-adv-rules"
          ];
        }
        {
          spawn-at-startup._args = [
            "keepassxc"
            "~/Sync/Passwords/Passwords.kdbx"
          ];
        }
        {
          spawn-at-startup._args = [
            "nextcloud"
            "--background"
          ];
        }
        {
          spawn-at-startup._args = [
            "xwayland-satellite"
          ];
        }
        {
          spawn-at-startup._args = [
            "niri"
            "msg"
            "action"
            "focus-workspace"
            "one"
          ];
        }
        {
          spawn-at-startup._args = [
            "loademacs"
          ];
        }
        {
          spawn-at-startup._args = [
            "sur"
            "ags"
          ];
        }
        {
          spawn-at-startup._args = [
            "fnott"
          ];
        }
        {
          environment.DISPLAY._args = [
            ":0"
          ];
        }
        { prefer-no-csd._props = { }; }
        { screenshot-path = "~/Sync/Quick Sync/Pictures/Screenshot from %Y-%m-%d %H-%M-%S.png"; }
      ]
      ++ (
        if multiMonitors then
          [
            {
              spawn-at-startup._args = [
                "niri"
                "msg"
                "action"
                "focus-workspace"
                "two"
              ];
            }
          ]
        else
          [ ]
      )
    )

  );
  windowRule = builtins.concatStringsSep "\n" (
    builtins.map (output: (lib.hm.generators.toKDL { } output)) (import ./niri/window-rule.nix)
  );
  workspace = builtins.concatStringsSep "\n" (
    builtins.map (output: (lib.hm.generators.toKDL { } output)) (
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
        buildWsMon1 = buildWsMon "DP-1";
        buildWsMon2 = buildWsMon "DP-2";
      in
      [
        (buildWs "security")
        (buildWs "media")
        (buildWs "config")
      ]
      ++ (
        if multiMonitors then
          [
            (buildWsMon1 "one")
            (buildWsMon1 "three")
            (buildWsMon1 "five")
            (buildWsMon1 "urgent")
            (buildWsMon2 "two")
            (buildWsMon2 "four")
            (buildWsMon2 "six")
            (buildWsMon2 "windows")
          ]
        else
          (builtins.map buildWs [
            "one"
            "two"
            "three"
            "four"
            "five"
            "six"
            "windows"
            "urgent"
          ])
      )
    )
  );
  binds = lib.hm.generators.toKDL { } (import ./niri/binds.nix);
  clipboard = lib.hm.generators.toKDL { } {
    clipboard.disable-primary._props = { };
  };
  niriConfig = builtins.concatStringsSep "\n" [
    gesture
    input
    outputs
    layout
    singleNodes
    windowRule
    workspace
    binds
    clipboard
  ];
in
{
  home.packages = [
    inputs.niri-adv-rules.packages.x86_64-linux.default
    killclick
    findwsid
    openconfig
  ]
  ++ (with pkgs; [
    playerctl
    niri
  ]);
  xdg.configFile."niri/config.kdl".text = niriConfig;
  xdg.configFile."niri-adv-rules/config.json".text = ''
    [
    	{
    		"Window": [
    			[
    				{
    					"IsFloating": true
    				},
    				{
    					"AppID": [
    						"org.keepassxc.KeePassXC",
    						false
    					]
    				}
    			],
    			[
    				{
    					"MoveToWorkspace": null
    				}
    			]
    		]
    	}
    ]
  '';
}
