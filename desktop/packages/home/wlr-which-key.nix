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
  genFile = name: {
    "wlr-which-key/${name}.yaml".source = (
      (pkgs.formats.yaml { }).generate "${name}.yml" (import ./wlr-which-key/${name}.nix)
    );
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
  }
  // (genFile "media")
  // (genFile "autosetup")
  // (genFile "niri")
  // (genFile "qute")
  // (genFile "advrun");
}
