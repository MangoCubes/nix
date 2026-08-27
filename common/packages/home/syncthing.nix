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

      API_KEY=$(< ${config.sops.secrets.syncthing-apikey.path})

      ${pkgs.xmlstarlet}/bin/xmlstarlet ed -L -u "/configuration/gui/apikey" -v $API_KEY "$config_file"
      ${pkgs.xmlstarlet}/bin/xmlstarlet ed -L -u "/configuration/defaults/folder/@path" -v "${syncPath}" "$config_file"
      ${pkgs.xmlstarlet}/bin/xmlstarlet ed -L -u "/configuration/defaults/ignores/line" -v "#include ./.ignore.txt" "$config_file"
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
