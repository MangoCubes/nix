{
  username,
  hostname,
  pkgs,
  inputs,
  ...
}:
let
  kb = {
    "main" = "/dev/input/by-id/usb-GIGABYTE_USB-HID_Keyboard_AP0000000003-event-kbd";
    "laptop" = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    "work" =
      "/dev/input/by-id/usb-Apple_Inc._Magic_Keyboard_with_Numeric_Keypad_F0T1244011HJKNNAX-if01-event-kbd"; # "/dev/input/by-id/usb-040b_Gaming_Keyboard-event-kbd";
    "laptop2" = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  };
in
{
  home-manager.users."${username}" =
    { pkgs, config, ... }:
    {
      xdg = {
        desktopEntries."org.fcitx.fcitx5-migrator" = {
          noDisplay = true;
          name = "";
        };
        configFile."gtk-4.0/settings.ini" = {
          text = ''
            [Settings]
            gtk-im-module=fcitx
          '';
        };
        configFile."gtk-3.0/settings.ini" = {
          text = ''
            [Settings]
            gtk-im-module=fcitx
          '';
        };
        configFile."fcitx5".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/fcitx5";
      };
      i18n.inputMethod = {
        # type = "fcitx5";
        # enable = true;
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-mozc
          fcitx5-hangul
          fcitx5-gtk
          fcitx5-nord
        ];
      };
    };
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
  ];
  environment.sessionVariables = {
    # GTK_IM_MODULE = "wayland";
    QT_IM_MODULE = "fcitx";
    QT_IM_MODULES = "wayland;fcitx;ibus";
    XMODIFIERS = "@im=fcitx";
  };
  # users.users."${config.username}".extraGroups = [ "input" "uinput" ];
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
            config =
              if (hostname == "work") then
                ''
                  (defcfg
                    ;; For Linux
                    input  (device-file "${device}")
                    output (uinput-sink "KMonad")

                    ;; Comment this if you want unhandled events not to be emitted
                    fallthrough true

                    ;; Set this to false to disable any command-execution in KMonad
                    allow-cmd false 
                  )
                  ;; Changes:
                  ;; Swap out Right Alt -> Korean
                  ;; Swap Meta with Alt
                  ;; Fucking Apple messing with me
                  (deflayer korean
                    esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12        ssrq slck pause
                    grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc  ins  home pgup  nlck kp/  kp*  kp-
                    tab  q    w    e    r    t    y    u    i    o    p    [    ]    \     del  end  pgdn  kp7  kp8  kp9  kp+
                    caps a    s    d    f    g    h    j    k    l    ;    '    ret                        kp4  kp5  kp6
                    lsft z    x    c    v    b    n    m    ,    .    /    rsft                 up         kp1  kp2  kp3  kprt
                    lctl lmet lalt           spc         hangeul rmet  cmp  rctl            left down rght  kp0  kp.
                  )
                  (defsrc
                    esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12        ssrq slck pause
                    grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc  ins  home pgup  nlck kp/  kp*  kp-
                    tab  q    w    e    r    t    y    u    i    o    p    [    ]    \     del  end  pgdn  kp7  kp8  kp9  kp+
                    caps a    s    d    f    g    h    j    k    l    ;    '    ret                        kp4  kp5  kp6
                    lsft z    x    c    v    b    n    m    ,    .    /    rsft                 up         kp1  kp2  kp3  kprt
                    lctl lalt lmet         spc            rmet ralt cmp  rctl            left down rght  kp0  kp.
                  )
                ''
              else
                ''
                  (defcfg
                    ;; For Linux
                    input  (device-file "${device}")
                    output (uinput-sink "KMonad")

                    ;; Comment this if you want unhandled events not to be emitted
                    fallthrough true

                    ;; Set this to false to disable any command-execution in KMonad
                    allow-cmd false 
                  )
                  (deflayer korean
                    esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12        ssrq slck pause
                    grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc  ins  home pgup  nlck kp/  kp*  kp-
                    tab  q    w    e    r    t    y    u    i    o    p    [    ]    \     del  end  pgdn  kp7  kp8  kp9  kp+
                    caps a    s    d    f    g    h    j    k    l    ;    '    ret                        kp4  kp5  kp6
                    lsft z    x    c    v    b    n    m    ,    .    /    rsft                 up         kp1  kp2  kp3  kprt
                    lctl lmet lalt           spc            hangeul  rmet cmp  rctl            left down rght  kp0  kp.
                  )
                  (defsrc
                    esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12        ssrq slck pause
                    grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc  ins  home pgup  nlck kp/  kp*  kp-
                    tab  q    w    e    r    t    y    u    i    o    p    [    ]    \     del  end  pgdn  kp7  kp8  kp9  kp+
                    caps a    s    d    f    g    h    j    k    l    ;    '    ret                        kp4  kp5  kp6
                    lsft z    x    c    v    b    n    m    ,    .    /    rsft                 up         kp1  kp2  kp3  kprt
                    lctl lmet lalt           spc            ralt rmet cmp  rctl            left down rght  kp0  kp.
                  )
                '';
          };
        };
      };
}
