(straight-use-package 'neotree)

(require 'neotree)
(global-set-key (kbd "<leader>s") 'neotree-show)
(global-set-key (kbd "<leader>S") 'neotree-find)
;; (define-key neotree-mode-map (kbd "a") 'neotree-create-node)
(setq neo-theme 'nerd-icons)
(add-hook 'neotree-mode-hook
	  (lambda () (local-set-key (kbd "a") 'neotree-create-node)))

;;(add-hook 'emacs-startup-hook 'neotree-show)
;;(add-hook 'after-init-hook #'neotree-toggle)
;;(setq dired-dwim-target t)
