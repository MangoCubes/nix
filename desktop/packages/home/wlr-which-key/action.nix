{ config, osConfig }:
let
  theme = (import ./theme.nix);
  menu =
    (
      if osConfig.custom.features.tablet then
        [
          {
            key = "t";
            desc = " Tablet Driver";
            submenu =
              let
                load = name: "otd loadsettings ${config.home.homeDirectory}/Sync/GeneralConfig/Tablet/${name}.json";
              in
              [
                {
                  key = "n";
                  desc = " Normal";
                  cmd = (load "Normal");
                }
                {
                  key = "f";
                  desc = " FPS";
                  cmd = (load "FPS");
                }
                {
                  key = "w";
                  desc = " Writing";
                  cmd = (load "Writing");
                }
              ];
          }
        ]
      else
        [ ]
    )
    ++ [
      {
        key = "n";
        desc = " Notifications";
        submenu = [
          {
            key = "c";
            desc = " Clear latest";
            cmd = "fnottctl dismiss";
          }
          {
            key = "C";
            desc = "󰎟 Clear all";
            cmd = "fnottctl dismiss all";
          }
        ];
      }
      {
        key = "l";
        desc = " Lock";
        cmd = ''swaylock'';
      }
      {
        key = "m";
        desc = "󱋈 Sync Mail";
        cmd = ''mbsync -aL && notmuch new'';
      }
      {
        key = "p";
        desc = " Power";
        submenu = [
          {
            key = "s";
            desc = "⏾ Sleep";
            cmd = "systemctl suspend";
          }
          {
            key = "r";
            desc = " Reboot";
            cmd = "reboot";
          }
          {
            key = "p";
            desc = " Power Off";
            cmd = "poweroff";
          }
        ];
      }
      {
        key = "b";
        desc = "󰃠 Brightness";
        submenu = [
          {
            key = "Up";
            desc = " Increase Brightness";
            cmd = "brightnessctl s +5%";
            keep_open = true;
          }
          {
            key = "Down";
            desc = " Decrease Brightness";
            cmd = "brightnessctl s 5%-";
            keep_open = true;
          }
        ];
      }
      {
        key = "c";
        desc = "󱉨 Clipboard";
        submenu = [
          {
            key = "i";
            desc = " Copy image to xclip";
            cmd = "wl-paste | xclip -selection clipboard -target image/png";
          }
          {
            key = "b";
            desc = " Open browser";
            cmd = "browser $(wl-paste)";
          }
          {
            key = "a";
            desc = "󰧬 Create alias";
            cmd = "rofi-sl";
          }
          {
            key = "s";
            desc = "󰱘 Send clipboard";
            cmd = ''kdeconnect-cli -n "Pixel 6" --send-clipboard'';
          }
        ];
      }
    ];
in
theme // { inherit menu; }
