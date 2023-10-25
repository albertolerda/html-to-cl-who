(in-package :common-lisp-user)

(require :asdf)

(declaim (optimize (speed 3) (space 3) (safety 3)))

(asdf:load-system "asdf")

(asdf:initialize-source-registry '(:source-registry (:tree :here) :inherit-configuration))

;;; try to find Quicklisp -- this is a mess because it isn't consistently installed in the
;;; same location.
(if (uiop:find-package* '#:ql nil)
    (format t "~&Quicklisp pre-loaded into image.~%")
    (let ((ql-filename (uiop:getenv "QUICKLISP_SETUP"))
          loaded)
      (if ql-filename
          (if (probe-file ql-filename)
              (let ((result (load ql-filename :if-does-not-exist nil)))
                (when result
                  (format t "~&Have loaded quicklisp setup file ~a.~%" ql-filename)
                  (setf loaded t)))
              (format t "Quicklisp not installed where expected: ~a~%" ql-filename)))
      (unless loaded
        (let* ((fallback-name "/root/quicklisp/setup.lisp")
               (result (load fallback-name :if-does-not-exist nil)))
          (when result
            (format t "~&Have loaded quicklisp setup file from /root.~%")
            (setf loaded t))))
      (unless loaded
        (format t "~&Unable to find quicklisp.~%")
        (uiop:quit 1 t))))

