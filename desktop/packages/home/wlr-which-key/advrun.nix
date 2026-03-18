{ config, ... }:
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
    cmd = "emacs-mail";
  }
  {
    key = "d";
    desc = "󰃶 Create/Open Emacs Daily";
    cmd = "emacs-daily";
  }
  {
    key = "b";
    desc = "󰖟 Open Blog Editor";
    cmd = "emacs-web";
  }
  {
    key = "a";
    desc = "󱅙 Edit Android Home Note";
    cmd = config.custom.terminal.genCmd { command = "nvim ~/Sync/Notes/MD/Android.md"; };
  }
  {
    key = "e";
    desc = " Emacs";
    submenu = [
      {
        key = "r";
        desc = " Restart Emacs";
        cmd = config.custom.terminal.genCmd { command = "er"; };
      }
    ];
  }
]
++ (
  if config.custom.features.windows then
    [
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
  else
    [ ]
)
