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
  st-default-folder = pkgs.writeShellScript "st-default-folder" (
    builtins.replaceStrings
      [ "@apiKeyPath@" "@syncPath@" "@xmlstarlet@" ]
      [ config.sops.secrets.syncthing-apikey.path syncPath "${pkgs.xmlstarlet}/bin/xmlstarlet" ]
      (builtins.readFile ./syncthing/st-default-folder.sh)
  );
in
{
  services.syncthing = {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
    guiAddress = "0.0.0.0:8384";
  };
  imports = [
    inputs.secrets.hm.syncthing
  ];
  systemd.user.services.st-default-folder = {
    Unit = {
      Description = "Set Syncthing default folder path";
      After = [ "syncthing.service" ];
      Requires = [ "syncthing.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${st-default-folder}";
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
