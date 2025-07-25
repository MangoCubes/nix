{ username, ... }:
{
  home-manager.users."${username}" =
    {
      pkgs,
      unfreeUnstable,
      unstable,
      ...
    }:
    {
      imports = [
        ../packages/home/factorio.nix
        ../packages/home/windows.nix
        ../packages/home/lutris.nix
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        unstable.webcord
        unstable.prismlauncher
        pkgs.feishin
        pkgs.xournalpp
      ];
    };
}
