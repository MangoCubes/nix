{
  unstable,
  device,
  pkgs,
  inputs,
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
  emacsload = pkgs.writeShellScriptBin "emacsload" ''${envs} emacs -q --daemon --load ${init}'';
in
{
  # Short for Emacs Server
  programs.bash.shellAliases.er = "emacsclient -e '(kill-emacs)'; emacsload";
  programs.bash.shellAliases.ef = "${envs} emacs -q --fg-daemon --load ${init}";
  home.packages = [
    emacsload
  ]
  ++ (with pkgs; [
    perl538Packages.LaTeXML
    texliveMedium
    xwayland-satellite
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
    package = unstable.emacs; # unstable.emacs-pgtk;
  };
}
