{
  pkgs,
  config,
  lib,
  ...
}:
let
  unlockkeys = pkgs.writeShellScriptBin "unlockkeys" ''
    ${pkgs.gocryptfs}/bin/gocryptfs -extpass "rofi-input -p Unlock Keys" ${config.home.homeDirectory}/Sync/Passwords/Keys ${config.home.homeDirectory}/Mounts/Keys
  '';
in
{
  home.activation.keysmount = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/Mounts/Keys
  '';
  home.packages = [
    unlockkeys
    pkgs.gocryptfs
  ];
}
