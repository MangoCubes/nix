{
  username,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.secrets.networks.mitm
  ];
  # How to set up MITM
  # Copy the nmconnection to /etc/static/NetworkManager/system-connections/MITM.nmconnection
  # Enable connection
  # Run mitmweb without any flags
  home-manager.users."${username}" =
    {
      unstable,
      ...
    }:
    {
      home.packages = [
        unstable.mitmproxy
      ];
    };
  networking.firewall = {
    extraCommands = ''
      iptables -t nat -A PREROUTING -i ${config.custom.networking.secondary} -p tcp --dport 80 -j REDIRECT --to-port 8080 # Redirect HTTP to the MITMProxy
      iptables -t nat -A PREROUTING -i ${config.custom.networking.secondary} -p tcp --dport 443 -j REDIRECT --to-port 8080 # Redirect HTTPS to the MITMProxy
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
