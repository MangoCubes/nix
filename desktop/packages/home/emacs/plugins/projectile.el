(straight-use-package 'projectile)

(require 'projectile)

(projectile-mode +1)
;; Recommended keymap prefix on Windows/Linux
(define-key projectile-mode-map (kbd "<leader>p") 'projectile-command-map)
