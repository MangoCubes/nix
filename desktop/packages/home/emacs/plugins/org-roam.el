(straight-use-package 'org-roam)
(require 'org-roam)
(setq org-roam-directory (file-truename "~/Sync/Notes/Org"))

;; Cache node IDs automatically
(org-roam-db-autosync-mode)
(setq org-roam-dailies-directory "Daily/")
