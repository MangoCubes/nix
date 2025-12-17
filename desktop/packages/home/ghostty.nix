{ unstable, pkgs, ... }:
let
  term = pkgs.writeShellScriptBin "term" ''ghostty "$@"'';
  detached = pkgs.writeShellScriptBin "t" ''d ghostty bash'';
  dt = pkgs.writeShellScriptBin "dt" ''d ghostty bash -c "$*"'';
in
{
  programs.bash.shellAliases = {
    fastfetch = "fastfetch --logo ~/.config/configMedia/logo/nix.png --logo-type kitty-direct --logo-width 30 --logo-height 14";
  };
  home.packages = [
    detached
    term
    dt
  ];

  programs.ghostty = {
    enable = true;
    package = unstable.ghostty;
    settings = {
      font-family = "FiraCode Nerd Font";
      custom-shader-animation = true;
      custom-shader = [
        "${./ghostty/blaze.glsl}"
        "${./ghostty/trail.glsl}"
      ];
      background-opacity = 0.625;
      background-blur = true;
      background = "#000000";
      font-size = 10;
    };
  };
}
