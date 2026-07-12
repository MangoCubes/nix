{
  config,
  osConfig,
  pkgs,
  ...
}:
let
  inhibited =
    cmd:
    ''err=$(systemctl ${cmd} --check-inhibitors=yes 2>&1) || ${pkgs.notify-desktop}/bin/notify-desktop "Shutdown Blocked" "$err";'';
in
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
    desc = " Clear Notifications";
    cmd = "fnottctl dismiss all";
  }
  {
    key = "l";
    desc = " Lock";
    cmd = "swaylock";
  }
  {
    key = "k";
    desc = "󰢬 Unlock Keys";
    cmd = "unlockkeys";
  }
  {
    key = "m";
    desc = "󱋈 Sync Mail";
    cmd = ''ID=$(${pkgs.notify-desktop}/bin/notify-desktop "Syncing..." "Synchronising all mailboxes...") && systemctl --user restart mbsync && ${pkgs.notify-desktop}/bin/notify-desktop -r $ID "Synced!" "All the mailboxes have been updated successfully." || ${pkgs.notify-desktop}/bin/notify-desktop -r $ID "Sync failed!" "mbsync exited with code $?"'';
  }
  {
    key = "p";
    desc = " Power";
    submenu = [
      {
        key = "s";
        desc = "⏾ Sleep";
        cmd = (inhibited "suspend");
      }
      {
        key = "r";
        desc = " Reboot";
        cmd = (inhibited "reboot");
      }
      {
        key = "p";
        desc = " Power Off";
        cmd = (inhibited "poweroff");
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
        key = "e";
        desc = "󱓥 Edit Clipboard";
        cmd = (
          config.custom.terminal.genCmd {
            command = ''sh -c "wl-paste | ${pkgs.moreutils}/bin/vipe | wl-copy -n 2>/dev/null"'';
            detached = true;
          }
        );
      }
      {
        key = "y";
        desc = "󰥨 Open Yazi";
        cmd = (
          config.custom.terminal.genCmd {
            command = ''yazi "$(wl-paste)"'';
            detached = true;
          }
        );
      }
      {
        key = "b";
        desc = " Open browser";
        cmd = ''browser "$(wl-paste)"'';
      }
      {
        key = "a";
        desc = "󰧬 Create alias";
        cmd = "rofi-sl";
      }
      {
        key = "s";
        desc = "󰱘 Send clipboard";
        cmd = ''kdeconnect-cli -n "PixelKR" --send-clipboard'';
      }
      {
        key = "p";
        desc = "󰟵 Generate Password";
        cmd = "keepassxc-cli generate --exclude-similar -L 32 | wl-copy";
      }
    ];
  }
]
