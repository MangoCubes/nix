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
  vpn ? null,
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
    index: entry:
    let
      routerName = "${name}-${builtins.toString index}";
      hasUrl = entry.url != null;
      rule = if hasUrl then "Host(`${entry.url}`)" else entry.rule;

      certResolver =
        if hasUrl then
          if (lib.hasSuffix ".local" entry.url || lib.hasSuffix ".int" entry.url) then
            "localca"
          else
            "letsencrypt"
        else
          entry.certResolver;

      flattenAttrs =
        prefix: attrs:
        builtins.foldl' (
          acc: n:
          let
            val = attrs.${n};
            newKey = if prefix == "" then n else "${prefix}.${n}";
          in
          if builtins.isAttrs val then
            acc // (flattenAttrs newKey val)
          else
            acc // { "${newKey}" = (builtins.toString val); }
        ) { } (builtins.attrNames attrs);

      extraRouterLabels = flattenAttrs "traefik.http.routers.${routerName}" (entry.extraRouterConfig);
      extraServiceLabels = flattenAttrs "traefik.http.services.s-${routerName}" (
        entry.extraServiceConfig
      );
    in
    {
      "traefik.http.routers.${routerName}.rule" = rule;
      # Ensure traffic can only enter via HTTPS
      "traefik.http.routers.${routerName}.entrypoints" = "websecure";
      # Explicitly mention the name of the service this allows access to
      "traefik.http.routers.${routerName}.service" = "s-${routerName}";
      # Enable HTTPS
      "traefik.http.routers.${routerName}.tls" = "true";
      "traefik.http.routers.${routerName}.tls.certResolver" = certResolver;
      # Specify the port in the container the router routes the requests to
      "traefik.http.services.s-${routerName}.loadbalancer.server.port" = (builtins.toString entry.port);
    }
    // extraRouterLabels
    // extraServiceLabels;
  vpnEnabled = vpn != null;
  vpnContainer = "gluetun-${vpn}";

  # Automatically create dependencies if dependsOn is specified
  # Note that dependencies are other containers
  deps =
    (if dependsOn == null then [ ] else (builtins.map (e: "podman-${e}.service") dependsOn))
    ++ [ "podman.socket" ]
    ++ (if vpnEnabled then [ "podman-${vpnContainer}.service" ] else [ ]);
  # We generate Traefik labels for each domain entry
  traefikLabels =
    if (domain == null) then
      { }
    else
      (builtins.foldl' (acc: elem: acc // elem) {
        "traefik.enable" = "true";
      } (builtins.genList (i: genRouters (i + 1) (builtins.elemAt domain i)) (builtins.length domain)));
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
    network = if vpnEnabled then [ "container:${vpnContainer}" ] else network;
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
