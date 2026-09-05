{
  pkgs,
  osConfig,
  unstable,
  config,
  colours,
  hostname,
  inputs,
  ...
}:
let
  genFile = name: list: {
    "wlr-which-key/${name}.yaml".source = (
      ((pkgs.formats.yaml { }).generate "${name}.yml" (
        {
          menu = (
            list {
              inherit
                colours
                pkgs
                config
                osConfig
                hostname
                ;
            }
          );
        }
        // ((import ./wlr-which-key/theme.nix) {
          inherit
            colours
            pkgs
            config
            osConfig
            ;
        })
      ))
    );
  };
  loadFile = name: (genFile name (import ./wlr-which-key/${name}.nix));
in
{
  home.packages = [
    unstable.wlr-which-key
    pkgs.xclip
  ];

  xdg.configFile =
    (loadFile "action")
    // (loadFile "media")
    // (loadFile "niri")
    // (loadFile "browser")
    // (loadFile "soundboard")
    // (loadFile "dragevac")
    // (genFile "auto" inputs.secrets.hm.wlr-which-key.auto)
    // (loadFile "advrun");
}
