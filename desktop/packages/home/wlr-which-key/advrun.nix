let
  theme = (import ./theme.nix);
  menu = [
    {
      key = "m";
      desc = "  View Mail";
      cmd = ''env DISPLAY=:0 emacsclient -c -e '(notmuch-search "tag:inbox")' '';
    }
    {
      key = "w";
      desc = "  Run Windows";
      cmd = ''run-windows'';
    }
  ];
in
theme // { inherit menu; }
