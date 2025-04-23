{ lib, ... }:
{
  # I can't get it to use unfreeUnstable...
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
  programs.steam = {
    enable = true;
  };
}
