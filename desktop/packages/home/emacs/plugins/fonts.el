(defun configure-font (frame)
  "Modify fonts"
  (set-face-attribute 'default nil :font "FiraCode Nerd Font-18" :height (* default-scale 100))

  (set-fontset-font t 'hangul (font-spec :family "NotoSans Nerd Font" :size 18))
  )

(add-hook 'after-make-frame-functions #'configure-font)
