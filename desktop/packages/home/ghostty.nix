{ unstable, pkgs, ... }:
let
  genCmdList =
    {
      command ? null,
      detached ? false,
      title ? null,
      workingDirectory ? null,
      ...
    }:
    (if detached then [ "d" ] else [ ])
    ++ [ "ghostty" ]
    ++ (if workingDirectory == null then [ ] else [ "--working-directory=${workingDirectory}" ])
    ++ (if title == null then [ ] else [ "--title=${title}" ])
    ++ (
      if command == null then
        [ ]
      else
        [
          "-e"
          "sh"
          "-c"
          ''"${command}"''
        ]
    );
  genCmd =
    {
      command ? null,
      detached ? false,
      title ? null,
      workingDirectory ? null,
    }:
    builtins.concatStringsSep " " (genCmdList {
      inherit
        command
        detached
        title
        workingDirectory
        ;
    });
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
    inherit genCmdList;
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
