{ inputs, ... }:
{
  imports = [ inputs.ampterm.homeManager.default ];
  programs.ampterm = {
    enable = true;
    settings = {
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
      local = {
        select_playlist_popup = {
          "<d>" = {
            SelectID = {
              id = "800000014";
              name = "Duplicate";
            };
          };
          "<c>" = {
            SelectID = {
              id = "800000016";
              name = "Too Calm";
            };
          };
          "<s>" = {
            SelectID = {
              id = "800000009";
              name = "Short";
            };
          };
          "<n>" = {
            SelectID = {
              id = "800000015";
              name = "Not My Style";
            };
          };
        };
      };
    };
  };
}
