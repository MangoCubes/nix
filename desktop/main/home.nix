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
      ];
      custom.microsoftTeams.enable = true;
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        unstable.prismlauncher
        pkgs.xournalpp
      ];
    };
}
