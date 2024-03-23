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

(def-test simple-comment ()
  (is-html "<html><!--with comment--></html>"
	   "(:html #| \"with comment\"|#)"))

(def-test complex-comment ()
  (is-html " <p>This is a paragraph.</p>
<!--
<p>Look at this cool image:</p>
<img border=\"0\" src=\"pic_trulli.jpg\" alt=\"Trulli\">
-->
<p>This is a paragraph too.</p> "
	   "(:p \"This is a paragraph.\") #|
(:p \"Look at this cool image:\")
(:img :border \"0\" :src \"pic_trulli.jpg\" :alt \"Trulli\")|#
(:p \"This is a paragraph too.\")"))

;; https://stackoverflow.com/questions/54889460/asdftest-system-from-a-makefile-doesnt-return-an-error-return-code
(defun run-tests ()
  (run! 'html2clwho-suite))
