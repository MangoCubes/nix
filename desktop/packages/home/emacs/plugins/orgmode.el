(straight-use-package 'org)
(require 'org)

;; Org-mode isn't prog-mode, and line number needs to be added manually
(add-hook 'org-mode-hook 'display-line-numbers-mode)
;; Same goes for visual line mode
(add-hook 'org-mode-hook 'visual-line-mode)

;; M-RET never splits a line
(setq org-M-RET-may-split-line nil)
(setq org-latex-to-mathml-convert-command
      "latexmlmath %i --presentationmathml=%o")

(setq org-startup-with-inline-images t)
(defun orgmode-keybinds ()
  "Custom key bindings for Org mode."
  (local-set-key (kbd "M-<return>") 'org-meta-return))

(add-hook 'org-mode-hook 'orgmode-keybinds)

;; Set orgmode latex size
(setq org-format-latex-options (plist-put org-format-latex-options :scale (* default-scale 1.5)))
(setq org-default-notes-file "~/Sync/Notes/Org/Agenda/Captures.org")
