{ username, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unstable, ... }:
    {
      imports = [
      ];
      home.sessionVariables = {
        TERM = "xterm-256color";
      };
    };
}
