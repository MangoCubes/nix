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
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        unstable.webcord
      ];
    };
}
