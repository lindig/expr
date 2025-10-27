{
  open Parser        (* The type token is defined in parser.mli *)
  exception Failure of string
}

rule token = parse
  [' ' '\t' '\r'] { token lexbuf } (* Skip whitespace *)
| '\n' { EOL } (* End of Line token to mark end of input *)

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
| ['0'-'9']+ ('.' ['0'-'9']*)? as f { FLOAT_LITERAL (float_of_string f) }
| eof { EOF }
| _ { raise (Failure ("Lexical error: unexpected character")) }

