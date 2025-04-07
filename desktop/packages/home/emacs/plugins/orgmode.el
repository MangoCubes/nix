(require 'org)

(add-hook 'org-mode-hook 'display-line-numbers-mode)
(setq org-M-RET-may-split-line nil)
(setq org-latex-to-mathml-convert-command
      "latexmlmath %i --presentationmathml=%o")

(setq org-startup-with-inline-images t)
(defun orgmode-keybinds ()
  "Custom key bindings for Org mode."
  (local-set-key (kbd "M-<return>") 'org-meta-return))

(add-hook 'org-mode-hook 'orgmode-keybinds)

;; Set orgmode latex size
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
