{ username, hostname, ... }:
{
  home-manager.users."${username}" =
    { pkgs, inputs, ... }:
    {
      services.kdeconnect.enable = true;
      xdg.configFile."kdeconnect/config" = {
        text = ''
          [General]
          name=${hostname}
          customDevices=phone-kr.local,phone.local
        '';
      };
    };
  networking.firewall = {
    enable = true;
    # KDE Connect
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];

    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };
}
