;; Simplify yes-or-no prompt with simple y/n input
(defun ynp (prompt)
  "Press Y or N"
  (let ((answer (read-char (concat prompt " (y/n): ")) ))
	(if (eq answer ?y)
		t
	  (if (eq answer ?n)
		  nil
		(ynp prompt)))))

(defalias 'yes-or-no-p 'ynp)
