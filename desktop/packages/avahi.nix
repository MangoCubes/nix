{
  services.avahi = {
    enable = true;
    settings.publish = {
      disable-publishing = false;
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
  };
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      5353
    ];
  };
}
