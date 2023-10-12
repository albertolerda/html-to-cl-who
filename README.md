# HTML to CL-WHO

`cl-who` is a common library for HTML rendering in Common Lisp. The main issue is that all the example online are written in HTML... This tool lets you convert HTML to Sexp!

## Getting started (without docker)
1. Clone the repo into `~/common-lisp` (or a path recognized by ASDF)
```
git clone https://github.com/albertolerda/html-to-cl-who.git
```
2. Run (inside sbcl)
```
(ql:quickload :html2clwho)
(asdf:load-system :html2clwho)
(html-conv::main)

```

Now you can open the Browser: [localhost:3333](http://localhost:3333/)

## Getting started (with docker)
1. Clone the repo
```
git clone https://github.com/albertolerda/html-to-cl-who.git
```
2. Build the image (sometimes it crashes, just run it again)
```
docker build -t html2clwho .
```
3. Run it!
```
docker run -p 3333:3333 --rm html2clwho
```

Now you can open the Browser: [localhost:3333](http://localhost:3333/)

## More reference
[Youtube Demo](https://www.youtube.com/watch?v=269tBEWzke4&list=PLFdMuo0ICT2C3gOqkDL83bpBhJtsF9e5r)

More info on asdf:
[ASDF Config](https://asdf.common-lisp.dev/asdf/Configuring-ASDF-to-find-your-systems.html)
[ASDF Loading](https://asdf.common-lisp.dev/asdf/Loading-a-system.html)

## Authors

- [@albertolerda](https://www.github.com/albertolerda)

## License

[MIT](https://choosealicense.com/licenses/mit/)

