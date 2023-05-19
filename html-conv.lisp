(defpackage :html-conv
  (:use :cl :plump :hunchentoot :cl-who :parenscript))
(in-package :html-conv)

(defun build-sexp (str)
  (labels
      ((iter (root)
         (cond
           ((text-node-p root)
            (let ((txt (string-trim '(#\Space #\Newline #\Backspace #\Tab 
                                      #\Linefeed #\Page #\Return #\Rubout)
                                    (text root))))
              (if (equal txt "") "" (format nil " \"~A\"" txt))))
           (t 
            (let ((attrs (attributes root)))
              (format nil "~%(:~A~:{ :~A \"~A\"~}~{~A~})"
                      (tag-name root)
                      (loop for key being the hash-key of attrs
                            for value being the hash-value of attrs
                            collect (list key value))
                      (map 'list #'iter (children root))))))))
    (apply #'concatenate (cons 'string (map 'list #'iter (children (plump:parse str)))))))

(start (make-instance 'easy-acceptor :port 3333))

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

(define-easy-handler (main-page :uri "/") ()
  (main-layout "Convert"
    (:h1 :class "title" "Convert HTML to CL-WHO")
    (:p :class "subtitle" "Fill the text are with your HTML")
    (:form :action "/" :method "POST" :id "frmHtml"
           (:div :class "field"
                 (:div :class "control"
                       (:textarea :class "textarea" :name "txtHtml")))
           (:div :class "control"
                 (:input :class "button" :type "submit")))
    (:div :class "container m-1" (:pre :id "resultSexp"))
    (:script
     (str
      (ps
        (defun build-sexp (str)
          (let* ((elem (chain document (create-element "div"))))
            (setf (@ elem inner-h-t-m-l) str)
            (labels
                ((print-attributes (tag)
                   (let ((result ""))
                     (loop for i from 0 to (1- (getprop tag 'attributes 'length))
                           do (let ((attribute (getprop tag 'attributes i)))
                                (setf result (concatenate 'string result
                                                          " :"
                                                          (@ attribute local-name)
                                                          " \"" (@ attribute value) "\""))))
                     result))
                 (iter (root)
                   (if (> (@ root children length) 0)
                       (let ((result ""))
                         (loop for i from 0 to (1- (@ root children length))
                               do (let ((tag (getprop root 'children i)))
                                    (setf result (concatenate 'string
                                                              result #\Newline "(:"
                                                              (chain tag tag-name (to-lower-case))
                                                              (print-attributes tag)
                                                              (iter tag)
                                                              ")"))))
                         result)
                       (let ((text (chain (getprop root 'inner-text) (trim))))
                         (if (equal text "") text  (concatenate 'string " \"" text "\"")))))))
            (setf (@ result-sexp inner-h-t-m-l) (chain (iter elem) (trim)))))
        (defvar frm-html nil)
        (defvar result-sexp nil)
        (defun handle-convertion (evt)
          (chain evt (prevent-default))
          (setf (@ result-sexp inner-text) (build-sexp (@ frm-html txt-html value))))
        (defun init ()
          (setf frm-html (chain document (get-element-by-id "frmHtml")))
          (setf result-sexp (chain document (get-element-by-id "resultSexp")))
          (chain frm-html (add-event-listener "submit"
                                              handle-convertion)))
        (setf (chain window onload) init))))))

