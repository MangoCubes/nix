{ pkgs, ... }:
let
  rateLimitCheckRedlib = pkgs.writeShellScriptBin "rateLimitCheckRedlib" ''
    # For debugging purpose
    #set -eu
    # Get status code of "r.genit.al"
    status=`${pkgs.coreutils}/bin/timeout 5 ${pkgs.curl}/bin/curl -o /dev/null -s -w "%{http_code}" https://r.genit.al`
    echo "Status: $status"
    # 4XX implies rate limit in Redlib
    if [[ $status != 2* ]]; then
    	echo "Ratelimited!"
        echo "Stopping Redlib..."
        ${pkgs.systemd}/bin/systemctl --user stop podman-redlib-vpn
        echo "Restarting VPN..."
    	${pkgs.systemd}/bin/systemctl --user restart podman-proton-redlib
    	echo "Starting Redlib..."
    	${pkgs.systemd}/bin/systemctl --user start podman-redlib-vpn
    else
      echo "Server is working!"
    fi
    echo "Done!"
  '';
in
let
  check = (import ./scripts/ratelimitCheck.nix { inherit pkgs; });
in

{
  home.packages = [
    rateLimitCheckRedlib
    check
  ];

  services.podman.containers.redlib-vpn = {
    image = "quay.io/redlib/redlib:latest";
    autoStart = true;
    network = [ "container:proton-redlib" ];
    autoUpdate = "registry";
    dropCapabilities = [ "all" ];
    extraPodmanArgs = [
      "--security-opt=no-new-privileges"
      "--read-only"
    ];
    environment = {
      "REDLIB_SFW_ONLY" = "off";
      "REDLIB_BANNER" = "";
      "REDLIB_ROBOTS_DISABLE_INDEXING" = "off";
      "REDLIB_PUSHSHIFT_FRONTEND" = "undelete.pullpush.io";
      "REDLIB_DEFAULT_THEME" = "system";
      "REDLIB_DEFAULT_FRONT_PAGE" = "default";
      "REDLIB_DEFAULT_LAYOUT" = "card";
      "REDLIB_DEFAULT_WIDE" = "off";
      "REDLIB_DEFAULT_POST_SORT" = "hot";
      "REDLIB_DEFAULT_COMMENT_SORT" = "confidence";
      "REDLIB_DEFAULT_SHOW_NSFW" = "off";
      "REDLIB_DEFAULT_BLUR_NSFW" = "off";
      "REDLIB_DEFAULT_USE_HLS" = "off";
      "REDLIB_DEFAULT_HIDE_HLS_NOTIFICATION" = "off";
      "REDLIB_DEFAULT_AUTOPLAY_VIDEOS" = "off";
      "REDLIB_DEFAULT_SUBSCRIPTIONS" = "";
      "REDLIB_DEFAULT_HIDE_AWARDS" = "off";
      "REDLIB_DEFAULT_DISABLE_VISIT_REDDIT_CONFIRMATION" = "off";
      "REDLIB_DEFAULT_HIDE_SCORE" = "off";
      "REDLIB_DEFAULT_FIXED_NAVBAR" = "on";
    };
    # Intended to be used with Anubis
    # labels = {
    #   "traefik.enable" = "true";
    #   "traefik.http.routers.redlib-vpn.rule" = "Host(\\`r.genit.al\\`)";
    #   "traefik.http.routers.redlib-vpn.entrypoints" = "websecure";
    #   "traefik.http.routers.redlib-vpn.service" = "s-redlib-vpn";
    #   "traefik.http.routers.redlib-vpn.tls" = "true";
    #   "traefik.http.services.s-redlib-vpn.loadbalancer.server.port" = "8080";
    # };
  };
  # This runs check-ratelimit.service every 5 minutes
  systemd.user.timers."check-ratelimit-redlib" = {
    Install.WantedBy = [ "timers.target" ];
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "1m";
      Unit = "check-ratelimit-redlib.service";
    };
    Unit.Description = "Do ratelimit check every 5 minutes.";
  };
  # Restart Redlib and VPN if ratelimit is detected
  systemd.user.services."check-ratelimit-redlib" = {
    Unit.Description = "Check if Redlib is ratelimited.";
    Service = {
      Type = "oneshot";
      ExecStart = "${rateLimitCheckRedlib}/bin/rateLimitCheckRedlib";
    };
  };
  systemd.user.services."check-test" = {
    Unit.Description = "Check if Redlib is ratelimited.";
    Service = {
      Type = "oneshot";
      ExecStart = "${check}/bin/ratelimitcheck";
    };
  };
}
