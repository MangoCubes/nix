{ username, unstable, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unfreeUnstable, ... }:
    {
      imports = [
        ../packages/home/factorio.nix
        ../packages/home/windows.nix
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        unstable.krita
        unstable.gdb
      ];
    };
}
