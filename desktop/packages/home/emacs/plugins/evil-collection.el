
(setq evil-want-integration t)
(straight-use-package 'evil-collection)
;; Set up Evil collection

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init)
  (setq evil-collection-key-blacklist '("M-<return>")))
