{ pkgs, ... }:

{
  # Only the essentials
  environment.systemPackages = with pkgs; [
    ripgrep
    wget
    tree
    fastfetch
    killall
    traceroute
    git
    dnsutils
    lsof
  ];
}
