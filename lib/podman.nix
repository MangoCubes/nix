{
  activation ? "",
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
  autoStart ? true,
}:
{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:
# If domain = null, then it should not be accessible from outside
# URL is expected in the following form

let
  # This creates an executable bash script if the entrypoint is given
  # Entrypoint must be a single executable
  # To circumvent this limit, we create a bash script, and mount it onto the podman volume, and then set that script as an entrypoint
  start =
    # Of course, given that the entrypoint is provided
    if entrypoint == null then
      null
    else
      pkgs.writeScriptBin ''podman-start.sh'' ''
        #!/bin/sh
        ${entrypoint}'';
  # This is a function that automatically create Traefik labels
  genRouters =
    # [`entry`] is a set with the following attributes
    # {
    #   type = 1, 2, or 3; # 1: Globally accessible, 2: Locally named, 3: Local and automatically generated
    #   url = "something.url"
    #   routerName = "router" # Router name
    #   port = number # Port of the container
    # }
    entry:
    let
      useLocalCa =
        if (entry.type == 1) then
          { }
        else
          {
            # If type is not 1, then we are relying on local CA for generating certificates
            "traefik.http.routers.${entry.routerName}.tls.certResolver" = "localca";
          };
    in
    {
      # Set the URL
      "traefik.http.routers.${entry.routerName}.rule" = "Host(`${entry.url}`)";
      # Ensure traffic can only enter via HTTPS
      "traefik.http.routers.${entry.routerName}.entrypoints" = "websecure";
      # Explicitly mention the name of the service this allows access to
      "traefik.http.routers.${entry.routerName}.service" = "s-${entry.routerName}";
      # Enable HTTPS
      "traefik.http.routers.${entry.routerName}.tls" = "true";
      # Specify the port in the container the router routes the requests to
      "traefik.http.services.s-${entry.routerName}.loadbalancer.server.port" = (
        builtins.toString entry.port
      );
    }
    // useLocalCa;
  # Automatically create dependencies if dependsOn is specified
  # Note that dependencies are other containers
  deps = if dependsOn == null then [ ] else (builtins.map (e: "podman-${e}.service") dependsOn);
  # Specify extra arguments if there are any
  # DNS for the container is set using extra podman arguments
  args = extraPodmanArgs ++ (if dns == null then [ ] else [ "--dns=${dns}" ]);
  # We generate Traefik labels for each domain entry
  traefikLabels =
    if (domain == null) then
      { }
    else
      (builtins.foldl' (acc: elem: acc // elem) {
        "traefik.enable" = "true";
      } (builtins.map genRouters domain));

in
{
  custom.podman.containers = [ name ];
  # Automatically create directory for the container if it has volumes
  # Then run other commands specified via [`activation`]
  home.activation."podman-${name}" =
    if (builtins.length volumes != 0) then
      (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        DIR=${config.home.homeDirectory}/.podman/${name}
        if [ ! -d "$DIR" ]; then
          mkdir -p $DIR
        fi
        ${activation}
      '')
    else
      activation;
  services.podman.containers."${name}" = {
    # Mount entrypoint script as volume so that it exists within the container if specified
    volumes =
      if entrypoint == null then
        volumes
      else
        (
          volumes
          ++ [
            "${start}/bin/podman-start.sh:/my/podman-start.sh"
          ]
        );
    inherit
      environmentFile
      image
      network
      environment
      ports
      dropCapabilities
      addCapabilities
      devices
      exec
      autoStart
      ;
    # Set entrypoint if specified
    entrypoint = if entrypoint == null then null else "/my/podman-start.sh";
    extraConfig = {
      # Not setting this causes the container startup to be delayed by 90 seconds because the container dependencies are not satisfied
      Quadlet.DefaultDependencies = false;
      # Set dependencies so that the containers start only after certain containers are running
      Unit = {
        After = deps;
        Requires = deps;
      };
    };
    extraPodmanArgs = args;
    # autoUpdate = "registry";
    # If [`needRoot`], container is run as fakeroot (ie current user)
    user = if needRoot then 0 else null;
    labels = (if (domain == null) then { } else traefikLabels) // labels;
  };
}
