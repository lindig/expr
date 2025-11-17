(lang dune 2.7)

(name expr)

(generate_opam_files true)

(source
 (github lindig/expr))

(license Unlicense)

(authors "Christian Lindig <lindig@gmail.com>")

(maintainers "Christian Lindig <lindig@gmail.com>")

(package
 (name expr)
 (synopsis "Simple library to parse expressions")
 (description
  "A simple library to parse and evaluate arithmetic expressions that
  may include variables. The purpose is for other code to accept an
  expression rather than just a literal value. Both float and boolean
  expressions are supported.")
 (depends
  (ocaml
   (>= 4.08.0))
  (cmdliner
   (and
    (>= 1.1.0)
    (< 2.0.0)))))
