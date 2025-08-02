let
  theme = (import ./theme.nix);
  player = ''-p $(ags request "player get")'';
  menu = [
    {
      key = "Right";
      desc = "󱇸 Skip 5 seconds";
      cmd = "playerctl ${player} position 5+";
      keep_open = true;
    }
    {
      key = "Left";
      desc = "󱇹 Rewind 5 seconds";
      cmd = "playerctl ${player} position 5-";
      keep_open = true;
    }
    {
      key = "Ctrl+Right";
      desc = " Skip";
      cmd = "playerctl ${player} next";
    }
    {
      key = "Ctrl+Left";
      desc = " Go Back";
      cmd = "playerctl ${player} previous";
    }
    {
      key = "Up";
      desc = "󰝝 Volume Up";
      cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02+";
      keep_open = true;
    }
    {
      key = "Down";
      desc = "󰝞 Volume Down";
      cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02-";
      keep_open = true;
    }
    {
      key = " ";
      desc = "󰐎 Play/Pause";
      cmd = "playerctl ${player} play-pause";
    }
    {
      key = "q";
      desc = "󰓛 Stop";
      cmd = "playerctl ${player} stop";
    }
    {
      key = "p";
      desc = "󰥠 Player";
      submenu = [
        {
          key = "Left";
          desc = "󰮳 Previous Player";
          cmd = ''ags request "player prev"'';
        }
        {
          key = "Right";
          desc = "󰮱 Next Player";
          cmd = ''ags request "player next"'';
        }
      ];
    }
  ];
in
theme // { inherit menu; }
