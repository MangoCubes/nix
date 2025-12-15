{ pkgs, ... }:
[
  {
    key = "f";
    desc = "Fullscreen";
    cmd = ''niri msg action fullscreen-window'';
  }
  {
    key = "o";
    desc = "Overview";
    cmd = ''niri msg action toggle-overview'';
  }
  {
    key = "t";
    desc = "Tabbed Display";
    cmd = ''niri msg action toggle-column-tabbed-display'';
  }
  {
    key = "s";
    desc = "Split workspace";
    cmd = ''niri msg action set-column-width 50% && niri msg action focus-column-right && niri msg action set-column-width 50% && niri msg action focus-column-left'';
  }
  {
    key = "S";
    desc = "Revert split workspace";
    cmd = ''niri msg action set-column-width 90% && niri msg action focus-column-right && niri msg action set-column-width 90% && niri msg action focus-column-left'';
  }
  {
    key = "q";
    desc = "Scan QR code";
    cmd = ''qrscan'';
  }
  {
    key = "p";
    desc = "Show Window Information";
    cmd = ''${pkgs.notify-desktop}/bin/notify-desktop "Niri Pick Window" "$(niri msg pick-window)"'';
  }
]
