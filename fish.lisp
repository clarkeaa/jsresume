
(defvar *ctx* nil)
(defvar *width* 640)
(defvar *height* 480)
(defvar *position* 0)
(defvar *loc-widget-height* 20)

(defmacro ctx (func &rest args) (cons `(@ *ctx* ,func) args))
(defmacro clear () `(ctx clearRect 0 0 *width* *height*))

(defun draw-loc-widget ()
  (setf (@ *ctx* fillStyle) "#ff0000")
  (setf (@ *ctx* lineWidth) 1)
  (setf (@ *ctx* strokeStyle) "#00ff00")
  (let ((loc-widget-top (- *height* *loc-widget-height*)))
    (ctx fillRect 0 loc-widget-top *width* *loc-widget-height*)
    (ctx strokeRect 0 loc-widget-top *width* *loc-widget-height*)))

(defun draw ()
  (clear)
  (setf (@ *ctx* fillStyle) "#0000ff")
  (ctx fillRect 0 0 *width* *height*)
  (draw-loc-widget)
  )

(defun main ()
  (let ((elem ((@ document getElementById) "resume-canvas")))
    (when elem
      (let ((ctx ((@ elem getContext) "2d")))
        (when ctx
          (setf *ctx* ctx)
          (draw)
          (setInterval draw 30))))))
