{ inputs, unfreeUnstable, ... }:
{
  virtualisation.vmware.host = {
    package = unfreeUnstable.vmware-workstation;
    enable = true;
  };
  services.printing.enable = true;
  # Swap Alt and Meta on the Apple keyboard
  # I: Bus=0003 Vendor=05ac Product=026c Version=0110
  services.udev.extraHwdb = ''
    evdev:input:b0003v05ACp026C*
     KEYBOARD_KEY_700e2=leftmeta
     KEYBOARD_KEY_700e3=leftalt
     KEYBOARD_KEY_700e6=rightmeta
     KEYBOARD_KEY_700e7=rightalt
  '';
  custom.device = {
    type = "desktop";
    scale = 1.5;
    keyboard = "/dev/input/by-id/usb-Apple_Inc._Magic_Keyboard_with_Numeric_Keypad_F0T1244011HJKNNAX-if01-event-kbd"; # "/dev/input/by-id/usb-040b_Gaming_Keyboard-event-kbd";
    monitors = [
      {
        x = 3840;
        y = 2160;
      }
      {
        x = 3840;
        y = 2160;
      }
    ];
  };
  imports = [
    inputs.secrets.desktop.work
    ./boot.nix
    ./home.nix
    ../packages/avahi.nix
    ../packages/wireshark.nix
    ../packages/mitmproxy-wifi.nix
    ../packages/afl.nix
  ];
  custom.android.enable = true;
  networking.wireless = {
    enable = true;
    userControlled = true;
  };
}
