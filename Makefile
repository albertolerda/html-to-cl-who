serve:
	sbcl --eval "(ql:quickload :html2clwho)" \
	     --eval "(asdf:load-system :html2clwho)" \
	     --eval "(html2clwho::main)"
