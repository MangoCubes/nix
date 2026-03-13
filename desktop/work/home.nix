{ username, ... }:
{
  home-manager.users."${username}" =
    {
      pkgs,
      unstable,
      unfreeUnstable,
      unfree,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.secrets.hm.programs
        ../packages/home/windows.nix
        ../packages/home/ghidra.nix
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        unfree.beeper
      ];
    };
}
