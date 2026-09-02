{ inputs, ... }:
{
  imports = [ inputs.ampterm.homeManager.default ];
  programs.ampterm = {
    enable = true;
    settings = {
      auth = {
        url = "echo https://music.int";
        username = "echo admin";
        password = "secret-tool lookup Path '/Scripts/Navidrome'";
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
              id = "DhOLTZmLFxF92UW3PUfMpC";
              name = "Duplicate";
            };
          };
          "<s>" = {
            SelectID = {
              id = "Xbb77rVlHJAeIFylD9Wneu";
              name = "Short";
            };
          };
        };
      };
    };
  };
}
