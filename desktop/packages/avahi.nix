{
  services.avahi.enable = true;
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      5353
    ];
  };
}
