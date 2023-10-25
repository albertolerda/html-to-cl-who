#!/bin/bash

sbcl --non-interactive \
     --load 'load-deps.lisp' \
     --eval '(ql:quickload :html2clwho/tests)' \
     --eval '(asdf:load-system :html2clwho)' \
     --eval '(uiop:quit (if (html2clwho.test::run-tests) 0 1))'
