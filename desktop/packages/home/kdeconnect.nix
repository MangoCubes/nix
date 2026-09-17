{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  home.packages = [ pkgs.sshfs ];
  services.kdeconnect.enable = true;
  xdg.configFile = {
    "kdeconnect/config" = {
      text = ''
        [General]
        name=${osConfig.networking.hostName}
        keyAlgorithm=EC
        customDevices=phone.local,main.local,windows-work.local,windows-laptop2.local,laptop2.local
      '';
    };
    "kdeconnect/trusted_devices".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/kde/trusted_devices";
  };
}
