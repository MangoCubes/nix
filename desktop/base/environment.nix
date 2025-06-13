{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
    NIX_PROFILES = "${builtins.concatStringsSep " " (
      lib.lists.reverseList config.environment.profiles
    )}";
    # Not until drag-and-drop issue in VSCodium is fixed
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_PICTURES_DIR = "$HOME/Pictures";
  };
}
