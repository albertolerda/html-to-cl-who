(defpackage :html2clwho.test
  (:use :cl :html2clwho :fiveam))
(in-package :html2clwho.test)

(def-suite html2clwho-suite :description "Build sexp from html")
(in-suite html2clwho-suite)

(defun is-html (str sexp)
  (is (equal (string-trim '(#\Newline) (html2clwho::build-sexp str)) sexp)))

(def-test empty-tag ()
  (is-html "<html></html>" "(:html)"))

(def-test some-classes ()
  (is-html "<div class=\"col-md-4\"></div>" "(:div :class \"col-md-4\")"))

(def-test some-content ()
  (is-html "<div><span>Hello</span></div>" "(:div
(:span \"Hello\"))"))

;; https://stackoverflow.com/questions/54889460/asdftest-system-from-a-makefile-doesnt-return-an-error-return-code
(defun run-tests ()
  (run! 'html2clwho-suite))
