{ username, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unfreeUnstable, ... }:
    {
      imports = [
        ../packages/home/factorio.nix
        ../packages/home/winapps.nix
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
      ];
    };
}
