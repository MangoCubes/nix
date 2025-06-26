{
  unstable,
  config,
  ...
}:
{
  home.packages = [
    unstable.wlr-which-key
  ];

  xdg.configFile."wlr-which-key/config.yaml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/LinuxConfig/wlr-which-key/config.yaml";
}
