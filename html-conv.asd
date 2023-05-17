(asdf:defsystem "html-conv"
  :description "Convert html to cl-who"
  :version "0.0.1"
  :author "Alberto Lerda"
  :licence "Public Domain"
  :depends-on ("plump" "command-line-arguments" "hunchentoot" "cl-who")
  :components ((:file "html-conv")))
