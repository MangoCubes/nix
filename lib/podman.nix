{
  network ? "proxy",
  name,
  volumes ? [ ],
  ports ? [ ],
  environment ? { },
  image,
  domain ? null,
  user ? null,
  entrypoint ? null,
  environmentFile ? [ ],
  labels ? { },
  dropCapabilities ? [ ],
  extraPodmanArgs ? [ ],
  addCapabilities ? [ ],
  devices ? [ ],
  needRoot ? false,
  dependsOn,
  exec ? null,
  dns ? null,
}:
{ lib, ... }:
# If domain = null, then it should not be accessible from outside
# URL is expected in the following form
# {
#   type = 1, 2, or 3; # 1: Globally accessible, 2: Locally named, 3: Local and automatically generated
#   url = "something.url"
#   routerName = "router" # Router name
#   port = number # Port of the container
# }

let
  genRouters =
    entry:
    let
      useLocalCa =
        if (entry.type == 1) then
          { }
        else
          {
            "traefik.http.routers.${entry.routerName}.tls.certResolver" = "localca";
          };
    in
    {
      "traefik.http.routers.${entry.routerName}.rule" = "Host(`${entry.url}`)";
      "traefik.http.routers.${entry.routerName}.entrypoints" = "websecure";
      "traefik.http.routers.${entry.routerName}.service" = "s-${entry.routerName}";
      "traefik.http.routers.${entry.routerName}.tls" = "true";
      "traefik.http.services.s-${entry.routerName}.loadbalancer.server.port" = (
        builtins.toString entry.port
      );
    }
    // useLocalCa;
  deps = if dependsOn == null then [ ] else (builtins.map (e: "podman-${e}.service") dependsOn);
  args = extraPodmanArgs ++ (if dns == null then [ ] else [ "--dns=${dns}" ]);
  traefikLabels =
    if (domain == null) then
      { }
    else
      (builtins.foldl' (acc: elem: acc // elem) {
        "traefik.enable" = "true";
      } (builtins.map genRouters domain));
in
{
  services.podman.containers."${name}" = {
    inherit
      environmentFile
      image
      network
      environment
      volumes
      ports
      entrypoint
      dropCapabilities
      addCapabilities
      devices
      exec
      ;
    extraConfig = {
      # Not setting this causes the container startup to be delayed by 90 seconds because the container dependencies are not satisfied
      Quadlet.DefaultDependencies = false;
      # This ensures that the containers start only after certain containers are running
      Unit = {
        After = deps;
        Requires = deps;
      };
    };
    extraPodmanArgs = args;
    # autoUpdate = "registry";
    user = if needRoot then 0 else null;
    labels = (if (domain == null) then { } else traefikLabels) // labels;
  };
}
