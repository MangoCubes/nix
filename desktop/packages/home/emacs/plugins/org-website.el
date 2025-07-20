(defvar org-export-output-directory-prefix "export_" "prefix of directory used for org-mode export")

(defadvice org-export-output-file-name (before org-add-export-dir activate)
  "Modifies org-export to place exported files in a different directory"
  (when (not pub-dir)
      (setq pub-dir (concat org-export-output-directory-prefix (substring extension 1)))
      (when (not (file-directory-p pub-dir))
       (make-directory pub-dir))))
