;; Emacs native options go here
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)

(setq standard-indent 4)
(setq-default tab-width 4)
;;(global-font-lock-mode 1)

;; Remove sound
(setq visible-bell 1)

;; Use visual line mode
(add-hook 'prog-mode-hook 'visual-line-mode)

;; Set line numbers to relative
(setq display-line-numbers-type 'relative)
;; Enable line number in most modes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)


