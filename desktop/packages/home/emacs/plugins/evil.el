(straight-use-package 'evil)

(setq evil-want-keybinding nil)
(use-package undo-tree
  :ensure t
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))

(setq evil-want-fine-undo t)

(require 'evil)
(setq evil-want-integration t)



(straight-use-package 'evil-collection)
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(evil-mode 1)
(global-set-key [remap evil-quit] 'kill-buffer-and-window)

(evil-set-leader 'normal (kbd "SPC"))
(evil-add-command-properties #'find-file :jump t)
