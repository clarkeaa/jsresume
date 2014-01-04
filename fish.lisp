
(defvar *ctx* nil)
(defvar *width* 640)
(defvar *height* 480)
(defvar *position* 0)
(defvar *loc-widget-height* 20)
(defvar *loc-widget-knob-width* 26)
(defvar *ground-height* 100)
(defvar *fps* 30)
(defvar *frame* 0)
(defvar *fish-direction* 1)
(defvar *fish-width* 240)
(defvar *fish-height* 160)
(defvar *input-time* 0)
(defvar *min-position* -100)
(defvar *max-position* 1000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro ctx (func &rest args) (cons `(@ *ctx* ,func) args))

(defmacro clear () `(ctx clearRect 0 0 *width* *height*))

(defmacro with-ctx-state (&body body)
  `(progn 
     (ctx save)
     ,@body
     (ctx restore)))

(defmacro setf-rgb (data index red green blue)
  `(progn (setf (aref ,data ,index) ,red)
          (setf (aref ,data (+ 1 ,index)) ,green)
          (setf (aref ,data (+ 2 ,index)) ,blue)))

(defmacro with-mod-img-data ((pix-var x y width height) &body body)
  (let ((img-data (gensym)))
    `(let* ((,img-data (ctx getImageData ,x ,y ,width ,height))
            (,pix-var (@ ,img-data data)))      
       ,@body
       (ctx putImageData ,img-data ,x ,y))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun draw-loc-widget ()
  (setf (@ *ctx* fillStyle) "#ff0000")
  (setf (@ *ctx* lineWidth) 1)
  (setf (@ *ctx* strokeStyle) "#00ff00")
  (let ((loc-widget-top (- *height* *loc-widget-height*)))
    (ctx fillRect 0 loc-widget-top *width* *loc-widget-height*)
    (setf (@ *ctx* fillStyle) "#000000")
    (ctx strokeRect 
         (* (- *width* *loc-widget-knob-width*)
            (/ (- *position* *min-position*)
               (- *max-position* *min-position*)))
         loc-widget-top 
         *loc-widget-knob-width* 
         *loc-widget-height*)))

(defun handle-keyboard (event)
  (case (@ event keyCode)
    (37 (progn (setf *position* (max  (- *position* 5) *min-position*))
               (setf *fish-direction* -1)
               (setf *input-time* *frame*)))
    (39 (progn (setf *position* (min (+ *position* 5) *max-position*))
               (setf *fish-direction* 1)
               (setf *input-time* *frame*)))))

(defun draw-ground ()
  (setf (@ *ctx* fillStyle) "#996600")
  (let ((ground-top (- *height* *loc-widget-height* *ground-height*)))
    (ctx fillRect 0 ground-top *width* *ground-height*)
    (with-mod-img-data (pix 0 ground-top *width* *ground-height*)
      (dotimes (y *ground-height*)
        (dotimes (x *width*)
          (let* ((index (* 4 (+ x (* *width* y))))
                 (depth (+ 1.0 (* 0.5 (sin (+ (* x 1) 
                                              (* 7 y y) 
                                              *position*))))))
            (setf-rgb pix index (* depth 200) (* depth 100) 0)))))))

(defun draw-aaron-fish ()  
  (let* ((fish-index (% (Math.floor (/ *frame* 10)) 3))
         fish)
    (if (< (- *frame* *input-time*) 10)
        (case fish-index
          (0 (setf fish ((@ document getElementById) "fish1swim")))
          (1 (setf fish ((@ document getElementById) "fish2swim")))
          (2 (setf fish ((@ document getElementById) "fish3swim"))))
        (case fish-index
          (0 (setf fish ((@ document getElementById) "fish1")))
          (1 (setf fish ((@ document getElementById) "fish2")))
          (2 (setf fish ((@ document getElementById) "fish3")))))
    (with-ctx-state
        (let ((scalar 0.5;(+ 0.5 (/ *position* 1000))
               ))
          (ctx translate (/ *fish-width* 2) 80)
          (case *fish-direction*
            (-1 (ctx scale (* -1 scalar) scalar))
            (1 (ctx scale scalar scalar)))
          (ctx translate 0 20))
          (ctx translate (/ *fish-width* -2) -80)
      (let ((yoffset (* 4 (sin (* 2 pi 0.5 (/ *frame* *fps*))))))
        (ctx translate 0 yoffset))
      (ctx drawImage fish 0 0))))

(defun draw-water ()
  (let* ((water-height (- *height* *ground-height* *loc-widget-height*))
         (grad (ctx createLinearGradient 0 0 0 water-height)))
    ((@ grad addColorStop) 0 "#3377ff")
    ((@ grad addColorStop) 1 "#0000AA")
    (setf (@ *ctx* fillStyle) grad)
    (ctx fillRect 0 0 *width* water-height)))

(defun draw-title ()
  (let ((title ((@ document getElementById) "title")))
    (with-ctx-state
        (ctx translate (* -1 *position*) 0)
      (ctx drawImage title 0 0))))

(defun draw-weed (scalar x-offset y-offset parallax repeat-buffer anim-speed)
  (let* ((weed-index (% (Math.floor (/ *frame* anim-speed)) 3))
         weed)
    (case weed-index
      (0 (setf weed ((@ document getElementById) "weed1")))
      (1 (setf weed ((@ document getElementById) "weed2")))
      (2 (setf weed ((@ document getElementById) "weed3"))))
    (with-ctx-state
        (ctx translate 
             (- (+ *width* (/ repeat-buffer 2)) 
                (% (+ (* parallax *position*) x-offset) 
                   (+ *width* repeat-buffer))) 
             y-offset)
      (ctx scale scalar scalar)      
      (ctx drawImage weed 0 0))))

(defun draw ()
  (clear)
  (setf *frame* (+ *frame* 1))
  (draw-water)
  (draw-ground)
  (draw-weed 0.2 0 300 0.5 700 13)
  (draw-weed 0.2 0 300 0.5 300 11)
  (draw-weed 0.2 0 300 0.5 30 10.5)
  (draw-title)
  (draw-aaron-fish)
  (draw-loc-widget)
  (draw-weed 0.5 1000 280 2.0 700 13)
  (draw-weed 0.5 200 280 2.0 300 11)
  )

(defun main ()
  (let ((elem ((@ document getElementById) "resume-canvas")))
    (when elem
      (let ((ctx ((@ elem getContext) "2d")))
        (when ctx
          (setf *ctx* ctx)
          (draw)
          (setf (@ document onkeydown) handle-keyboard)
          (setInterval draw *fps*))))))
