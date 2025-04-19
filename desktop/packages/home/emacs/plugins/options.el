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
(setq display-line-numbers-type 'relative)  ;; Set line numbers to relative

;; Remove sound
(setq visible-bell 1)
;; Use visual line mode
(global-visual-line-mode 1)
