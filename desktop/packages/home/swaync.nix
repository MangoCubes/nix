{
  colours,
  config,
  pkgs,
  ...
}:
let
  width = builtins.floor (4 * config.custom.device.scale);
  titleSize = width * 3;
  bodySize = width * 2;
  notificationSound = ./sfx/Transmission.wav;
in
{
  services.swaync = {
    enable = true;

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

      notification-grouping = false;
      notification-2fa-action = false;
      notification-inline-replies = false;
      timeout = 0;
      timeout-low = 0;
      timeout-critical = 0;
      script-fail-notify = false;

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
        --border: ${builtins.toString width}px solid var(--noti-border-color);
        --border-radius: 0;
        --font-size-summary: ${builtins.toString titleSize}pt;
        --font-size-body: ${builtins.toString bodySize}pt;
      }

      * {
        font-family: "Courier New";
      }

      .notification-row .notification-background {
        padding: ${builtins.toString width}px;
      }

      .notification-row .notification-background .notification .notification-default-action {
        padding: ${builtins.toString (width * 3)}px;
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
