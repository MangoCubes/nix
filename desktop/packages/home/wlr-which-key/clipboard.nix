{ config, pkgs, ... }:
[
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
    cmd = ''kdeconnect-cli -n "Pixel 9" --send-clipboard'';
  }
  {
    key = "p";
    desc = "󰟵 Generate Password";
    cmd = "keepassxc-cli generate --exclude-similar -L 32 | tr -d '\n' | wl-copy";
  }
  {
    key = "j";
    desc = "󰘦 Format JSON";
    cmd = "wl-paste | ${pkgs.jq}/bin/jq | wl-copy";
  }
  {
    key = "h";
    desc = "󱊧 Hex Decode";
    cmd = "wl-paste | sed -E 's/0[xX]|\\x//g' | tr -cd '0-9a-fA-F' | xxd -r -p | wl-copy";
  }
  {
    key = "H";
    desc = "󱊧 Hex Encode";
    cmd = "wl-paste | xxd -p | tr -d '\n' | wl-copy";
  }
  {
    key = "6";
    desc = "󰻠 Base64 Decode";
    cmd = "wl-paste | base64 -d -i | wl-copy";
  }
  {
    key = "^";
    desc = "󰻠 Base64 Encode";
    cmd = "wl-paste | base64 -w 0 | wl-copy";
  }
  {
    key = "i";
    desc = " Convert To Bitmap";
    cmd = "wl-paste --type image/png | ${pkgs.imagemagick}/bin/convert - bmp:- | wl-copy --type image/bmp";
  }
]
