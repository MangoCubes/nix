{
  config,
  lib,
  ...
}:
let
  device = config.custom.device.keyboard;
in
{
  services.kanata = lib.mkIf (device != null) {
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
