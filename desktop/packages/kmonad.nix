{
  config,
  inputs,
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
  imports = [ inputs.kmonad.nixosModules.default ];
  services.kmonad =
    let
      device = kb."${hostname}";
    in
    if device == null then
      { }
    else
      {
        enable = true;
        keyboards = {
          myKMonadOutput = {
            inherit device;
            config = ''
              (defcfg
                ;; For Linux
                input  (device-file "${device}")
                output (uinput-sink "KMonad")

                ;; Comment this if you want unhandled events not to be emitted
                fallthrough true

                ;; Set this to false to disable any command-execution in KMonad
                allow-cmd false
              )
            ''
            + builtins.readFile (if (hostname == "work") then ./kmonad/work.kbd else ./kmonad/default.kbd);
          };
        };
      };
}
