(defun my/open-terminal-in-new-tab ()
  (interactive)
  (tab-new)  ;; Create a new tab
  (ansi-term "bash"))  ;; Change "/bin/bash" to your preferred shell

;; Bind the function to <leader> t
(global-set-key (kbd "<leader>tt") 'my/open-terminal-in-new-tab)
(global-set-key (kbd "<leader>tn") 'tab-new)
(global-set-key (kbd "<leader>tq") 'tab-close)
