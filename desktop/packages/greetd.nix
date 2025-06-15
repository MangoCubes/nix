{ pkgs, ... }:

let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "niri-session";
in

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --time --cmd ${session}";
        user = "greeter";
      };
    };
  };
}
