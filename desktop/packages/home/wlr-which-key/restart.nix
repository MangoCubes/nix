{ config, ... }:
[
  {
    key = "a";
    desc = "AGS";
    cmd = "systemctl --user restart ags";
  }
  {
    key = "e";
    desc = " Emacs Server";
    cmd = config.custom.terminal.genCmd { command = "er"; };
  }
]
