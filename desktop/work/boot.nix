{
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
      };
    };
    kernelParams = [
      "quiet"
      "splash"
    ];
    extraModprobeConfig = ''
      options hid_apple fnmode=0
    '';
  };
}
