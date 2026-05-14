{
  config,
  unstable,
  ...
}:
{
  home.packages = with unstable; [
    lazygit
    nil
    lua-language-server
    pyright
    clang-tools
    libxml2
    fd
  ];
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
