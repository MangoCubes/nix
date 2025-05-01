{ username, ... }:
{
  home-manager.users."${username}" =
    {
      pkgs,
      unstable,
      unfreeUnstable,
      inputs,
      ...
    }:
    {
      imports = [
        ../packages/home/obs.nix
        ../packages/home/winapps.nix
      ];
      home.packages = [
        unstable.webcord
        unstable.feishin
        unfreeUnstable.osu-lazer-bin
        pkgs.ghidra
      ];
    };
}
