
(defvar *ctx* nil)
(defvar *width* 640)
(defvar *height* 480)
(defvar *position* 0)
(defvar *loc-widget-height* 20)
(defvar *loc-widget-knob-width* 20)
(defvar *ground-height* 100)
(defvar *fps* 30)
(defvar *frame* 0)
(defvar *fish-direction* 1)
(defvar *fish-width* 240)
(defvar *fish-height* 160)

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
    (ctx strokeRect 0 loc-widget-top *width* *loc-widget-height*)
    (setf (@ *ctx* fillStyle) "#000000")
    (ctx fillRect 
         (- *position* (/ *loc-widget-knob-width* 2))
         loc-widget-top 
         *loc-widget-knob-width* 
         *loc-widget-height*)))

(defun handle-keyboard (event)
  (case (@ event keyCode)
    (37 (progn 
          (setf *position* (- *position* 1))
          (setf *fish-direction* -1)))
    (39 (progn (setf *position* (+ *position* 1))
               (setf *fish-direction* 1)))))

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
    (case fish-index
      (0 (setf fish ((@ document getElementById) "fish1")))
      (1 (setf fish ((@ document getElementById) "fish2")))
      (2 (setf fish ((@ document getElementById) "fish3"))))
    (with-ctx-state
        (case *fish-direction*
          (-1 (progn
                (ctx translate 120 0)
                (ctx scale -1 1)
                (ctx translate -120 0)))
          (1 (progn
               (ctx scale 1 1))))
      (let ((yoffset (* 2 (sin (* 2 pi 0.5 (/ *frame* *fps*))))))
        (ctx translate 0 yoffset))
      ;; (let ((scalar (+ 0.5 (/ *position* 100))))
      ;;   (ctx scale scalar scalar))
      (ctx drawImage fish 0 0))))

(defun draw ()
  (clear)
  (setf *frame* (+ *frame* 1))
  (setf (@ *ctx* fillStyle) "#0000ff")
  (ctx fillRect 0 0 *width* *height*)
  (draw-ground)
  (draw-aaron-fish)
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
          (setInterval draw *fps*)
          )))))
