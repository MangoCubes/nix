{ username, ... }:
{
  home-manager.users."${username}" =
    { ... }:
    {
      imports = [
        ../packages/home/podman/archive.nix
        ../packages/home/podman/android.nix
      ];
    };
}
