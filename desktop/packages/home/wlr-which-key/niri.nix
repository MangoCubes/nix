let
  theme = (import ./theme.nix);
  menu = [
    {
      key = "f";
      desc = "Fullscreen";
      cmd = ''niri msg action fullscreen-window'';
    }
    {
      key = "o";
      desc = "Overview";
      cmd = ''niri msg action toggle-overview'';
    }
  ];
in
theme // { inherit menu; }
