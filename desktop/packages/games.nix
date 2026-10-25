{ username, unfreeUnstable, ... }:
{
  programs.steam = {
    enable = true;
    package = unfreeUnstable.steam;
  };
  home-manager.users."${username}" =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    {
      imports = [
        inputs.steam-config-nix.homeModules.default
        inputs.secrets.desktop.packages.home.wine-imefix
      ];

      programs.steam.config = {
        enable = true;
        apps."1049590".name = "Eternal Return";
        nonSteamApps."Battle.net" =
          let
            prefix = "${config.home.homeDirectory}/Games/battlenet";
          in
          {
            target = "${prefix}/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe";
            prefixPath = prefix;
            compatTool = pkgs.proton-ge-bin;
            dllOverrides.locationapi = "disabled";
            env = {
              DXVK_HUD = "compiler";
              DXVK_STATE_CACHE_PATH = prefix;
              STAGING_SHARED_MEMORY = 1;
              __GL_SHADER_DISK_CACHE = 1;
              __GL_SHADER_DISK_CACHE_PATH = prefix;
              __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
            };
          };
      };
    };
}
