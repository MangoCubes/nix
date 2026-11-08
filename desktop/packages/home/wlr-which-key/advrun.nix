{ config, lib, ... }:
let
  japanese = ''
    d browser https://ja.dict.naver.com;
    d xournalpp;
  '';
in
[
  {
    key = "j";
    desc = "🇯🇵Japanese";
    cmd = japanese;
  }
  {
    key = "m";
    desc = " View Mail";
    cmd = config.custom.terminal.genCmd { command = "nvim -c 'NmSearch tag:inbox'"; };
  }
  {
    key = "d";
    desc = "󰃶 Create/Open Daily Note";
    cmd = config.custom.terminal.genCmd {
      command = "nvim ${config.home.homeDirectory}/Sync/Notes/Org/Daily/$(date +%F).org";
    };
  }
  {
    key = "b";
    desc = "󰖟 Open Blog Editor";
    cmd = config.custom.terminal.genCmd {
      command = "nvim ${config.home.homeDirectory}/Sync/Website/src/org/index.org";
    };
  }
  {
    key = "h";
    desc = "󱅙 Edit Android Home Note";
    cmd = config.custom.terminal.genCmd {
      command = "nvim ${config.home.homeDirectory}/Sync/Notes/MD/Android.md";
    };
  }
  {
    key = "a";
    desc = " Agenda";
    cmd = "qagenda";
  }
  {
    key = "M";
    desc = " Send email";
    cmd = config.custom.terminal.genCmd { command = "nvim-mailto"; };
  }
]
++ lib.optionals config.custom.windows [
  {
    key = "w";
    desc = " Run Windows";
    cmd = "run-windows";
  }
  {
    key = "W";
    desc = " Stop Windows";
    cmd = "sup podman-windows";
  }
]
