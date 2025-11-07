{ config, pkgs, ... }:
let
  mergepasswords = pkgs.writeShellScriptBin "mergepasswords" ''
    PATTERN="Passwords.sync-conflict-*.kdbx"
    for file in "${config.home.homeDirectory}/Sync/Passwords"/$PATTERN; do
        if [[ -f "$file" ]]; then
            echo "Processing file: $file"
            keepassxc-cli merge -s "${config.home.homeDirectory}/Sync/Passwords/Passwords.kdbx" "$file"
        fi
    done
  '';
in
{
  xdg.configFile."keepassxc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/keepassxc";
  home.packages = [
    pkgs.keepassxc
    pkgs.libsecret
    mergepasswords
  ];
}
