{
  services.avahi = {
    enable = true;
    settings.publish.disable-user-service-publishing = false;
  };
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      5353
    ];
  };
}
