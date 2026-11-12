{
  custom.podman.containers.calibre = {
    image = "linuxserver/calibre:latest";
    mounts = [
      {
        inside = "/Library";
        outside = "calibre/Library";
      }
      # Add new users with calibre-server --userdb=/Config/server-users.sqlite --manage-users
      {
        inside = "/Config";
        outside = "calibre/Config";
      }
    ];
    domain = [
      {
        url = "books.skew.ch";
        port = 9090;
      }
    ];
    exec = "calibre-server --enable-auth --port=9090 --userdb=/Config/server-users.sqlite --auth-mode=basic /Library";
  };
}
