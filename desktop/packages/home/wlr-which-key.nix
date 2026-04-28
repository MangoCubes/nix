{
  pkgs,
  osConfig,
  unstable,
  config,
  colours,
  hostname,
  ...
}:
let
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
              hostname
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
    unstable.wlr-which-key
    pkgs.xclip
  ];

  xdg.configFile =
    (genFile "action")
    // (genFile "media")
    // (genFile "niri")
    // (genFile "browser")
    // (genFile "soundboard")
    // (genFile "dragevac")
    // (genFile "advrun");
}
