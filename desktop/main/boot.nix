{
  boot = {
    loader = {
      efi.efiSysMountPoint = "/boot/efi";
    };
    kernelParams = [
      "splash"
      # Keyboard fix
      "usbcore.autosuspend=-1"
      # https://bbs.archlinux.org/viewtopic.php?id=308539
      "i915.enable_psr=0"
      "i915.enable_dc=0"
    ];
  };
}
