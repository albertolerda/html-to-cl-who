(defpackage :html2clwho
  (:use :cl :plump :hunchentoot :cl-who))
(in-package :html2clwho)

(defun build-sexp (str)
  (labels
      ((iter (root)
         (cond
           ((text-node-p root)
            (let ((txt (string-trim '(#\Space #\Newline #\Backspace #\Tab 
                                      #\Linefeed #\Page #\Return #\Rubout)
                                    (render-text root))))
              (if (equal txt "") "" (format nil " \"~A\"" txt))))
	   ((comment-p root)
	    (format nil " #|~A|#" (build-sexp (render-text root))))
           (t 
            (let ((attrs (attributes root)))
              (format nil "~%(:~A~:{ :~A \"~A\"~}~{~A~})"
                      (tag-name root)
                      (loop for key being the hash-key of attrs
                            for value being the hash-value of attrs
                            collect (list key value))
                      (map 'list #'iter (children root))))))))
    (apply #'concatenate (cons 'string
			       (map 'list #'iter (children
						  (plump:parse str)))))))

(defvar *server* (make-instance 'easy-acceptor :port 3333))

(defmacro main-layout (title &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
     (:html
      (:head
       (:meta :charset "utf-8")
       (:meta :name "viewport" :content "width=device-width, inital-scale=1")
       (:title ,title)
       (:link :rel "stylesheet" :href "https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css"))
      (:body
       (:section :class "section"
                 (:div :class "container" 
                       ,@body))))))

(define-easy-handler (main-page :uri "/") (txt-html)
  (let ((txt-html (if txt-html txt-html ""))
        (result
          (if txt-html
              (build-sexp txt-html)
              "")))
    (main-layout "Convert"
      (:h1 :class "title" "Convert HTML to CL-WHO")
      (:p :class "subtitle" "Fill the text are with your HTML")
      (:form :action "/" :method "POST"
             (:div :class "field"
                   (:div :class "control"
                         (:textarea :class "textarea" :name "txt-html" (write-string txt-html))))
             (:div :class "control"
                   (:input :class "button" :type "submit")))
      (:div :class "container m-1" (:pre (write-string result))))))

(defun main ()
  (start *server*)
  (sleep most-positive-fixnum))
