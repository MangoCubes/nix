{
  config,
  pkgs,
  lib,
  ...
}:
let
  query =
    url:
    "INSERT INTO moz_perms (origin, type, permission, expireType, expireTime, modificationTime) SELECT '${url}', 'cookie', 1, 0, 0, 0 WHERE NOT EXISTS (SELECT 1 FROM moz_perms WHERE origin = '${url}' AND type = 'cookie' AND modificationTime = 0);";
  dbPath =
    profile:
    "${config.home.homeDirectory}/.floorp/${
      config.programs.floorp.profiles.${profile}.path
    }/permissions.sqlite";
  command =
    profile: url: ''${pkgs.sqlite}/bin/sqlite3 ${(dbPath profile)} "${(query url)}" || true;'';
  profiles = builtins.attrNames config.programs.floorp.profiles;
  perProfile =
    profile:
    if (builtins.hasAttr profile config.custom.browser) then
      (builtins.map (url: (command profile url)) config.custom.browser.${profile}.trustedUrls)
    else
      [ ];
  commands = builtins.concatLists (builtins.map perProfile profiles);
in
{
  home.activation.trustedUrls = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    builtins.concatStringsSep "\n" commands
  );
}
