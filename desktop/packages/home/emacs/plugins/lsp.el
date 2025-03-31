(straight-use-package 'lsp-ui)

(require 'lsp-ui)

(straight-use-package 'lsp-mode)

(require 'lsp-mode)

;; Enable LSP for Lua mode
(add-hook 'lua-mode-hook #'lsp)

;; Optional: Enable LSP UI features
(add-hook 'lsp-mode-hook
          (lambda ()
            (lsp-ui-mode 1)))
