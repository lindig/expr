(* SPDX-FileCopyrightText: 2025 Christian Lindig <lindig@gmail.com>
 * SPDX-License-Identifier: Unlicense
 *)
exception Failure of string

type expression = Ast.expression
type value = Bool of bool | Float of float | String of string
type rel = EQ | NE | LT | GT | LE | GE

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

let float_eval op x y =
  match (x, y) with
  | Float x, Float y -> Float (op x y)
  | _ -> fail "incompatble types"

let rel_eval rel x y =
  match (rel, x, y) with
  | EQ, Float x, Float y -> Bool (x = y)
  | NE, Float x, Float y -> Bool (x <> y)
  | GT, Float x, Float y -> Bool (x > y)
  | LT, Float x, Float y -> Bool (x < y)
  | GE, Float x, Float y -> Bool (x >= y)
  | LE, Float x, Float y -> Bool (x <= y)
  | EQ, String x, String y -> Bool (x = y)
  | NE, String x, String y -> Bool (x <> y)
  | GT, String x, String y -> Bool (x > y)
  | LT, String x, String y -> Bool (x < y)
  | GE, String x, String y -> Bool (x >= y)
  | LE, String x, String y -> Bool (x <= y)
  | EQ, Bool x, Bool y -> Bool (x = y)
  | NE, Bool x, Bool y -> Bool (x <> y)
  | _ -> fail "incompatble types"

let bool_eval op x y =
  match (x, y) with
  | Bool x, Bool y -> Bool (op x y)
  | _ -> fail "incompatble types"

let rec eval env ast =
  let open Ast in
  match ast with
  | FloatLiteral f -> Float f
  | BoolLiteral b -> Bool b
  | StringLiteral s -> String s
  | ID id -> (
      match lookup env id with
      | None -> fail "%s is undefined" id
      | Some v -> Float v)
  | Plus (e1, e2) -> float_eval ( +. ) (eval env e1) (eval env e2)
  | Minus (e1, e2) -> float_eval ( -. ) (eval env e1) (eval env e2)
  | Times (e1, e2) -> float_eval ( *. ) (eval env e1) (eval env e2)
  | Divide (e1, e2) -> (
      match (eval env e1, eval env e2) with
      | _, Float 0.0 -> fail "division by zero"
      | Float x, Float y -> Float (x /. y)
      | _ -> fail "incompatible types")
  | Not e -> (
      match eval env e with
      | Bool x -> Bool (not x)
      | _ -> fail "incompatible types")
  | And (e1, e2) -> bool_eval ( && ) (eval env e1) (eval env e2)
  | Or (e1, e2) -> bool_eval ( || ) (eval env e1) (eval env e2)
  | Equal (e1, e2) -> rel_eval EQ (eval env e1) (eval env e2)
  | Less (e1, e2) -> rel_eval LT (eval env e1) (eval env e2)
  | Greater (e1, e2) -> rel_eval GT (eval env e1) (eval env e2)
  | LessEqual (e1, e2) -> rel_eval LE (eval env e1) (eval env e2)
  | GreaterEqual (e1, e2) -> rel_eval GE (eval env e1) (eval env e2)
  | NotEqual (e1, e2) -> rel_eval NE (eval env e1) (eval env e2)
  | Inside (e1, e2, e3) -> (
      let v1 = eval env e1 in
      let v2 = eval env e2 in
      let v3 = eval env e3 in
      match (v1, v2, v3) with
      | Float v1, Float v2, Float v3 -> Bool (min v2 v3 <= v1 && v1 <= max v2 v3)
      | _ -> fail "incompatible types")
  | Outside (e1, e2, e3) -> (
      let v1 = eval env e1 in
      let v2 = eval env e2 in
      let v3 = eval env e3 in
      match (v1, v2, v3) with
      | Float v1, Float v2, Float v3 -> Bool (v1 < min v2 v3 || v1 > max v2 v3)
      | _ -> fail "incompatible types")

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
  with Failure msg -> fail "Error in %S: %s" str msg

let string env str = eval env (compile str)
let expr env ast = eval env ast
let simple str = eval (empty ()) (compile str)
