(* SPDX-FileCopyrightText: 2025 Christian Lindig <lindig@gmail.com>
 * SPDX-License-Identifier: Unlicense
 *)
(* Type definition for the Abstract Syntax Tree (AST).
   This defines the structure of the recognized expressions.
   Expressions can evaluate to either a float (A) or a boolean (B).
*)

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
  | Inside of float_expr * float_expr * float_expr (* v in [x, y] *)
  | Outside of float_expr * float_expr * float_expr (* v in [x, y] *)

type expression = FloatExpr of float_expr | BoolExpr of bool_expr
