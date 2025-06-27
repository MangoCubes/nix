{
  config,
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
  ];

  xdg.configFile."wlr-which-key/config.yaml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/wlr-which-key/config.yaml";
}
