(defun configure-font (frame)
  "Modify fonts"
  (set-face-attribute 'default nil :font "FiraCode Nerd Font-18" :height (floor (* default-scale 120)))

  (set-fontset-font t 'hangul (font-spec :family "NotoSans KR" :size 18))
)

(add-hook 'after-make-frame-functions #'configure-font)
