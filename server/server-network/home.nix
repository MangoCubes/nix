{ username, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unstable, ... }:
    {
      imports = [
        ../packages/home/podman/ca.nix
      ];
    };
}
