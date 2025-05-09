(straight-use-package 'org)
(require 'org)

;; Enable org indent mode by default
(setq org-startup-indented t)

;; Org-mode isn't prog-mode, and line number needs to be added manually
(add-hook 'org-mode-hook 'display-line-numbers-mode)

;; M-RET never splits a line
(setq org-M-RET-may-split-line nil)
(setq org-latex-to-mathml-convert-command
      "latexmlmath %i --presentationmathml=%o")

;; Add inline images
(setq org-startup-with-inline-images t)
(defun orgmode-keybinds ()
  "Custom key bindings for Org mode."
  (local-set-key (kbd "M-<return>") 'org-meta-return))
(add-hook 'org-mode-hook 'orgmode-keybinds)

;; Enable latex preview by default
(setq org-startup-latex-with-latex-preview t)

;; Set orgmode latex size
(setq org-format-latex-options (plist-put org-format-latex-options :scale (* default-scale 1.5)))
(setq org-default-notes-file "~/Sync/Notes/Org/Agenda/Captures.org")

;; Add org-appear plugin
;; It reveals text representation of certain elements when the cursor is over them
(straight-use-package '(org-appear :type git :host github :repo "awth13/org-appear"))
(require 'org-appear)
(add-hook 'org-mode-hook 'org-appear-mode)

;; Add org-fragtop
;; It automatically converts maths equations to latex fragments
(straight-use-package '(org-fragtog :type git :host github :repo "io12/org-fragtog"))
(require 'org-fragtog)
(add-hook 'org-mode-hook 'org-fragtog-mode)

