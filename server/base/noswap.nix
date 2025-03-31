{ lib, ... }: {
  boot.kernel.sysctl = { "vm.swappiness" = 0; };
  swapDevices = lib.mkForce [ ];
}
