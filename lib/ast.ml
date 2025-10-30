(* Type definition for the Abstract Syntax Tree (AST).
   This defines the structure of the recognized expressions.
   Expressions can evaluate to either a float (A) or a boolean (B).
*)

exception Failure of string

let fail fmt = Printf.ksprintf (fun msg -> raise (Failure msg)) fmt

type float_expr =
  | FloatLiteral of float
  | ID of string
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

type expression = Float of float_expr | Bool of bool_expr

let rec float_expr env = function
  | FloatLiteral f -> f
  | ID _ -> 0.0
  | Plus (e1, e2) -> float_expr env e1 +. float_expr env e2
  | Minus (e1, e2) -> float_expr env e1 -. float_expr env e2
  | Times (e1, e2) -> float_expr env e1 *. float_expr env e2
  | Divide (e1, e2) -> (
      match (float_expr env e1, float_expr env e2) with
      | _, 0.0 -> fail "division by zero"
      | x, y -> x /. y)

and bool_expr env = function
  | BoolLiteral b -> b
  | Not e -> not (bool_expr env e)
  | And (e1, e2) -> bool_expr env e1 && bool_expr env e2
  | Or (e1, e2) -> bool_expr env e1 || bool_expr env e2
  | Equal (e1, e2) -> float_expr env e1 = float_expr env e2
  | Less (e1, e2) -> float_expr env e1 < float_expr env e2
  | Greater (e1, e2) -> float_expr env e1 > float_expr env e2
  | LessEqual (e1, e2) -> float_expr env e1 <= float_expr env e2
  | GreaterEqual (e1, e2) -> float_expr env e1 >= float_expr env e2
  | NotEqual (e1, e2) -> float_expr env e1 <> float_expr env e2

(* Utility function to print the top-level AST *)
let eval env = function
  | Float expr -> float_expr env expr |> fun f -> Printf.sprintf "%f" f
  | Bool expr -> bool_expr env expr |> fun b -> Printf.sprintf "%b" b
