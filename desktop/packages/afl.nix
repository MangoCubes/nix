{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    aflplusplus
    gnuplot
  ];

  systemd.coredump.enable = false;

  boot.kernel.sysctl = {
    "kernel.core_pattern" = "core";
    "kernel.sched_child_runs_first" = 1;
    "kernel.sched_autogroup_enabled" = 1;
  };

  powerManagement.cpuFreqGovernor = "performance";
}
