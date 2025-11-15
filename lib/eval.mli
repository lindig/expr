exception Failure of string

type expression
type value = Bool of bool | Float of float
type env

val empty : unit -> env
val add : env -> string -> float -> unit
val add' : env -> string list -> float -> unit
val env : (string * float) list -> env
val compile : string -> expression
val string : env -> string -> value
val expr : env -> expression -> value
