{
  config,
  osConfig,
  pkgs,
  ...
}:
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
    key = "k";
    desc = "󰢬 Unlock Keys";
    cmd = ''unlockkeys'';
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
        key = "e";
        desc = "󱓥 Edit Clipboard";
        cmd = ''wl-paste | ${pkgs.moreutils}/bin/vipe | wl-copy'';
      }
      {
        key = "y";
        desc = "󰥨 Open Yazi";
        cmd = ''term yazi "$(wl-paste)"'';
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
        cmd = ''keepassxc-cli generate --exclude-similar -L 32 | wl-copy'';
      }
    ];
  }
]
