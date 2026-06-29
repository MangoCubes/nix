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
        ../packages/home/mitm-proxy.nix
        ../packages/home/lutris.nix
      ];
      custom.microsoftTeams.enable = true;
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        # unstable.webcord
        unstable.prismlauncher
        pkgs.xournalpp
        unfree.beeper
        pkgs.audacity
        inputs.cwcwm.packages."${pkgs.stdenv.hostPlatform.system}".default
      ];
    };
}
