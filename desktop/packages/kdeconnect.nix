{
  username,
  hostname,
  ...
}:
{
  home-manager.users."${username}" =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    {
      services.kdeconnect.enable = true;
      xdg.configFile = {
        "kdeconnect/config" = {
          text = ''
            [General]
            name=${hostname}
            keyAlgorithm=EC
            customDevices=tokay.local
          '';
        };
        "kdeconnect/trusted_devices".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/kde/trusted_devices";
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
