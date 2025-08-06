let
  theme = (import ./theme.nix);
  menu = [
    {
      key = "s";
      desc = "School";
      cmd = ''profilebrowser School'';
    }
    {
      key = "h";
      desc = "SelfHosted";
      cmd = ''profilebrowser SelfHosted'';
    }
  ];
in
theme // { inherit menu; }
