{
  pkgs,
  osConfig,
  config,
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
    "wlr-which-key/action.yaml".source = (
      (pkgs.formats.yaml { }).generate "action.yml" (
        (import ./wlr-which-key/action.nix) { inherit config osConfig; }
      )
    );
    "wlr-which-key/media.yaml".source = (
      (pkgs.formats.yaml { }).generate "media.yml" (import ./wlr-which-key/media.nix)
    );
    "wlr-which-key/advrun.yaml".source = (
      (pkgs.formats.yaml { }).generate "advrun.yml" (import ./wlr-which-key/advrun.nix)
    );
  };
}
