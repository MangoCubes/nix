{ username, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unfreeUnstable, ... }:
    {
      imports = [
        ../packages/home/obs.nix
        ../packages/home/factorio.nix
        ../packages/home/windows.nix
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
      ];
    };
}
