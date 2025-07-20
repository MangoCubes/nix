(load-relative "./plugins/nerd-icons.el")
(load-relative "./common.el")
(load-relative "./plugins/mouse.el")
(load-relative "./plugins/org-download.el")
(load-relative "./plugins/org-mode.el")
(load-relative "./plugins/org-website.el")
(load-relative "./plugins/org-roam.el")
(load-relative "./plugins/fonts.el")
(load-relative "./plugins/notmuch.el")
(load-relative "./plugins/highlight.el")
(load-relative "./plugins/xkcd.el")
(load-relative "./plugins/lsp.el")
(load-relative "./plugins/korean.el")

(cond
  ((eq window-system 'x) (load-relative "./plugins/x11.el"))
  (t (load-relative "./plugins/wayland.el")))

