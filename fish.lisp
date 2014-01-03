
(defun main ()
  (let ((elem ((@ document getElementById) "resume-canvas")))
    (when elem
      (let ((ctx ((@ elem getContext) "2d")))
        (when ctx
          (setf (@ ctx fillStyle) "#0000ff")
          ((@ ctx fillRect) 0 0 640 480))))))
