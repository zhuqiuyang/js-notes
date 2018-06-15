(defun sum (&rest nums)
  (let ((acc 0))
    (dolist (num nums)
      (setf acc (+ acc num))
    )
    (format t "Sum: ~a ~%" acc)
  )
)
(sum 1 2 3 4)
