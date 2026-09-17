{ username, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unstable, ... }:
    {
      home.sessionVariables = {
        TERM = "xterm-256color";
      };
    };
}
