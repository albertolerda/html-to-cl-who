serve:
	sbcl --eval "(ql:quickload :html-conv)" \
	     --eval "(asdf:load-system :html-conv)" \
	     --eval "(html-conv::main)"
