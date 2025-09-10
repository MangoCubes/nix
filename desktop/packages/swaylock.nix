{ username, ... }:
{
  home-manager.users."${username}" =
    {
      pkgs,
      unstable,
      colours,
      config,
      ...
    }:
    let
      onlock = pkgs.writeShellScriptBin "onlock" ''keepassxc --lock; ${unstable.swaylock-effects}/bin/swaylock'';
      onunlock = pkgs.writeShellScriptBin "onunlock" '''';
    in
    {
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            command = ''${onlock}/bin/onlock'';
            timeout = 300;
          }
        ];
      };
      programs.swaylock = {
        enable = true;
        package = unstable.swaylock-effects;
        settings = {
          # screenshots = true;
          image = "${config.home.homeDirectory}/.config/configMedia/wallpaper/miku.png";
          clock = true;
          indicator = true;
          indicator-thickness = 4;
          effect-blur = "7x5";
          effect-vignette = "0.5:0.5";
          indicator-radius = 100;

          ring-color = colours.base.miku;
          ring-ver-color = colours.base.miku;
          ring-wrong-color = colours.base.teto;
          ring-clear-color = colours.base.teto;
          ring-caps-lock-color = colours.base.miku;

          key-hl-color = colours.base.teto;
          font = "BankGothic";
          text-color = colours.base.miku;
          text-clear-color = colours.base.miku;
          text-caps-lock-color = colours.base.miku;
          text-ver-color = colours.base.miku;
          text-wrong-color = colours.base.miku;

          line-color = "00000000";
          line-clear-color = "00000000";
          line-caps-lock-color = "00000000";
          line-ver-color = "00000000";
          line-wrong-color = "00000000";

          inside-clear-color = "00000088";
          inside-ver-color = "00000088";
          inside-caps-lock-color = "00000088";
          inside-color = "00000088";
          inside-wrong-color = "00000088";

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
