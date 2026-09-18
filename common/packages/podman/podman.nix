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
  autoStart ? true,
  daily ? null,
  ip4 ? null,
}:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  # If domain = null, then it should not be accessible from outside
  # URL is expected in the following form
  # This creates an executable bash script if the entrypoint is given
  # Entrypoint must be a single executable
  # To circumvent this limit, we create a bash script, and mount it onto the podman volume, and then set that script as an entrypoint
  start =
    # Of course, given that the entrypoint is provided
    if entrypoint == null then
      null
    else
      pkgs.writeScriptBin "podman-start.sh" ''
        #!/bin/sh
        ${entrypoint}'';
  # This is a function that automatically create Traefik labels
  genRouters =
    # [`entry`] is a set with the following attributes
    # {
    #   url = "something.url"
    #   routerName = "router" # Router name
    #   port = number # Port of the container
    # }
    entry:
    let
      certResolver =
        if (lib.hasSuffix ".local" entry.url || lib.hasSuffix ".int" entry.url) then
          "localca"
        else
          "letsencrypt";
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
      "traefik.http.routers.${entry.routerName}.tls.certResolver" = certResolver;
      # Specify the port in the container the router routes the requests to
      "traefik.http.services.s-${entry.routerName}.loadbalancer.server.port" = (
        builtins.toString entry.port
      );
    };
  # Automatically create dependencies if dependsOn is specified
  # Note that dependencies are other containers
  deps = (if dependsOn == null then [ ] else (builtins.map (e: "podman-${e}.service") dependsOn)) ++ [
    "podman.socket"
  ];
  # We generate Traefik labels for each domain entry
  traefikLabels =
    if (domain == null) then
      { }
    else
      (builtins.foldl' (acc: elem: acc // elem) {
        "traefik.enable" = "true";
      } (builtins.map genRouters domain));
  dailyBackup =
    if (daily != null) then
      {
        timers."podman-${name}-daily" = {
          Install.WantedBy = [ "timers.target" ];
          Timer = {
            OnBootSec = "6h";
            OnUnitActiveSec = "6h";
            Unit = "podman-${name}-daily.service";
          };
          Unit.Description = "Timer for podman-${name}-daily.service";
        };
        services."podman-${name}-daily" = {
          Unit.Description = "Backup preparation command for ${name}";
          Service = {
            Type = "oneshot";
            ExecStart =
              let
                cmd = pkgs.writeShellScriptBin "${name}-cmd" daily;
              in
              "${cmd}/bin/${name}-cmd";
          };
        };
      }
    else
      {
        timers = { };
        services = { };
      };
in
{
  timer = dailyBackup.timers;
  service = dailyBackup.services;
  # Automatically create directory for the container if it has volumes
  # Then run other commands specified via [`activation`]
  activation = lib.mkIf (builtins.length volumes != 0 || activation != "") {
    "podman-${name}" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.optionalString (builtins.length volumes != 0) ''
        VOLUMES=${config.home.homeDirectory}/.podman/volumes/${name}
        if [ ! -d "$VOLUMES" ]; then
          mkdir -p $VOLUMES
        fi
        LOGS=${config.home.homeDirectory}/.podman/logs/${name}
        if [ ! -d "$LOGS" ]; then
          mkdir -p $LOGS
        fi
        SHARED=${config.home.homeDirectory}/.podman/shared/backups
        if [ ! -d "$SHARED" ]; then
          mkdir -p $SHARED
        fi
        DIR=${config.home.homeDirectory}/.podman/${name}
        if [ ! -d "$DIR" ]; then
          mkdir -p $DIR
        fi
      ''}
      ${activation}
    '';
  };
  container."${name}" = {
    # Mount entrypoint script as volume so that it exists within the container if specified
    volumes =
      ([ "/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt" ] ++ volumes)
      ++ (
        if entrypoint == null then
          [ ]
        else
          ([
            "${start}/bin/podman-start.sh:/my/podman-start.sh"
          ])
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
      extraPodmanArgs
      ip4
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
    # autoUpdate = "registry";
    # If [`needRoot`], container is run as fakeroot (ie current user)
    user = if needRoot then 0 else null;
    labels = (if (domain == null) then { } else traefikLabels) // labels;
  };
}
