{ inputs, ... }:
{
  imports = [ inputs.ampterm.homeManager.default ];
  programs.ampterm = {
    enable = true;
    extraOptions = {
      auth = {
        url = "echo https://music.skew.ch";
        username = "echo admin";
        password = "secret-tool lookup Path '/Ampache'";
      };
      use_legacy_auth = true;
      behaviour.auto_focus = true;
      features = {
        lyrics.enable = true;
        bpmtoy.enable = true;
        cover_art.enable = true;
      };
    };
  };
}
