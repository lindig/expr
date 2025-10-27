(* Type definition for the Abstract Syntax Tree (AST).
   This defines the structure of the recognized expressions.
   Expressions can evaluate to either a float (A) or a boolean (B).
*)

type float_expr =
  | FloatLiteral of float
  | Plus of float_expr * float_expr
  | Minus of float_expr * float_expr
  | Times of float_expr * float_expr
  | Divide of float_expr * float_expr

type bool_expr =
  | BoolLiteral of bool
  | Not of bool_expr
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr
  | Equal of float_expr * float_expr (* a == b *)
  | Less of float_expr * float_expr (* a < b *)
  | Greater of float_expr * float_expr (* a > b *)
  | LessEqual of float_expr * float_expr
  | GreaterEqual of float_expr * float_expr
  | NotEqual of float_expr * float_expr

type expression = A_Expr of float_expr | B_Expr of bool_expr

(* Utility function to print a float AST (for demonstration) *)
let rec string_of_float_expr = function
  | FloatLiteral f -> Printf.sprintf "%.2f" f
  | Plus (e1, e2) ->
      Printf.sprintf "(%s + %s)" (string_of_float_expr e1)
        (string_of_float_expr e2)
  | Minus (e1, e2) ->
      Printf.sprintf "(%s - %s)" (string_of_float_expr e1)
        (string_of_float_expr e2)
  | Times (e1, e2) ->
      Printf.sprintf "(%s * %s)" (string_of_float_expr e1)
        (string_of_float_expr e2)
  | Divide (e1, e2) ->
      Printf.sprintf "(%s / %s)" (string_of_float_expr e1)
        (string_of_float_expr e2)

(* Utility function to print a boolean AST (for demonstration) *)
let rec string_of_bool_expr = function
  | BoolLiteral b -> string_of_bool b
  | Not e -> Printf.sprintf "(~ %s)" (string_of_bool_expr e)
  | And (e1, e2) ->
      Printf.sprintf "(%s && %s)" (string_of_bool_expr e1)
        (string_of_bool_expr e2)
  | Or (e1, e2) ->
      Printf.sprintf "(%s || %s)" (string_of_bool_expr e1)
        (string_of_bool_expr e2)
  | Equal (e1, e2) ->
      Printf.sprintf "(%s == %s)" (string_of_float_expr e1)
        (string_of_float_expr e2)
  | Less (e1, e2) ->
      Printf.sprintf "(%s < %s)" (string_of_float_expr e1)
        (string_of_float_expr e2)
  | Greater (e1, e2) ->
      Printf.sprintf "(%s > %s)" (string_of_float_expr e1)
        (string_of_float_expr e2)
  | LessEqual (e1, e2) ->
      Printf.sprintf "(%s <= %s)" (string_of_float_expr e1)
        (string_of_float_expr e2)
  | GreaterEqual (e1, e2) ->
      Printf.sprintf "(%s >= %s)" (string_of_float_expr e1)
        (string_of_float_expr e2)
  | NotEqual (e1, e2) ->
      Printf.sprintf "(%s != %s)" (string_of_float_expr e1)
        (string_of_float_expr e2)

(* Utility function to print the top-level AST *)
let string_of_expression = function
  | A_Expr fe -> Printf.sprintf "Float Expression: %s" (string_of_float_expr fe)
  | B_Expr be ->
      Printf.sprintf "Boolean Expression: %s" (string_of_bool_expr be)
