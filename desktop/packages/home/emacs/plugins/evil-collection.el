
(straight-use-package 'evil-collection)
;; Set up Evil collection
(setq evil-want-keybinding nil)
(setq evil-want-integration t)

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init)
  (setq evil-collection-key-blacklist '("M-<return>")))
