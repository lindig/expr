

![Build](https://github.com/lindig/expr/workflows/CI/badge.svg)

# Expr

A simple [OCaml] library to evaluate an arithmetic expression. This
allows an application to accept expressions rather than just literal
values from the command line or any other input:

```ocaml
    match Expr.Eval.simple "3.0 * 12" with
    | Expr.Eval.Float x -> Printf.printf "%f" x
    | _
    | exception _ -> failwith "something went wrong"
```

```
$ make utop
utop # Expr.Eval.simple "3+4*5 == 23";;
- : Expr.Eval.value = Expr.Eval.Bool true

utop # let env = Expr.Eval.env ["pi", Float.pi] in
  Expr.Eval.string env "pi * pi";;
- : Expr.Eval.value = Expr.Eval.Float 9.86960440108935799
```

Features:
* Floating point and boolean expressions
* Expressions may contain floating point variables
* Proper precedence and associativity

# CLI

This code is intended as a library but includes a minimal command-line
binary that accept the string to evaluate as an argument:

```sh
./_build/default/bin/main.exe "3.0 * 3.0 * pi"
28.274334
```

# Usage

The code is so simple that I would suggest to copy the `lib/` directory
and use it and not bother with an opam installation.

# Documentation

To be done; but take a look at:

* eval.mli for the API
* parser.mly for the grammar
* scammer.mll for the syntax of tokens

# Contribute

If you find this useful, please contribute back by raising pull
requests for improvements you made.

[GitHub]:   https://www.github.com/
[OCaml]:    https://www.ocaml.org/
