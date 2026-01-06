(* SPDX-FileCopyrightText: 2025 Christian Lindig <lindig@gmail.com>
 * SPDX-License-Identifier: Unlicense
 *)
exception Failure of string

type expression
type value = Bool of bool | Float of float | String of string
type env

val empty : unit -> env
val add : env -> string -> value -> unit
val add' : env -> string list -> value -> unit
val env : (string * value) list -> env
val compile : string -> expression
val string : env -> string -> value
val expr : env -> expression -> value
val simple : string -> value
