{ username, ... }:
{
  home-manager.users."${username}" =
    { unfreeUnstable, unstable, ... }:
    {
      imports = [
        ../packages/home/windows.nix
        ../packages/home/ghidra.nix
      ];
      home.packages = [
        unfreeUnstable.osu-lazer-bin
        unstable.ungoogled-chromium
        unstable.rustdesk-flutter
      ];
    };
}
