

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

The [Cmdliner] library can be extended to provide expression arguments:

```ocaml
module C = Cmdliner
module CmdlinerExpr = struct
  let error fmt = Printf.ksprintf (fun msg -> Error (`Msg msg)) fmt
  let env = Expr.Eval.env [ ("pi", Float.pi); ("e", Float.exp 1.0) ]

  let of_string s =
    match Expr.Eval.string env s with
    | Expr.Eval.Float x -> Ok x
    | _ | (exception _) -> error "%S is not a float expression" s

  let to_string pp x = Format.pp_print_float pp x
  let t = C.Arg.conv (of_string, to_string)
end

let float =
  C.Arg.(
    value & pos 0 CmdlinerExpr.t 0.0
    & info [] ~docv:"EXPR" ~doc:"Numerical expression")

```

Above, `float` represents a positional argument providing a float value;
unline the built-in Cmdliner float, this one is the result of an
expression that the user provided.

# Installation

The code is so simple that I would suggest to copy the `lib/` directory
and use it and not bother with an opam installation:

```sh
$ opam install expr
```

or for the development version

```sh
$ opam pin add expr https://github.com/lindig/expr.git
```


once this package has been merged into the official Opam repository.

# Documentation

To be done; but take a look at:

* eval.mli for the API
* parser.mly for the grammar
* scammer.mll for the syntax of tokens

```ocaml
$ make utop
utop # let eval = Expr.Eval.simple;;
val eval : string -> Expr.Eval.value = <fun>

utop # eval "3+4*4";;
- : Expr.Eval.value = Expr.Eval.Float 19.

utop # eval "-3 < 0";;
- : Expr.Eval.value = Expr.Eval.Bool true

utop # eval "(5+3)*3";;
- : Expr.Eval.value = Expr.Eval.Float 24.

utop # eval "4 = [0,5]";;
- : Expr.Eval.value = Expr.Eval.Bool true
```

# Contribute

If you find this useful, please contribute back by raising pull
requests for improvements you made.

[GitHub]:   https://www.github.com/
[OCaml]:    https://www.ocaml.org/
[Cmdliner]: https://erratique.ch/software/cmdliner
