{ username, unstable, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unfreeUnstable, ... }:
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
