{
  username,
  config,
  device,
  lib,
  ...
}:
{
  home-manager.users."${username}" =
    { ... }:
    {
      imports = [ ../home/podman/syncthing.nix ];
    };
}
// (
  if (device == "server") then
    {
      custom.backups.backblaze = [
        "${config.users.users.${username}.home}/Sync"
      ];

    }
  else
    { }
)
