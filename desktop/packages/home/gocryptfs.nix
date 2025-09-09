{
  pkgs,
  config,
  ...
}:
let
  mountDir = ''${config.home.homeDirectory}/Mounts/Secrets'';
  encDir = ''${config.home.homeDirectory}/Sync/Passwords/Secrets'';
  unlockkeys = pkgs.writeShellScriptBin "unlockkeys" ''
    mkdir -p ${mountDir};
    ${pkgs.gocryptfs}/bin/gocryptfs -extpass "rofi-input -p Unlock Secrets" ${encDir} ${mountDir};
  '';
in
{
  home.packages = [
    unlockkeys
    pkgs.gocryptfs
  ];
}
