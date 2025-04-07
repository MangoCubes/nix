;; Set the default font to DejaVu Sans Mono
(set-face-attribute 'default nil :font "DejaVu Sans Mono-12")

(set-fontset-font t 'unicode (font-spec :family "3270 Nerd Font" :size 12))

(set-fontset-font t 'hangul (font-spec :family "Noto Sans CJK" :size 12))

;; Ensure the font settings apply to new frames
;; (add-hook 'after-make-frame-functions
;;           (lambda (frame)
;;             (with-selected-frame frame
;;               (set-face-attribute 'default nil :font "DejaVu Sans Mono-12")
;;               (set-fontset-font t 'unicode (font-spec :family "3270 Nerd Font" :size 12)))))
;;
