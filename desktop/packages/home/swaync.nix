{
  colours,
  config,
  pkgs,
  ...
}:
let
  borderWidth = 4;
  width = builtins.floor (borderWidth * config.custom.device.scale);
  titleSize = width * 3;
  bodySize = width * 2;
  notificationSound = ./sfx/Transmission.wav;
  swaync = pkgs.swaynotificationcenter.overrideAttrs (_: {
    version = "0.12.6-unstable-2026-06-25";
    src = pkgs.fetchFromGitHub {
      owner = "ErikReider";
      repo = "SwayNotificationCenter";
      rev = "b8017a4d1a53debdf0e8766628fb80357eae31e7";
      hash = "sha256-ZKJIrDPfQcVPqufBeXAx56UmSfDp3il84MtzLjq2Cjs=";
    };
  });
in
{
  services.swaync = {
    enable = true;
    package = swaync;

    settings = {
      positionX = "right";
      positionY = "top";
      layer = "top";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "user";

      notification-window-width = 500;
      notification-window-preferred-output = "DP-1";

      control-center-width = 500;
      control-center-preferred-output = "DP-1";

      notification-grouping = true;
      notification-2fa-action = true;
      notification-inline-replies = true;
      relative-timestamps = true;

      timeout = 0;
      timeout-low = 0;
      timeout-critical = 0;
      script-fail-notify = true;

      hide-on-action = true;

      keyboard-shortcuts = true;

      scripts."notification-sound" = {
        app-name = ".*";
        run-on = "receive";
        exec = "${pkgs.pipewire}/bin/pw-play ${notificationSound}";
      };
    };

    style = ''
      :root {
        --cc-bg: #${colours.withTransparency.blackBg};
        --noti-bg: 0, 0, 0;
        --noti-bg-alpha: 0.8157;
        --noti-border-color: #${colours.withTransparency.miku};
        --bg-selected: #${colours.withTransparency.miku};
        --border: ${builtins.toString borderWidth}px solid var(--noti-border-color);
        --border-radius: 0;
        --font-size-summary: ${builtins.toString titleSize}pt;
        --font-size-body: ${builtins.toString bodySize}pt;
      }

      * {
        font-family: "Courier New";
      }

      .notification-row .notification-background {
        padding: ${builtins.toString borderWidth}px;
      }

      .notification-row .notification-background .notification .notification-default-action {
        padding: ${builtins.toString bodySize}px;
      }

      .notification-row .notification-background .notification .notification-default-action:hover {
        background: transparent;
      }

      .close-button {
        background: transparent;
      }

      .close-button:hover {
        background: transparent;
      }

      .notification-row .notification progressbar trough,
      .notification-row .notification progressbar progress {
        min-height: ${builtins.toString width}px;
        border-radius: 0;
      }

      .notification-row .notification progressbar progress {
        background: #${colours.withTransparency.miku};
      }
    '';
  };
}
