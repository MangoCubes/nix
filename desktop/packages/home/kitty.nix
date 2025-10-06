{ pkgs, ... }:
let
  term = pkgs.writeShellScriptBin "term" ''kitty "$@"'';
  detached = pkgs.writeShellScriptBin "t" ''d kitty bash'';
  dt = pkgs.writeShellScriptBin "dt" ''d kitty bash -c "$*"'';
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
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+n" = "no_op";
      # Move the active window to the indicated screen edge
      "ctrl+shift+alt+up" = "layout_action move_window top";
      "ctrl+shift+alt+left" = "layout_action move_window left";
      "ctrl+shift+alt+right" = "layout_action move_window right";
      "ctrl+shift+alt+down" = "layout_action move_window bottom";

      # Switch focus to the neighboring window in the indicated direction
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "ctrl+shift+up" = "neighboring_window up";
      "ctrl+shift+down" = "neighboring_window down";

      "ctrl+shift+," = "previous_tab";
      "ctrl+shift+." = "next_tab";
    };
    settings = {
      confirm_os_window_close = -1;
      # shell_integration = "enabled";
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 0;
      background_opacity = "0.625";
      background_blur = 20;
      cursor_trail = 1;
      font_family = ''family='FiraCode Nerd Font' style=Regular'';
      bold_font = ''auto'';
      italic_font = ''auto'';
      bold_italic_font = ''auto'';
    };
  };
}
