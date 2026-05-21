{
  config,
  unstable,
  device,
  ...
}:
{
  home.packages =
    with unstable;
    [
      lazygit
      nil
      fd
    ]
    ++ (
      if device.type == "desktop" || device.type == "laptop" then
        [
          lua-language-server
          pyright
          clang-tools
          libxml2
          typescript-language-server
        ]
      else
        [ ]
    );
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withPython3 = false;
  };
  xdg = {
    configFile."nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Sync/GeneralConfig/Neovim";
    dataFile."nvim/undo/.keep".text = "";
    mimeApps.defaultApplications."text/plain" = "nvim.desktop";
  };
  home.sessionVariables.EDITOR = "nvim";
}
