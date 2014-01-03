
(defvar *ctx* nil)
(defvar *width* 640)
(defvar *height* 480)
(defvar *position* 0)
(defvar *loc-widget-height* 20)
(defvar *loc-widget-knob-width* 20)
(defvar *ground-height* 100)

(defmacro ctx (func &rest args) (cons `(@ *ctx* ,func) args))
(defmacro clear () `(ctx clearRect 0 0 *width* *height*))

(defun draw-loc-widget ()
  (setf (@ *ctx* fillStyle) "#ff0000")
  (setf (@ *ctx* lineWidth) 1)
  (setf (@ *ctx* strokeStyle) "#00ff00")
  (let ((loc-widget-top (- *height* *loc-widget-height*)))
    (ctx fillRect 0 loc-widget-top *width* *loc-widget-height*)
    (ctx strokeRect 0 loc-widget-top *width* *loc-widget-height*)
    (setf (@ *ctx* fillStyle) "#000000")
    (ctx fillRect 
         (- *position* (/ *loc-widget-knob-width* 2))
         loc-widget-top 
         *loc-widget-knob-width* 
         *loc-widget-height*)))

(defun handle-keyboard (event)
  (case (@ event keyCode)
    (37 (setf *position* (- *position* 1)))
    (39 (setf *position* (+ *position* 1)))))

(defun draw-ground ()
  (setf (@ *ctx* fillStyle) "#996600")
  (let ((ground-top (- *height* *loc-widget-height* *ground-height*)))
    (ctx fillRect 0 ground-top *width* *ground-height*)))

(defun draw ()
  (clear)
  (setf (@ *ctx* fillStyle) "#0000ff")
  (ctx fillRect 0 0 *width* *height*)
  (draw-ground)
  (draw-loc-widget)
  )

(defun main ()
  (let ((elem ((@ document getElementById) "resume-canvas")))
    (when elem
      (let ((ctx ((@ elem getContext) "2d")))
        (when ctx
          (setf *ctx* ctx)
          (draw)
          (setf (@ document onkeydown) handle-keyboard)
          (setInterval draw 30))))))
