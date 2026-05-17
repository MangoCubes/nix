{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions = {
          SetEnv = "TERM=xterm-256color";
        };
      };
    };
  };
}
