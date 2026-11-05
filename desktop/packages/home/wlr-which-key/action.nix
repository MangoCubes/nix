{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  inhibited =
    cmd:
    ''err=$(systemctl ${cmd} --check-inhibitors=yes 2>&1) || ${pkgs.libnotify}/bin/notify-send "Shutdown Blocked" "$err";'';
in
(lib.optionals osConfig.custom.tablet.enable [
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
])
++ [
  {
    key = "n";
    desc = "󰎟 Clear Notifications";
    cmd = "swaync-client --hide-all";
  }
  {
    key = "N";
    desc = " Open Notification Centre";
    cmd = "swaync-client --open-panel";
  }
  {
    key = "l";
    desc = " Lock";
    cmd = "lock-desktop";
  }
  {
    key = "k";
    desc = "󰢬 Unlock Keys";
    cmd = "unlockkeys";
  }
  {
    key = "m";
    desc = "󱋈 Sync Mail";
    cmd = ''ID=$(${pkgs.libnotify}/bin/notify-send --print-id "Syncing..." "Synchronising all mailboxes...") && systemctl --user restart mbsync && ${pkgs.libnotify}/bin/notify-send --replace-id="$ID" "Synced!" "All the mailboxes have been updated successfully." || ${pkgs.libnotify}/bin/notify-send --replace-id="$ID" "Sync failed!" "mbsync exited with code $?"'';
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
]
