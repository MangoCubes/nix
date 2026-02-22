{ username, ... }:
{
  home-manager.users."${username}" =
    {
      pkgs,
      unstable,
      unfree,
      unfreeUnstable,
      ...
    }:
    {
      imports = [
        ../packages/home/bottles.nix
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        unfree.beeper
      ];
    };
}
