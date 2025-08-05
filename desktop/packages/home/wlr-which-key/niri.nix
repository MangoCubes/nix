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
    {
      key = "t";
      desc = "Tabbed Display";
      cmd = ''toggle-column-tabbed-display'';
    }
  ];
in
theme // { inherit menu; }
