let
  theme = (import ./theme.nix);
  menu = [
    {
      key = "Right";
      desc = "󱇸 Skip 5 seconds";
      cmd = "playerctl position 5+";
      keep_open = true;
    }
    {
      key = "Left";
      desc = "󱇹 Rewind 5 seconds";
      cmd = "playerctl position 5-";
      keep_open = true;
    }
    {
      key = "Ctrl+Right";
      desc = " Skip";
      cmd = "playerctl next";
    }
    {
      key = "Ctrl+Left";
      desc = " Go Back";
      cmd = "playerctl previous";
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
      cmd = "playerctl play-pause";
    }
    {
      key = "q";
      desc = "󰓛 Stop";
      cmd = "playerctl stop";
    }
  ];
in
theme // { inherit menu; }
