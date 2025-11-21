(* SPDX-FileCopyrightText: 2025 Christian Lindig <lindig@gmail.com>
 * SPDX-License-Identifier: Unlicense
 *)
exception Failure of string

type expression = Ast.expression
type value = Bool of bool | Float of float

let fail fmt = Printf.ksprintf (fun msg -> raise (Failure msg)) fmt
let lookup env key = Hashtbl.find_opt env key

type env = (string, float) Hashtbl.t

let empty () = Hashtbl.create 5
let add env key value = Hashtbl.add env key value
let add' env keys value = List.iter (fun k -> Hashtbl.add env k value) keys

let env kvs =
  let env = empty () in
  List.iter (fun (key, value) -> add env key value) kvs;
  env

let rec float_expr env ast =
  let open Ast in
  match ast with
  | FloatLiteral f -> f
  | ID id -> (
      match lookup env id with None -> fail "%s is undefined" id | Some v -> v)
  | Plus (e1, e2) -> float_expr env e1 +. float_expr env e2
  | Minus (e1, e2) -> float_expr env e1 -. float_expr env e2
  | Times (e1, e2) -> float_expr env e1 *. float_expr env e2
  | Divide (e1, e2) -> (
      match (float_expr env e1, float_expr env e2) with
      | _, 0.0 -> fail "division by zero"
      | x, y -> x /. y)

and bool_expr env ast =
  let open Ast in
  match ast with
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
  | Inside (e1, e2, e3) ->
      let v1 = float_expr env e1 in
      let v2 = float_expr env e2 in
      let v3 = float_expr env e3 in
      min v2 v3 <= v1 && v1 <= max v2 v3
  | Outside (e1, e2, e3) ->
      let v1 = float_expr env e1 in
      let v2 = float_expr env e2 in
      let v3 = float_expr env e3 in
      v1 < min v2 v3 || v1 > max v2 v3

let eval env ast =
  let open Ast in
  match ast with
  | FloatExpr e -> Float (float_expr env e)
  | BoolExpr e -> Bool (bool_expr env e)

let parse lexbuf =
  try Parser.expression Lexer.token lexbuf with
  | Lexer.Failure msg ->
      let pos = lexbuf.Lexing.lex_curr_p in
      fail "Lexing Error at line %d, char %d: %s\n" pos.Lexing.pos_lnum
        (pos.Lexing.pos_cnum - pos.Lexing.pos_bol)
        msg
  | _ ->
      let pos = lexbuf.Lexing.lex_curr_p in
      fail "Syntax error at line %d, char %d\n" pos.Lexing.pos_lnum
        (pos.Lexing.pos_cnum - pos.Lexing.pos_bol)

let compile str =
  try
    let lexbuf = Lexing.from_string str in
    parse lexbuf
  with _ -> fail "Error in %S" str

let string env str = eval env (compile str)
let expr env ast = eval env ast
let simple str = eval (empty ()) (compile str)
