{ username, ... }:
{
  home-manager.users."${username}" =
    { unstable, colours, ... }:
    {
      programs.swaylock = {
        enable = true;
        package = unstable.swaylock-effects;
        settings = {
          screenshots = true;
          clock = true;
          indicator = true;
          indicator-thickness = 4;
          effect-blur = "7x5";
          effect-vignette = "0.5:0.5";
          indicator-radius = 100;
          ring-color = colours.primary;
          key-hl-color = colours.highlight;
          font = "BankGothic";
          text-color = colours.primary;
          text-clear-color = colours.primary;
          text-caps-lock-color = colours.primary;
          text-ver-color = colours.primary;
          text-wrong-color = colours.primary;
          line-color = "00000000";
          inside-color = "00000088";
          separator-color = "00000000";
          grace = 2;
          fade-in = 0.5;
          font-size = 24;
          indicator-idle-visible = false;
          show-failed-attempts = true;
        };
      };
    };
  security.pam.services.swaylock = { };
}
