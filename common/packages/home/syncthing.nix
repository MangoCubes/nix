{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  syncPath = "${config.home.homeDirectory}/Sync";
  st-clear = pkgs.writeShellScriptBin "st-clear" (builtins.readFile ./syncthing/st-clear.sh);
  st-reset-database = pkgs.writeShellScriptBin "st-reset-database" ''
    syncthing debug reset-database;
    systemctl --user restart syncthing
  '';
  st-default-folder = pkgs.writeShellScript "st-default-folder" ''
    while ! curl -f http://localhost:8384/rest/noauth/health; do sleep 1; done;
    API_KEY=${config.services.syncthing.settings.gui.apikey}
    ${pkgs.curl}/bin/curl -X PATCH -H "X-API-Key: $API_KEY" -H "Content-Type: application/json" -d '{"path": "${syncPath}"}' http://localhost:8384/rest/config/defaults/folder
  '';
in
{
  services.syncthing = {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
  };
  imports = [
    inputs.secrets.hm.syncthing
  ];
  systemd.user.services.st-default-folder = {
    Unit = {
      Description = "Set Syncthing default folder path";
      After = [ "syncthing.service" ];
      PartOf = [ "syncthing.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${st-default-folder}";
    };
    Install = {
      WantedBy = [ "syncthing.service" ];
    };
  };
  home = {
    packages = [
      st-clear
      st-reset-database
    ];
    activation.syncthing = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${syncPath}
    '';
  };
}
