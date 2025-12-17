{ unstable, ... }:
{
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
