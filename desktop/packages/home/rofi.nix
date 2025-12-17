{
  pkgs,
  colours,
  config,
  ...
}:
{
  imports = [
    ./rofi/rofi-simplelogin.nix
    ./rofi/search/rofi-engines.nix
    ./rofi/rofi-browser.nix
    ./rofi/rofi-removable.nix
    ./rofi/search/rofi-search.nix
    ./rofi/rofi-input.nix
    ./rofi/rofi-env.nix
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
    terminal = config.custom.terminal.program;
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
