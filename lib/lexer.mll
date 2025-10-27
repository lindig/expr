{
  open Parser        (* The type token is defined in parser.mli *)
  exception Failure of string

  let fail fmt = Printf.ksprintf (fun msg -> raise (Failure msg)) fmt
}

let digit  = ['0'-'9']
let digits = digit digit*
let alpha  = ['a'-'z' '_']
let id     = alpha (digit|alpha)*
let number = digit+ ('.' digit*)?

rule token = parse
  [' ' '\t' '\r'] { token lexbuf } (* Skip whitespace *)

(* Arithmetic Operators *)
| '+' { PLUS }
| '-' { MINUS }
| '*' { TIMES }
| '/' { DIVIDE }

(* Relational Operators (Floats to Bool) *)
| "<=" { LESSEQUAL }
| "<" { LESS }
| ">=" { GREATEREQUAL }
| ">" { GREATER }
| "==" { EQUAL }
| "=" { EQUAL }
| "!=" { NOTEQUAL }

(* Logical Operators (Booleans) *)
| "||" { OR }
| "&&" { AND }
| "~" { NOT } (* Unary NOT *)

(* Parentheses *)
| '(' { LPAREN }
| ')' { RPAREN }

(* Keywords and Literals *)
| "true" { BOOL_LITERAL true }
| "false" { BOOL_LITERAL false }
| id as id { ID(id) } 
| number as f { FLOAT_LITERAL (float_of_string f) }
| eof { EOF }
| _ as c { fail "unexpected character '%c'" c } 

