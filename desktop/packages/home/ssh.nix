{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          SetEnv = "TERM=xterm-256color";
        };
      };
    };
  };
}
