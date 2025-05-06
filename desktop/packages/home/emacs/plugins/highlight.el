(straight-use-package 'volatile-highlights)
(require 'volatile-highlights)
(volatile-highlights-mode t)

;;-----------------------------------------------------------------------------
;; Supporting evil-mode.
;;-----------------------------------------------------------------------------
(vhl/define-extension 'evil 'evil-paste-after 'evil-paste-before
                      'evil-paste-pop 'evil-move)
(vhl/install-extension 'evil)

;;-----------------------------------------------------------------------------
;; Supporting undo-tree.
;;-----------------------------------------------------------------------------
(vhl/define-extension 'undo-tree 'undo-tree-yank 'undo-tree-move)
(vhl/install-extension 'undo-tree)
