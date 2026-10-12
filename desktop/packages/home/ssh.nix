{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = true;
        SetEnv = {
          TERM = "xterm-256color";
        };
      };
    };
  };
}
