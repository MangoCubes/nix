{
  unstable,
  device,
  pkgs,
  inputs,
  ...
}:
let
  configFile = if device == "server" then "headless.el" else "desktop.el";
  vars = ''
    (defvar banner "${inputs.secrets.res}/media/emacs/banner.jpg")
    (defvar default-scale ${(toString device.emacsScale)})
    (defvar my-use-straight nil "If non-nil, the package will be installed using straight.")
  '';
  configData = ''
    (require 'package)
    (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
    (setq package-enable-at-startup nil)
    (defvar bootstrap-version)
    (let ((bootstrap-file
           (expand-file-name
            "straight/repos/straight.el/bootstrap.el"
            (or (bound-and-true-p straight-base-dir)
                user-emacs-directory)))
          (bootstrap-version 7))
      (unless (file-exists-p bootstrap-file)
        (with-current-buffer
            (url-retrieve-synchronously
             "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
             'silent 'inhibit-cookies)
          (goto-char (point-max))
          (eval-print-last-sexp)))
      (load bootstrap-file nil 'nomessage))

    (straight-use-package 'load-relative)

    ${vars}

    (load-file "${./emacs}/${configFile}")
  '';
in
{
  # Short for Emacs Server
  programs.bash.shellAliases.es = "emacs -q --fg-daemon --load ~/Sync/NixConfig/desktop/packages/home/emacs/init.el";
  # programs.bash.shellAliases.e = "emacsclient -c";
  # programs.bash.shellAliases.te = "kitty --detach emacsclient -c";
  home.packages = (
    with pkgs;
    [
      perl538Packages.LaTeXML
      texliveMedium
      xwayland-satellite
    ]
  );
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
    mimeApps.defaultApplications."text/org" = "emacs-nw.desktop";
    desktopEntries = {
      emacs = {
        name = "Emacs Client";
        genericName = "Text Editor";
        exec = ''emacsclient -c'';
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
        exec = ''kitty emacsclient -nw'';
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
    package = unstable.emacs-gtk;
    extraConfig = configData;
    # extraPackages =
    #   epkgs: with epkgs; [
    #     mu4e
    #   ];
  };
  services.emacs = {
    enable = true;
    startWithUserSession = if device == "server" then true else "graphical";
  };
  systemd.user.services.emacs = {
    Service = {
      TimeoutStopSec = 10;
      TimeoutStartSec = 3600;
    };
  };
  #home.sessionVariables = {
  #  EDITOR = "emacsclient -nw";
  #};
}
