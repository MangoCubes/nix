{ username, ... }:
{
  home-manager.users."${username}" =
    { unfreeUnstable, ... }:
    {
      imports = [
        ../packages/home/windows.nix
        ../packages/home/ghidra.nix
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
      ];
    };
}
