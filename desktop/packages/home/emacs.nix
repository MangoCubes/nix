{
  unstable,
  headless,
  pkgs,
  inputs,
  scale,
  ...
}:
let
  configFile = if headless then "headless.el" else "desktop.el";
  vars = ''
    (defvar banner "${inputs.secrets.res}/media/emacs/banner.jpg")
    (defvar default-scale ${toString (scale)})
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
  programs.bash.shellAliases.es = "emacs -q --daemon --load ~/Sync/NixConfig/desktop/packages/home/emacs/init.el";
  # programs.bash.shellAliases.e = "emacsclient -c";
  # programs.bash.shellAliases.te = "kitty --detach emacsclient -c";
  home.packages = (
    with pkgs;
    [
      perl538Packages.LaTeXML
      texliveMedium
    ]
  );
  xdg = {
    desktopEntries = {
      emacs = {
        name = "Emacs Client";
        genericName = "Text Editor";
        exec = ''emacsclient -c'';
        terminal = false;
        # categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/plain" ];
      };
      emacs-nw = {
        name = "Emacs Client (No Window)";
        genericName = "Text Editor";
        exec = ''emacsclient -nw'';
        terminal = true;
        # categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/plain" ];
      };
      emacsclient = {
        noDisplay = true;
        name = "";
      };
    };
  };
  programs.emacs = {
    enable = true;
    package = unstable.emacs;
    extraConfig = configData;
    # extraPackages =
    #   epkgs: with epkgs; [
    #     mu4e
    #   ];
  };
  services.emacs = {
    enable = true;
    startWithUserSession = if headless then true else "graphical";
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
