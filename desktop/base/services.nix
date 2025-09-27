{
  services = {
    # Keyring (Secret manager)
    # gnome.gnome-keyring.enable = true;
    # Power manager, required to get brightness control
    upower.enable = true;
    # For getting USBs
    # udisks2.enable = true;
    # Audio
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    # For AGS, I think
    gvfs.enable = true;
    devmon.enable = true;
  };
}
