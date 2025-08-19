let
  theme = (import ./theme.nix);
  menu = [
    {
      key = "m";
      desc = " View Mail";
      cmd = ''emacs-mail'';
    }
    {
      key = "W";
      desc = " Run Windows";
      cmd = ''run-windows'';
    }
    {
      key = "b";
      desc = "󰖟 Open Blog Editor";
      cmd = ''emacs-web'';
    }
  ];
in
theme // { inherit menu; }
