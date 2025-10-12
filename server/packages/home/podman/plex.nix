{
  config,
  inputs,
  ...
}:
# Plex how to claim a server
# 1. Go to /config/Library/Application Support/Plex Media Server/Preferences.xml and get ProcessedMachineIdentifier value
# 2. Go to https://account.plex.tv/claim and get your claim token
# 3. Run the following command:
#    curl -X POST -s -H "X-Plex-Client-Identifier: {processed_machine_identifier}" "https://plex.tv/api/claim/exchange?token={claim_token}"
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [ "traefik" ];
      image = "lscr.io/linuxserver/plex:latest";
      name = "plex";
      volumes = [
        "${config.home.homeDirectory}/Mounts/media/Library/Anime:/media/Anime"
        "${config.home.homeDirectory}/Mounts/media/Library/Music:/media/Music"
        "${config.home.homeDirectory}/.podman/plex:/config"
      ];
      domain = [
        {
          routerName = "plex";
          type = 2;
          url = "media.local";
          port = 32400;
        }
      ];
      environment = {
        "PUID" = "1000";
        "PGID" = "1000";
        "TZ" = "Etc/UTC";
        "VERSION" = "docker";
      };
    })
  ];
}
