{ username, ... }:
{
  home-manager.users."${username}" =
    {
      pkgs,
      unfreeUnstable,
      unstable,
      unfree,
      inputs,
      ...
    }:
    {
      imports = [
        ../packages/home/windows.nix
        ((import ../packages/home/lutris.nix) { games = true; })
        ../packages/home/mitm-proxy.nix
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        # unstable.webcord
        unstable.prismlauncher
        pkgs.xournalpp
        unfree.beeper
        inputs.cwcwm.packages."${pkgs.stdenv.hostPlatform.system}".default
      ];
    };
}
