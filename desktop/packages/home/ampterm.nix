{ inputs, ... }:
{
  imports = [ inputs.ampterm.homeManager.default ];
  programs.ampterm = {
    enable = true;
    settings = {
      keybindings = {
        Common = {
          "<Ctrl-w><q>" = "Quit";
        };
      };
      use_legacy_auth = true;
      auto_focus = true;
      auth = {
        url = "echo https://music.skew.ch";
        username = "echo admin";
        password = "secret-tool lookup Path '/Ampache'";
      };
    };
  };
}
