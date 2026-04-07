(* SPDX-FileCopyrightText: 2025 Christian Lindig <lindig@gmail.com>
 * SPDX-License-Identifier: Unlicense
 *)
(* Type definition for the Abstract Syntax Tree (AST).
   This defines the structure of the recognized expressions.
   Expressions can evaluate to either a float (A) or a boolean (B).
*)

type expr =
  | FloatLiteral of float
  | BoolLiteral of bool
  | StringLiteral of string
  | ID of string
  | Plus of expr * expr
  | Minus of expr * expr
  | Times of expr * expr
  | Divide of expr * expr
  | Not of expr
  | And of expr * expr
  | Or of expr * expr
  | Equal of expr * expr (* a == b *)
  | Less of expr * expr (* a < b *)
  | Greater of expr * expr (* a > b *)
  | LessEqual of expr * expr
  | GreaterEqual of expr * expr
  | NotEqual of expr * expr
  | Inside of expr * expr * expr (* v in [x, y] *)
  | Outside of expr * expr * expr (* v not in [x, y] *)

type expression = expr
