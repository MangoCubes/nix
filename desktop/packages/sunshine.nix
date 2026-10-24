{ config, ... }:
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = false;
    openFirewall = false;
  };
  networking.firewall.interfaces.${config.services.netbird.clients.personal.interface} = {
    allowedTCPPorts = [
      47984
      47989
      47990
      48010
    ];
    allowedUDPPorts = [
      47998
      47999
      48000
      48002
      48010
    ];
  };
}
