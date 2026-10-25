{
  config,
  lib,
  ...
}:
let
  hostname = config.networking.hostName;
  kb = {
    "main" = "/dev/input/by-id/usb-GIGABYTE_USB-HID_Keyboard_AP0000000003-event-kbd";
    "work" =
      "/dev/input/by-id/usb-Apple_Inc._Magic_Keyboard_with_Numeric_Keypad_F0T1244011HJKNNAX-if01-event-kbd"; # "/dev/input/by-id/usb-040b_Gaming_Keyboard-event-kbd";
    "laptop2" = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  };
in
{
  services.kanata =
    let
      device = kb."${hostname}";
    in
    lib.mkIf (device != null) {
      enable = true;
      keyboards.default = {
        devices = [ device ];
        config = ''
          (defsrc kp1 kp7)
          (deflayer default (macro-repeat s 20) (macro-repeat C-Digit7 20))
        '';
      };
    };
}
