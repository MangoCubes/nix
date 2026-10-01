{ pkgs, ... }:
let
  rlcheck = pkgs.writeShellScriptBin "rlcheck" (
    builtins.replaceStrings
      [ "@timeout@" "@curl@" "@systemctl@" ]
      [ "${pkgs.coreutils}/bin/timeout" "${pkgs.curl}/bin/curl" "${pkgs.systemd}/bin/systemctl" ]
      (builtins.readFile ./redlib-vpn/rlcheck.sh)
  );
in
{
  home.packages = [
    rlcheck
  ];

  services.podman.containers.redlib-vpn = {
    extraConfig.Quadlet.DefaultDependencies = false;
    image = "ghcr.io/cycneuramus/containers:redlib";
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
  };
  systemd.user.timers."redlib-check" = {
    Install.WantedBy = [ "timers.target" ];
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "1m";
      Unit = "redlib-check.service";
    };
    Unit.Description = "Do ratelimit check every 5 minutes.";
  };
  # Restart Redlib and VPN if ratelimit is detected
  systemd.user.services."redlib-check" = {
    Unit.Description = "Check if Redlib is ratelimited.";
    Service = {
      Type = "oneshot";
      ExecStart = "${rlcheck}/bin/rlcheck";
    };
  };
}
