{ pkgs, ... }:
let
  detached = pkgs.writeShellScriptBin "t" ''d kitty bash'';
in
{
  programs.bash.shellAliases = {
    fastfetch = "fastfetch --logo ~/.config/configMedia/logo/nix.png --logo-type kitty-direct --logo-width 30 --logo-height 14";
  };
  home.packages = [
    detached
  ];
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = -1;
      # shell_integration = "enabled";
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 0;
      background_opacity = "0.5";
      background_blur = 5;
      cursor_trail = 1;
      font_family = ''family='FiraCode Nerd Font' style=Regular'';
      bold_font = ''auto'';
      italic_font = ''auto'';
      bold_italic_font = ''auto'';
    };
  };
}
