{ colours, device, ... }:
let
  width = 4; # builtins.floor (4 * device.scale);
in
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
        edge-margin-vertical = width;
        edge-margin-horizontal = width;
        notification-margin = width;
        # icon-theme=hicolor
        # max-icon-size=32
        # selection-helper=dmenu
        # selection-helper-uses-null-separator=no
        play-sound = "pw-play ${./fnott/Transmission.wav}";

        # Default values, may be overridden in 'urgency' specific sections
        # layer=top
        background = colours.withTransparency.blackBg;

        border-color = colours.withTransparency.miku;
        # border-radius=0
        border-size = width;

        padding-vertical = 12;
        padding-horizontal = 12;

        dpi-aware = "yes";

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

        sound-file = "${./fnott/Transmission.wav}";
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
