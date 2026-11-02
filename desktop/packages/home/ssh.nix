{ config, ... }: {
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
      "git.int" = {
        User = "git";
        Port = 2222;
        IdentityFile = config.custom.keys.gitea;
        IdentitiesOnly = true;
      };
    };
  };
}
