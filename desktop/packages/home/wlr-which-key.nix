{
  pkgs,
  osConfig,
  config,
  colours,
  ...
}:
let
  # I am building from source because 1.2.0 is not on NixOS packages yet
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
      (pkgs.formats.yaml { }).generate "${name}.yml" (
        {
          menu = (import ./wlr-which-key/${name}.nix) {
            inherit
              colours
              pkgs
              config
              osConfig
              ;
          };
        }
        // ((import ./wlr-which-key/theme.nix) {
          inherit
            colours
            pkgs
            config
            osConfig
            ;
        })
      )
    );
  };
in
{
  home.packages = [
    wlrWhichKey
    pkgs.xclip
  ];

  xdg.configFile =
    (genFile "action")
    // (genFile "media")
    // (genFile "autosetup")
    // (genFile "niri")
    // (genFile "qute")
    // (genFile "advrun");
}
