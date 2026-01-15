{
  config,
  ...
}:
{
  imports = [
    ((import ../../../../lib/podman.nix) {
      dependsOn = [
        "traefik"
      ];
      image = "linuxserver/calibre:latest";
      name = "calibre";
      volumes = [
        "${config.home.homeDirectory}/.podman/calibre/Library:/Library"
        # Add new users with calibre-server --userdb=/Config/server-users.sqlite --manage-users
        "${config.home.homeDirectory}/.podman/calibre/Config:/Config"
      ];
      domain = [
        {
          routerName = "calibre";
          type = 1;
          url = "books.skew.ch";
          port = 9090;
        }
      ];
      exec = "calibre-server --enable-auth --port=9090 --userdb=/Config/server-users.sqlite --auth-mode=basic /Library";
    })
  ];
}
