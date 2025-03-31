(load-relative "./plugins/nerd-icons.el")
(load-relative "./common.el")
(load-relative "./plugins/mouse.el")
(load-relative "./plugins/org-download.el")

(cond
  ((eq window-system 'x) (load-relative "./plugins/x11.el"))
  (t (load-relative "./plugins/wayland.el")))

