{
  pkgs,
  lib,
  colours,
  config,
  ...
}:
{
  home.packages = [
    (import ./rofi/search/rofi-engines.nix {
      inherit pkgs;
      inherit lib;
    })
    (import ./rofi/rofi-browser.nix {
      inherit pkgs;
      inherit lib;
    })
    (import ./rofi/rofi-removable.nix { inherit pkgs; })
    (import ./rofi/search/rofi-search.nix { inherit pkgs; })
    (import ./rofi/search/rofi-input.nix { inherit pkgs; })
    (import ./rofi/rofi-env.nix { inherit pkgs; })
  ];
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,ssh";
      display-drun = "󰀻 Apps ";
      display-ssh = "󰣀 SSH ";
      drun-display-format = "{icon} {name}";
      display-calc = "󰪚 Calc ";
      show-icons = true;
    };
    package = pkgs.rofi-wayland;
    terminal = "kitty";
    plugins = [
      pkgs.rofi-calc
      pkgs.rofi-emoji
    ];
    theme = (import ./rofi/rofi-theme.nix) {
      inherit config;
      inherit colours;
    };
    cycle = true;
  };
}
