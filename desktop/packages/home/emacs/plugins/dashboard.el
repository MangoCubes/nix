;;
;;;; Open dashboard on opening emacsclient
;;(setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
;;
;;;; Centre the contents
(setq dashboard-center-content t)
;;
;;;; Set banner
;;;;(setq dashboard-startup-banner (cons (expand-file-name "~/.config/configMedia/emacs/banner.png") (expand-file-name "~/.config/configMedia/emacs/banner.txt")))
;;(setq dashboard-startup-banner 'official)

;;(use-package dashboard
;;	:ensure t
;;	:config
;;	(setq dashboard-display-icons-p t)     ; display icons on both GUI and terminal
;;	(setq dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
;;	(setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
;;	(dashboard-modify-heading-icons '((recents . "nf-oct-file_text") (bookmarks . "nf-oct-book")))
;;
;;	(setq dashboard-set-heading-icons t)
;;	(setq dashboard-set-file-icons t)
;;	(dashboard-setup-startup-hook)
;;)
(straight-use-package 'dashboard)
;;;; Open dashboard on startup
;; (dashboard-setup-startup-hook)

(setq org-format-latex-options (plist-put org-format-latex-options :scale ))
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-startup-banner banner)
	(setq dashboard-set-heading-icons t)
	(setq dashboard-image-banner-max-height (* default-scale 300))  ;; Set the maximum height
	(setq dashboard-image-banner-max-width (* default-scale 700))    ;; Set the maximum width
	(setq dashboard-set-file-icons t)
	(dashboard-modify-heading-icons '((recents . "nf-oct-file_text") (bookmarks . "nf-oct-book")))
	(setq dashboard-items '((recents . 5)
                        (bookmarks . 5)
                        ))
  (dashboard-setup-startup-hook))
(setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
