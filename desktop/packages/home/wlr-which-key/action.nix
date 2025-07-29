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
            submenu = [
              {
                key = "n";
                desc = " Normal";
                cmd = "otd loadsettings ${config.home.homeDirectory}/Sync/GeneralConfig/Tablet/Writing.json";
              }
              {
                key = "f";
                desc = " FPS";
                cmd = "otd loadsettings ${config.home.homeDirectory}/Sync/GeneralConfig/Tablet/FPS.json";
              }
              {
                key = "w";
                desc = " Writing";
                cmd = "otd loadsettings ${config.home.homeDirectory}/Sync/GeneralConfig/Tablet/Writing.json";
              }
            ];
          }
        ]
      else
        [ ]
    )
    ++ [
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
            cmd = "mullvad-browser $(wl-paste) --new-window";
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
