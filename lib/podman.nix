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
  dependsOn ? [ ],
  exec ? null,
  dns ? null,
}:
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
  joinStr =
    array: connector:
    if (builtins.length array) == 0 then
      ""
    else if (builtins.length array) == 1 then
      (builtins.elemAt array 0)
    else
      (
        let
          head = builtins.head array;
          rest = builtins.tail array;
        in
        (builtins.foldl' (acc: elem: acc + connector + elem) head rest)
      );
  requires = "--requires=" + (joinStr dependsOn ",");
  args =
    extraPodmanArgs
    ++ (if (builtins.length dependsOn == 0) then [ ] else [ requires ])
    ++ (if dns == null then [ ] else [ "--dns=${dns}" ]);
  traefikLabels =
    if (domain == null) then
      { }
    else
      (builtins.foldl' (acc: elem: acc // elem) {
        "traefik.enable" = "true";
      } (builtins.map genRouters domain));
in
{
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
  extraConfig.Quadlet.DefaultDependencies = false;
  extraPodmanArgs = args;
  # autoUpdate = "registry";
  user = if needRoot then 0 else null;
  autoStart = true;
  labels = (if (domain == null) then { } else traefikLabels) // labels;
}
