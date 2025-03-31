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
      # This is necessary because this laptop has Gen 12 CPU
      # Display may not be detected by the system, and this may lead to wrong resolution issue
      # Run the following command:
      # nix-shell -p pciutils --run "lspci -nn | grep VGA"
      # You should get an output like this:
      # 00:02.0 VGA compatible controller [0300]: Intel Corporation Alder Lake-UP3 GT2 [Iris Xe Graphics] [8086:7d55] (rev 0c)
      # Get this part ------------------------------------------------------------------------------------------^^^^
      # ...and add kernel paramater "i915.force_probe=7d55"
      # Fix has been borrowed from https://nixos.wiki/wiki/Intel_Graphics
      "i915.force_probe=7d55"
    ];
  };
}
