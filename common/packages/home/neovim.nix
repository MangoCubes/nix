{
  config,
  lib,
  unstable,
  ...
}:
{
  home.packages = lib.mkMerge [
    (with unstable; [
      nil
      fd
    ])
    (lib.mkIf (config.custom.device.type == "desktop" || config.custom.device.type == "laptop") (
      with unstable;
      [
        lua-language-server
        pyright
        clang-tools
        libxml2
        typescript-language-server
        vscode-langservers-extracted
      ]
    ))
  ];
  programs.neovim = {
    sideloadInitLua = true;
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
