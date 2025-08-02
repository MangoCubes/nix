{ colours, device, ... }:
{
  services.fnott = {
    enable = true;
    settings = {
      main = {
        # -*- conf -*-

        # For documentation on these options, see `man fnott.ini`

        # Global values
        output = "DP-1";
        min-width = 50;
        max-width = 500;
        # max-height=50
        # stacking-order=bottom-up
        # anchor=top-right
        edge-margin-vertical = 4 * device.scale;
        edge-margin-horizontal = 4 * device.scale;
        notification-margin = 4 * device.scale;
        # icon-theme=hicolor
        # max-icon-size=32
        # selection-helper=dmenu
        # selection-helper-uses-null-separator=no
        # play-sound=aplay ${filename}

        # Default values, may be overridden in 'urgency' specific sections
        # layer=top
        background = colours.secondaryBgTr;

        border-color = colours.mikuTr;
        # border-radius=0
        border-size = 4 * device.scale;

        padding-vertical = 12;
        padding-horizontal = 12;

        # dpi-aware=no

        # title-font=sans serif
        # title-color=ffffffff
        title-format = "%a%A";

        # summary-font=sans serif
        # summary-color=ffffffff
        # summary-format=<b>%s</b>\n

        # body-font=sans serif
        # body-color=ffffffff
        # body-format=%b

        # progress-bar-height=20
        # progress-color=ffffffff
        # progress-style=bar

        # sound-file=
        # icon=

        # Timeout values are in seconds. 0 to disable
        # max-timeout = 0;
        # default-timeout = 0;
        # idle-timeout=0
      };

      # [low]
      # background=2b2b2bff
      # title-color=888888ff
      # summary-color=888888ff
      # body-color=888888ff

      # [normal]

      # [critical]
      # background=6c3333ff

    };
  };
}
