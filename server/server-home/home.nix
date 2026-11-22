{ username, ... }:
{
  home-manager.users."${username}" =
    { config, ... }:
    {
      imports = [
        ../packages/home/podman/archive.nix
        ../packages/home/podman/android.nix
      ];
      custom.backups.backblaze = [ config.custom.bookmarks.Sync.path ];
    };
}
