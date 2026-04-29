{
  pkgs,
  config,
  unstable,
  ...
}:
{
  home.packages = [
    pkgs.nil
    pkgs.lazygit
    pkgs.libxml2
    unstable.neovim
    unstable.rust-analyzer
  ];
  xdg = {
    configFile."nvim/init.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/GeneralConfig/Neovim/init.lua";
    dataFile."nvim/undo/.keep".text = "";
    mimeApps.defaultApplications."text/plain" = "nvim.desktop";
  };
  home.sessionVariables.EDITOR = "nvim";
}
