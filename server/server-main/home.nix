{ username, ... }:
{
  home-manager.users."${username}" =
    { pkgs, unstable, ... }:
    {
      imports = [
        ../packages/home/podman/mariadb.nix
        ../packages/home/podman/ampache.nix
        ../packages/home/podman/ampache-test.nix
        ../packages/home/podman/nextcloud.nix
        ../packages/home/podman/matrix.nix
        ../packages/home/podman/redlib-vpn.nix
        ../packages/home/podman/searxng.nix
        ((import ../packages/home/podman/proton.nix) {
          name = "redlib";
          useInternalDns = true;
        })
        ((import ../packages/home/podman/anubis.nix) {
          url = "r.genit.al";
          port = 8080;
          target = "redlib-vpn";
        })
        ../packages/home/podman/phpmyadmin.nix
        ../packages/home/podman/atuin.nix
        ../packages/home/podman/postgresql.nix
        ../packages/home/podman/gitea.nix
        ../packages/home/podman/website.nix
        ../packages/home/podman/pgadmin.nix
        ../packages/home/podman/kavita.nix
        ../packages/home/podman/immich.nix
        # ../packages/home/podman/jellyfin.nix
        ../packages/home/podman/calibre.nix
        ../packages/home/podman/redis.nix
        ../packages/home/podman/collabora.nix
        ../packages/home/podman/firefly.nix
      ];
    };
}
