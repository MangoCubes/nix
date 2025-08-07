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
    {
      key = "d";
      desc = "Development";
      cmd = ''profilebrowser Development'';
    }
    {
      key = "i";
      desc = "Intranet";
      cmd = ''profilebrowser Intranet'';
    }
  ];
in
theme // { inherit menu; }
