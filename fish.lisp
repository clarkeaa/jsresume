
(defvar *ctx* nil)
(defvar *width* 640)
(defvar *height* 480)

(defun draw ()
  ((@ *ctx* clearRect) 0 0 640 480)
  (setf (@ *ctx* fillStyle) "#0000ff")
  ((@ *ctx* fillRect) 0 0 640 480))

(defun main ()
  (let ((elem ((@ document getElementById) "resume-canvas")))
    (when elem
      (let ((ctx ((@ elem getContext) "2d")))
        (when ctx
          (setf *ctx* ctx)
          (draw)
          (setInterval draw 30))))))
