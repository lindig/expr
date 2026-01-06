(* SPDX-FileCopyrightText: 2025 Christian Lindig <lindig@gmail.com>
 * SPDX-License-Identifier: Unlicense
 *)
exception Failure of string
(** Any problem is reported: syntax of an expression or unknown bindings *)

type value = Bool of bool | Float of float | String of string
type expression
(* See the README and parser.mly for the supported expression syntax *)

type env
(** An [env] binds a names to [value]s. *)

val empty : unit -> env
(** [env] with no names *)

val add : env -> string -> value -> unit
(** Add a new binding to [env] *)

val add' : env -> string list -> value -> unit
(** Add multiple bindings, all referring to the same [value]. Hence this creates
    aliases *)

val env : (string * value) list -> env
(** Create an [env] from an association list *)

val compile : string -> expression
(** Compile a string to an expression for later evaluation *)

val string : env -> string -> value
(** Evaluate a string given an expression and evaluate it. This uses [compile]
    internally and is most useful if the expression is only evaluated once *)

val expr : env -> expression -> value
(** Evaluate a (compiled) expression. This can be used to evaluate a single
    expression multiple times with different [env] environments *)

val simple : string -> value
(** This simplest case: evaluate a string expression with an empty environment
    to a value *)
