FROM clfoundation/sbcl:alpine3.14 as builder

COPY . /root/common-lisp/
WORKDIR /root/common-lisp/

# https://www.reddit.com/r/Common_Lisp/comments/pdsqbe/installing_quicklisp/
# https://github.com/yitzchak/common-lisp-jupyter/blob/master/Dockerfile
ENV QUICKLISP_ADD_TO_INIT_FILE=true
RUN sbcl --non-interactive --load quicklisp.lisp \
      --eval "(quicklisp-quickstart:install)" \
      --eval "(ql-util:without-prompting (ql:add-to-init-file))"

RUN sbcl --eval "(ql:quickload :html2clwho)" \
         --load html2clwho.lisp \
         --eval "(sb-ext:save-lisp-and-die \"core\" :toplevel #'html2clwho::main :executable t)"

FROM clfoundation/sbcl:alpine3.14

RUN adduser -D app
USER app

COPY --from=builder /root/common-lisp/core .

EXPOSE 3333

ENTRYPOINT [ "sbcl", "--core", "core" ]
