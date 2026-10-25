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
        ../packages/home/windows.nix
        ../packages/home/mitm-proxy.nix
        ../packages/home/games.nix
      ];
      custom.microsoftTeams.enable = true;
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        # unstable.webcord
        unstable.prismlauncher
        pkgs.xournalpp
      ];
    };
}
