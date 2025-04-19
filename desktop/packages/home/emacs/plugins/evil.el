;; Install packages
(straight-use-package 'evil)
(straight-use-package 'evil-collection)
(straight-use-package 'undo-tree)

;; Set up Evil collection
(setq evil-want-keybinding nil)
(setq evil-want-integration t)
;; Set up better undo
(setq evil-want-fine-undo t)
;; Use visual line instead of actual lines
(setq evil-respect-visual-line-mode t)
;; Set up undotree
(use-package undo-tree
  :ensure t
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))


(require 'evil)

;; Allow moving between lines
(setq evil-cross-lines t)
;; Use evil mode in minibuffer
(setq evil-want-minibuffer t)

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; Enable Evil mode
(evil-mode 1)
;; Make evil quit kill buffer as well as the window
(global-set-key [remap evil-quit] 'kill-buffer-and-window)

;; Set space to leader
(evil-set-leader 'normal (kbd "SPC"))

;; Make find-file count as jump
(evil-add-command-properties #'find-file :jump t)
;; Make mouse click count as jump
(evil-add-command-properties #'mouse-set-point :jump t)
