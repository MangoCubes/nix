{
  pkgs,
  ...
}:
let
  wlrWhichKey = import ./build/wlr-which-key.nix {
    inherit (pkgs)
      lib
      rustPlatform
      fetchFromGitHub
      pkg-config
      cairo
      glib
      libxkbcommon
      pango
      ;
  };
in
{
  home.packages = [
    wlrWhichKey
    pkgs.xclip
  ];

  xdg.configFile = {
    "wlr-which-key/config.yaml".source = (
      (pkgs.formats.yaml { }).generate "config.yml" (import ./wlr-which-key/config.nix)
    );
    "wlr-which-key/media.yaml".source = (
      (pkgs.formats.yaml { }).generate "media.yml" (import ./wlr-which-key/media.nix)
    );
  };
}
