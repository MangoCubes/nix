{ username, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unstable, ... }:
    {
      imports = [
        ../packages/home/podman/mariadb.nix
        ../packages/home/podman/ampache.nix
        ../packages/home/podman/nextcloud.nix
        ../packages/home/podman/matrix.nix
        ../packages/home/podman/redlib-vpn.nix
        ../packages/home/podman/searxng.nix
        ((import ../packages/home/podman/proton.nix) { name = "redlib"; })
        # ((import ../packages/home/podman/proton.nix) { name = "inv"; })
        ../packages/home/podman/phpmyadmin.nix
        # ../packages/home/podman/invidious.nix
        ../packages/home/podman/postgresql.nix
        # ../packages/home/podman/mitmproxy.nix
        # ../packages/home/podman/lemmy.nix
        ../packages/home/podman/pgadmin.nix
        ../packages/home/podman/kavita.nix
        ../packages/home/podman/redis.nix
      ];
    };
}
