{
  unstable,
  device,
  pkgs,
  config,
  ...
}:
let
  # configFile = if device == "server" then "headless.el" else "desktop.el";
  # vars = ''
  #   (defvar banner "${inputs.secrets.res}/media/emacs/banner.jpg")
  #   (defvar default-scale ${(toString device.emacsScale)})
  #   (defvar my-use-straight nil "If non-nil, the package will be installed using straight.")
  # '';
  envs = ''DEFAULT_SCALE=${(toString device.emacsScale)}'';
  init = "~/Sync/EmacsConfig/init.el";

  loademacs = pkgs.writeShellScriptBin "loademacs" ''${envs} emacs -q --daemon --load ${init}'';
  emacs-org = pkgs.writeShellScriptBin "emacs-org" ''cd ${config.home.homeDirectory}/Sync/Notes/Org/ && emacsclient -c --eval '(find-file "${config.home.homeDirectory}/Sync/Notes/Org/Main.org")' '';
  emacs-web = pkgs.writeShellScriptBin "emacs-web" ''cd ${config.home.homeDirectory}/Sync/Website/src/org/ && emacsclient -c --eval '(find-file "${config.home.homeDirectory}/Sync/Website/src/org/index.org")' '';
  emacs-mail = pkgs.writeShellScriptBin "emacs-mail" ''emacsclient -c -e '(notmuch-search "tag:inbox")' '';
  emacs-daily = pkgs.writeShellScriptBin "emacs-daily" ''emacsclient -c -e '(org-roam-dailies-capture-today)' '';
  reload-emacs = pkgs.writeShellScriptBin "er" ''emacsclient -e '(kill-emacs)'; loademacs'';
  reload-emacs-fg = pkgs.writeShellScriptBin "ef" "${envs} emacs -q --fg-daemon --load ${init}";
  tex = (
    pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-medium
        dvisvgm
        dvipng # for preview and export as html
        wrapfig
        amsmath
        ulem
        hyperref
        capt-of
        collection-langkorean
        ;
    }
  );
in
{
  # Short for Emacs Server
  home.packages = [
    loademacs
    emacs-org
    emacs-web
    emacs-mail
    emacs-daily
    reload-emacs
    reload-emacs-fg
  ]
  ++ (with pkgs; [
    # Necessary for exporting an .org document as .odt
    zip
    unzip

    xwayland-satellite
    tex
  ]);
  xdg = {
    # Use xdg-mime query filetype <FILE> to determine a file's mime type
    dataFile."mime/packages/orgmode.xml".text = ''
      <?xml version="1.0" encoding="utf-8"?>
      <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
      <mime-type type="text/org">
        <glob pattern="*.org"/>
        <comment>OrgMode documents</comment>
      </mime-type>
      </mime-info>
    '';
    # Use xdg-mime query default <FILETYPE> to query what would be opened when this file is opened
    mimeApps.defaultApplications."text/org" = "emacs.desktop";
    desktopEntries = {
      emacs = {
        name = "Emacs Client";
        genericName = "Text Editor";
        exec = ''emacsclient -c %f'';
        terminal = false;
        # categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [
          "text/plain"
          "text/org"
        ];
      };
      emacs-nw = {
        name = "Emacs Client (No Window)";
        genericName = "Text Editor";
        exec = (
          config.custom.terminal.genCmd {
            command = ''emacsclient -nw %f'';
          }
        );
        # terminal = true;
        # categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [
          "text/plain"
          "text/org"
        ];
      };
      emacsclient = {
        noDisplay = true;
        name = "";
      };
    };
  };
  programs.emacs = {
    enable = true;
    package = unstable.emacs-pgtk; # unstable.emacs-pgtk;
  };
}
