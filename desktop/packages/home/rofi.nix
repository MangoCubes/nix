{
  pkgs,
  colours,
  config,
  lib,
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
    package = pkgs.rofi;
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
  # A workaround for rofi-calc
  # Currently, rofi theme files are created under rofi/theme, but it also happens to be the location where rofi-calc history get saved
  # At the same time, rofi-calc seems to overwrite the symlink when the file is updated, breaking the sync
  # This code changes the theme file location, and symlinks the entire directory that stores the rofi-calc history
  xdg.dataFile = {
    "rofi/themes/custom.rasi".enable = lib.mkForce false;
    "rofi".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/rofi";
  };

  xdg.configFile."rofi/themes/custom.rasi".text = config.xdg.dataFile."rofi/themes/custom.rasi".text;
}
