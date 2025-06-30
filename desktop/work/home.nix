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
        ../packages/home/windows.nix
        ../packages/home/ghidra.nix
      ];
      home.packages = [
        unstable.webcord
        # Relies on EOLd version of electron and Nix is complaining
        # unstable.feishin
        unfreeUnstable.osu-lazer-bin
        unstable.gdb
      ];
    };
}
