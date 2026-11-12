{
  custom.podman.containers.search = {
    image = "searxng/searxng:latest";
    domain = [
      {
        url = "genit.al";
        port = 8080;
      }
    ];
    mounts = [
      {
        inside = "/etc/searxng";
        outside = "searxng";
      }
    ];
  };
}
