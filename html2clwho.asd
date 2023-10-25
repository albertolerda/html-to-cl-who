(asdf:defsystem "html2clwho"
  :description "Convert html to cl-who"
  :version "0.0.1"
  :author "Alberto Lerda"
  :licence "Public Domain"
  :depends-on ("plump" "hunchentoot" "cl-who")
  :components ((:file "html2clwho"))
  :in-order-to ((test-op (test-op "html2clwho/tests"))))

(asdf:defsystem "html2clwho/tests"
    :depends-on ("html2clwho" "fiveam")
    :components ((:file "test"))
    :perform (test-op (o c) (symbol-call :html2clwho.test :run-tests)))


;; test-op should signal a condition
;; https://asdf.common-lisp.dev/asdf.html#test_002dop
