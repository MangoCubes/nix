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
        # ../packages/home/factorio.nix
        ../packages/home/bottles.nix
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        unfreeUnstable.beeper
      ];
    };
}
