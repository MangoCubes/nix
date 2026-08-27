{
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
      };
    };
    kernelParams = [
      "splash"
      # Keyboard fix
      "usbcore.autosuspend=-1"
      # https://bbs.archlinux.org/viewtopic.php?id=308539
      "i915.enable_psr=0"
      "intel_idle.max_cstate=1"
      "i915.enable_dc=0"
    ];
  };
}
