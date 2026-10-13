{ username, ... }:
{
  home-manager.users."${username}" =
    { ... }:
    {
      imports = [
        ../packages/home/podman/ca.nix
        ../packages/home/podman/netbird.nix
      ];
    };
}
