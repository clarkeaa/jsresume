(require 'parenscript)

(in-package :parenscript)

(defun compile-fish ()
  (with-open-file (ostr "fish.js" 
                        :if-does-not-exist :create 
                        :direction :output 
                        :if-exists :overwrite)
    (let ((js (parenscript:ps-compile-file 
               "/Users/clarkeaa/dev/jsresume/fish.lisp")))
      (format ostr "~a" js))))
