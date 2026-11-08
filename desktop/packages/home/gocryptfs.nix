{
  pkgs,
  config,
  ...
}:
let
  mountDir = ''${config.custom.bookmarks.Secrets.path}'';
  encDir = ''${config.custom.bookmarks.Passwords.path}/Secrets'';
  unlockkeys = pkgs.writeShellScriptBin "unlockkeys" ''
    mkdir -p ${mountDir};
    ${pkgs.libnotify}/bin/notify-send GocryptFS "$(${pkgs.gocryptfs}/bin/gocryptfs -extpass '${pkgs.libsecret}/bin/secret-tool lookup Use GocryptFS_Secret_Encryption_Key' ${encDir} ${mountDir})";
  '';
in
{
  home.packages = [
    unlockkeys
    pkgs.gocryptfs
  ];
}
