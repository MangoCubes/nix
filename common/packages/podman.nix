{
  username,
  pkgs,
  ...
}:
{
  virtualisation.containers.enable = true;
  virtualisation.podman.enable = true;
  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      dive # look into podman image layers
      podman-tui # status of containers in the terminal
      podman-compose # start group of containers for dev
      slirp4netns
      rootlesskit
    ];
    services.podman = {
      autoUpdate.enable = true;
      enable = true;
      settings.containers = {
        network.default_rootless_network_cmd = "slirp4netns";
      };
    };
    programs.bash.shellAliases = {
      pcu = "podman compose up -d";
      pcul = "podman compose up -d && podman compose logs -f";
      pcl = "podman compose logs -f";
      pcd = "podman compose down";
      pcdv = "podman compose down -v";
      pcr = "podman compose restart";
      pcrv = "podman compose down -v && podman compose up -d";
      pcrvl = "podman compose down -v && podman compose up -d && podman compose logs -f";
    };
  };
}
