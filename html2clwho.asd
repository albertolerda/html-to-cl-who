(asdf:defsystem "html2clwho"
  :description "Convert html to cl-who"
  :version "0.0.1"
  :author "Alberto Lerda"
  :licence "Public Domain"
  :depends-on ("plump" "hunchentoot" "cl-who")
  :components ((:file "html2clwho")))
