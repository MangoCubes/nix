{
  config,
  lib,
  device,
  inputs,
  pkgs,
  ...
}:
let
  st-clear = pkgs.writeShellScriptBin "st-clear" (builtins.readFile ./syncthing/st-clear.sh);
  st-reset-database = pkgs.writeShellScriptBin "st-reset-database" ''
    syncthing debug reset-database;
    systemctl --user restart syncthing
  '';
in
{
  services.syncthing = {
    enable = true;
  };
  imports = [
    (inputs.secrets.hm.syncthing { isServer = device.type == "server"; })
  ];
  home = {
    packages = [
      st-clear
      st-reset-database
    ];
    activation.syncthing = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${config.home.homeDirectory}/Sync
    '';
  };
}
# // (
#   if (device.type == "server") then
#     {
#       custom.backups.backblaze = [
#         "${config.home.homeDirectory}/Sync"
#       ];
#     }
#   else
#     { }
# )
