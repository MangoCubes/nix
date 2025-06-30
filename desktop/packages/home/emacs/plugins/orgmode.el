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

;; (defun my/orgmode-keybinds ()
;;   "Custom key bindings for Org mode."
;;   (local-set-key (kbd "M-<return>") 'org-meta-return))
;; (add-hook 'org-mode-hook 'my/orgmode-keybinds)

;; Enable latex preview by default
;; This is not working...
;; (setq org-startup-latex-with-latex-preview t)
(defun my/org-latex-preview-entire-document ()
  "Preview the entire Org document."
  (save-excursion
    (let ((org-latex-preview-default-process 'dvi)) ; Change to 'pdf if needed
	  (let ((current-prefix-arg '(2))) (org-latex-preview)))))



;; Set orgmode latex size
(setq org-format-latex-options (plist-put org-format-latex-options :scale (* default-scale 1.5)))
(setq org-default-notes-file "~/Sync/Notes/Org/Agenda/Captures.org")

;; Add org-appear plugin
;; It reveals text representation of certain elements when the cursor is over them
(straight-use-package '(org-appear :type git :host github :repo "awth13/org-appear"))
(require 'org-appear)
(add-hook 'org-mode-hook 'org-appear-mode)


(defun my/org-mode-setup ()
  "Automatically run `org-id-get-create` when creating a new Org document, and create TITLE"
  (when (and (buffer-file-name)
			 (eq major-mode 'org-mode)
			 (not (string-match-p (format-time-string "^%Y-%m-%d") (file-name-nondirectory (buffer-file-name)))))
    (org-id-get-create))
  (when (and (buffer-file-name)
			 (eq major-mode 'org-mode)
    		 (not (re-search-forward "^#\\+TITLE:" nil t)))
  (let ((filename (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    (goto-char (point-max))
    (insert (format "\n#+TITLE: %s\n" filename)))))

(add-hook 'org-mode-hook 'my/org-mode-setup)


(defun my/org-mode-save-hook ()
  "Function to run after saving an Org mode file."
  (when (eq major-mode 'org-mode)
    'my/org-latex-preview-entire-document))

(add-hook 'after-save-hook 'my/org-mode-save-hook)
;; Add org-fragtop
;; It automatically converts maths equations to latex fragments
;; Unfortunately, this is buggy
;; (straight-use-package '(org-fragtog :type git :host github :repo "io12/org-fragtog"))
;; (require 'org-fragtog)
;; (add-hook 'org-mode-hook 'org-fragtog-mode)

