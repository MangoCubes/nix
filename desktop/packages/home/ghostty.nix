{ unstable, pkgs, ... }:
let
  genCmd =
    {
      command,
      detached ? false,
      title ? "Terminal",
      ...
    }:
    let
      cmd = "ghostty --title ${title} -e ${command}";
    in
    (if detached then "d ${cmd}" else cmd);
  term = pkgs.writeShellScriptBin "term" (genCmd {
    command = "\"$@\"";
  });
  detached = pkgs.writeShellScriptBin "t" (genCmd {
    command = "bash";
    detached = true;
  });
in
{
  programs.bash.shellAliases = {
    fastfetch = "fastfetch --logo ~/.config/configMedia/logo/nix.png --logo-type kitty-direct --logo-width 30 --logo-height 14";
  };
  home.packages = [
    detached
    term
  ];
  imports = [ ./ghostty/options.nix ];
  custom.terminal = genCmd;
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
