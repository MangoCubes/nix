{ username, ... }:
{
  home-manager.users."${username}" =
    {
      pkgs,
      unstable,
      unfreeUnstable,
      ...
    }:
    {
      imports = [
        ../packages/home/factorio.nix
        ../packages/home/windows.nix
        ((import ../packages/home/lutris.nix) { games = false; })
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        unstable.webcord
      ];
    };
}
