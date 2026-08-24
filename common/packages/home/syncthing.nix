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
  st-default-folder =
    let
      syncthingDir = "\${XDG_STATE_HOME:-$HOME/.local/state}/syncthing";
      syncthingDirShell = ''
        syncthing_state_dir="${syncthingDir}"
        syncthing_config_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/syncthing"

        if [[ -e "$syncthing_state_dir/config.xml" || ! -e "$syncthing_config_dir/config.xml" ]]; then
            syncthing_dir="$syncthing_state_dir"
        else
            syncthing_dir="$syncthing_config_dir"
        fi
      '';
    in
    pkgs.writeShellScript "st-default-folder" ''
      	${syncthingDirShell}
      	config_file="$syncthing_dir/config.xml"
      	if [[ ! -f "$config_file" ]]; then
      		echo "Error: Syncthing config.xml not found at $config_file"
      		exit 1
      	fi

      	dirs=($(find ${syncPath} -mindepth 1 -maxdepth 1 -type d))
      	for dir in "''${dirs[@]}"; do
      		cd "$dir"
      		[ ! -f ./.ignore.txt ] && touch ./.ignore.txt
      	done

      	API_KEY=$(${pkgs.libxml2}/bin/xmllint --xpath 'string(configuration/gui/apikey)' "$config_file")
      	
      	while ! ${pkgs.curl}/bin/curl -f http://localhost:8384/rest/noauth/health; do ${pkgs.coreutils}/bin/sleep 1; done;
      	${pkgs.curl}/bin/curl -X PATCH -H "X-API-Key: $API_KEY" -H "Content-Type: application/json" -d '{"path": "${syncPath}"}' http://localhost:8384/rest/config/defaults/folder
      	${pkgs.curl}/bin/curl -X PUT   -H "X-API-Key: $API_KEY" -H "Content-Type: application/json" -d '{"lines": ["#include ./.ignore.txt"]}' http://localhost:8384/rest/config/defaults/ignores
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
