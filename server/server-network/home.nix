{ username, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unstable, ... }:
    {
      imports = [
        ../packages/home/podman/ca.nix
        ../packages/home/podman/netbird.nix
        ((import ../packages/home/podman/proton.nix) {
          name = "exit";
        })
      ];
    };
}
