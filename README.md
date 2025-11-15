

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

# Contribute

If you find this useful, please contribute back by raising pull
requests for improvements you made.

[GitHub]:   https://www.github.com/
[OCaml]:    https://www.ocaml.org/
