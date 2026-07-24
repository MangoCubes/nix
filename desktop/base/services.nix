{
  services = {
    # Power manager, required to get brightness control
    upower.enable = true;
    # For AGS, I think
    gvfs.enable = true;
    devmon.enable = true;
    # Seems necessary for niri?
    seatd.enable = true;
  };
}
