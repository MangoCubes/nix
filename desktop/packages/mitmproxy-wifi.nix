{ username, config, ... }:
{
  home-manager.users."${username}" =
    {
      unstable,
      ...
    }:
    {
      home.packages = [
        unstable.mitmproxy
        unstable.networkmanagerapplet
      ];
    };
  # For MITM purpose
  #
  #
  networking.firewall = {
    extraCommands = ''
      iptables -t nat -A PREROUTING -i ${config.custom.networking.primary} -p tcp --dport 80 -j REDIRECT --to-port 8080 # Redirect HTTP to the MITMProxy
      iptables -t nat -A PREROUTING -i ${config.custom.networking.primary} -p tcp --dport 443 -j REDIRECT --to-port 8080 # Redirect HTTPS to the MITMProxy
    '';
    enable = true;
    allowedTCPPorts = [
      8080
    ];
    allowedUDPPorts = [
      67
      68
      53
    ];
  };
}
