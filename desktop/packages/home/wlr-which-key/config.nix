{ config }:
let
  theme = (import ./theme.nix);
  menu =
    (
      if config.features.tablet then
        [
          {
            key = "t";
            desc = "  Tablet Driver";
            submenu = [
              {
                key = "n";
                desc = " Normal";
                cmd = "otd loadsettings ~/Documents/Computer/Tablet\\ Driver\\ Settings/Normal.json";
              }
              {
                key = "w";
                desc = " Writing";
                cmd = "otd loadsettings ~/Documents/Computer/Tablet\\ Driver\\ Settings/Writing.json";
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
        desc = "  Mail";
        submenu = [
          {
            key = "m";
            desc = "  View Mail";
            cmd = ''env DISPLAY=:0 emacsclient -c -e '(notmuch-search "tag:inbox")' '';
          }
          {
            key = "n";
            desc = " 󱋈 Sync Mail";
            cmd = ''mbsync -aL && notmuch new'';
          }
        ];
      }
      {
        key = "p";
        desc = "  Power";
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
        key = "c";
        desc = " 󱉨 Clipboard";
        submenu = [
          {
            key = "i";
            desc = " Copy image to xclip";
            cmd = "wl-paste | xclip -selection clipboard -target image/png";
          }
          {
            key = "b";
            desc = " Open browser";
            cmd = "mullvad-browser $(wl-paste) --new-instance";
          }
          {
            key = "a";
            desc = "󰧬 Create alias";
            cmd = "rofi-sl";
          }
        ];
      }
    ];
in
theme // { inherit menu; }
