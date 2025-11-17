

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

```ocaml
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

# Installation

The code is so simple that I would suggest to copy the `lib/` directory
and use it and not bother with an opam installation:

```sh
$ opam pin add expr https://github.com/lindig/expr.git
```

or

```sh
$ opam install expr
```

once this package has been merged into the official Opam repository.

# Documentation

To be done; but take a look at:

* eval.mli for the API
* parser.mly for the grammar
* scammer.mll for the syntax of tokens

```ocaml
utop # let eval = Expr.Eval.simple;;
val eval : string -> Expr.Eval.value = <fun>
─( 11:22:25 )─< command 1 >──────────────────────────────────────{ counter: 0 }─
utop # eval "3+4*4";;
- : Expr.Eval.value = Expr.Eval.Float 19.
─( 11:22:53 )─< command 2 >──────────────────────────────────────{ counter: 0 }─
utop # eval "-3 < 0";;
- : Expr.Eval.value = Expr.Eval.Bool true
─( 11:23:22 )─< command 3 >──────────────────────────────────────{ counter: 0 }─
utop # eval "(5+3)*3";;
- : Expr.Eval.value = Expr.Eval.Float 24.
─( 11:23:48 )─< command 4 >──────────────────────────────────────{ counter: 0 }─
utop # eval "4 = [0,5]";;
- : Expr.Eval.value = Expr.Eval.Bool true
```

# Contribute

If you find this useful, please contribute back by raising pull
requests for improvements you made.

[GitHub]:   https://www.github.com/
[OCaml]:    https://www.ocaml.org/
