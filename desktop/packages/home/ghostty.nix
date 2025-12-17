{ unstable, pkgs, ... }:
let
  genCmd =
    {
      command ? null,
      detached ? false,
      title ? null,
      ...
    }:
    let
      flags = [
        (if title == null then "" else "--title ${title}")
        (if command == null then "" else "-e ${command}")
      ];
      cmd = "ghostty ${(builtins.concatStringsSep " " flags)}";
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
  custom.terminal = {
    program = "ghostty";
    inherit genCmd;
  };
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
