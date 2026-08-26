# This file contains various troubleshooting related stuff.
{
  # Debugging NixOS when "Failed to start transient service unit..."
  # 1. journalctl -xe
  # 2. sudo systemctl stop nixos-rebuild-switch-to-configuration

  # Ensuring we get stuff when the system crashes
  # Check if these are applied properly with =cat /proc/cmdline= and =cat /proc/sys/kernel/printk=
  boot = {
    kernelParams = [
      "panic=0"
      "oops=panic"
      "softlockup_panic=1"
      "debug"
    ];
    consoleLogLevel = 8;
    kernel.sysctl."kernel.sysrq" = 1;
  };
}
