{ username, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unfreeUnstable, ... }:
    {
      imports = [
        ../packages/home/windows.nix
        ../packages/home/ghidra.nix
        ../packages/home/games.nix
      ];
      custom.microsoftTeams.enable = true;
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        pkgs.iw
      ];
    };
}
