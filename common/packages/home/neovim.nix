{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
let
  # Note to self:
  # If I am searching for a package because of an error "File `stuff.sty' not found", go to https://ctan.org/search and search for the package that contains that sty
  tex = (
    pkgs.texliveMedium.withPackages (
      ps: with ps; [
        dvisvgm
        dvipng # for preview and export as html
        wrapfig
        amsmath
        ulem
        hyperref
        capt-of
        collection-langkorean
        environ
        sttools
        breakurl
        tabularray
        ninecolors
        listings
      ]
    )
  );
in
{
  home.packages = lib.mkMerge [
    (with unstable; [
      nil
      fd
      tree-sitter
    ])
    (lib.mkIf (config.custom.device.type == "desktop" || config.custom.device.type == "laptop") (
      with unstable;
      [
        w3m
        lua-language-server
        pyright
        clang-tools
        libxml2
        typescript-language-server
        vscode-langservers-extracted
      ]
      ++ (with pkgs; [
        mermaid-cli
        imagemagick
        # Necessary for exporting an .org document as .odt
        zip
        unzip
        tex
      ])
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
      config.lib.file.mkOutOfStoreSymlink "${config.custom.bookmarks.GeneralConfig.path}/Neovim";
    dataFile."nvim/undo/.keep".text = "";
    mimeApps.defaultApplications."text/plain" = "nvim.desktop";
  };
  home.sessionVariables.EDITOR = "nvim";
}
