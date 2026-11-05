{ config, pkgs, ... }:
[
  {
    key = "t";
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
    key = "e";
    desc = "Encode";
    submenu = [
      {
        key = "h";
        desc = "󱊧 Hex Encode";
        cmd = "wl-paste | xxd -p | tr -d '\n' | wl-copy";
      }
      {
        key = "6";
        desc = "󰻠 Base64 Encode";
        cmd = "wl-paste | base64 -w 0 | wl-copy";
      }
    ];
  }
  {
    key = "d";
    desc = "Decode";
    submenu =
      let
        decode = cmd: ''
          if err=$(wl-paste | { ${cmd}; } 2>&1 >/dev/null); then
            wl-paste | { ${cmd}; } | wl-copy
          else
            ${pkgs.libnotify}/bin/notify-send "Decoding failed" "$err"
          fi
        '';
        force = cmd: "wl-paste | { ${cmd}; } 2>/dev/null | wl-copy";
        hex = "sed -E 's/0[xX]|\\x//g' | tr -cd '0-9a-fA-F' | xxd -r -p";
        base64 = "base64 -d -i";
      in
      [
        {
          key = "h";
          desc = "󱊧 Hex Decode";
          cmd = (decode hex);
        }
        {
          key = "H";
          desc = "󱊧 Force Hex Decode";
          cmd = (force hex);
        }
        {
          key = "6";
          desc = "󰻠 Base64 Decode";
          cmd = (decode base64);
        }
        {
          key = "^";
          desc = "󰻠 Force Base64 Decode";
          cmd = (force "tr -cd 'A-Za-z0-9+/' | ${base64}");
        }
      ];
  }
  {
    key = "h";
    desc = "Hash";
    submenu =
      let
        hash = algo: "wl-paste -n | ${algo}sum | cut -d' ' -f1 | tr -d '\n' | wl-copy";
      in
      [
        {
          key = "2";
          desc = "SHA256";
          cmd = (hash "sha256");
        }
        {
          key = "5";
          desc = "SHA512";
          cmd = (hash "sha512");
        }
        {
          key = "m";
          desc = "MD5";
          cmd = (hash "md5");
        }
      ];
  }
  {
    key = "i";
    desc = " Convert To Bitmap";
    cmd = "wl-paste --type image/png | ${pkgs.imagemagick}/bin/convert - bmp:- | wl-copy --type image/bmp";
  }
]
