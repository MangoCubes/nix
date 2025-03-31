(straight-use-package 'dirvish)

(require 'dirvish)
(dirvish-override-dired-mode)
(global-set-key (kbd "<leader>s") 'dirvish-side)
;;(global-set-key (kbd "<leader>S") 'neotree-projectile-action)
;;(define-key neotree-mode-map (kbd "a") 'neotree-create-node)
(evil-make-overriding-map dirvish-mode-map 'normal)
(setq dirvish-attributes
        '(all-the-icons file-time file-size collapse subtree-state vc-state git-msg))
