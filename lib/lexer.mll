(* SPDX-FileCopyrightText: 2025 Christian Lindig <lindig@gmail.com>
 * SPDX-License-Identifier: Unlicense
 *)
{
  open Parser        (* The type token is defined in parser.mli *)
  exception Failure of string

  let fail fmt = Printf.ksprintf (fun msg -> raise (Failure msg)) fmt
  let atof = float_of_string
  let hms h m s = h *. 3600.0 +. m *. 60.0 +. s

  let get         = Lexing.lexeme
  let getchar     = Lexing.lexeme_char
}

let digit  = ['0'-'9']
let digits = digit digit*
let alpha  = ['a'-'z' 'A'-'Z' '_']
let id     = alpha (digit|alpha)*
let seconds = digits  ('.' digits)?

rule token = parse
  [' ' '\t' '\r'] { token lexbuf } (* Skip whitespace *)

| '"'         { string lexbuf (Buffer.create 80) }

(* Arithmetic Operators *)
| '+' { PLUS }
| '-' { MINUS }
| '*' { TIMES }
| '/' { DIVIDE }

(* Relational Operators (Floats to Bool) *)
| "<="  { LESSEQUAL }
| "<"   { LESS }
| ">="  { GREATEREQUAL }
| ">"   { GREATER }
| "=="  { EQUAL }
| "="   { EQUAL }
| "!="  { NOTEQUAL }

(* Logical Operators (Booleans) *)
| "||"  { OR }
| "&&"  { AND }
| "~"   { NOT } (* Unary NOT *)

(* Parentheses *)
| '(' { LPAREN }
| ')' { RPAREN }
| '[' { LBRACK }
| ']' { RBRACK }
| ',' { KOMMA }

(* Keywords and Literals *)
| "true"  { BOOL_LITERAL true }
| "false" { BOOL_LITERAL false }
| id as id { ID(id) }

| seconds  as s   { FLOAT_LITERAL(hms 0.0 0.0 (atof s)) }

| (digits  as m) ':'
  (seconds as s)  { FLOAT_LITERAL(hms 0.0 (atof m) (atof s)) }

| (digits  as h) ':'
  (digits  as m) ':'
  (seconds as s)  { FLOAT_LITERAL(hms (atof h) (atof m) (atof s)) }

| eof { EOF }
| _ as c { fail "unexpected character '%c'" c }

and string =  parse
  eof       { fun _buf -> fail "unexpected end of input inside a string" }
  | '\n'    { fun _buf -> fail "unexpected newline inside a string" }
  | '\\' _  { fun buf ->
              let c = getchar lexbuf 1 in
                  let k = match c with
                      | 'n'  -> '\n'
                      | 't'  -> '\t'
                      | 'r'  -> '\r'
                      | '\n' -> '\n'
                      | '0'  -> '\000'
                      | _    -> c
                  in
                     ( Buffer.add_char buf k
                     ; string lexbuf buf
                     )
            }
   | [^'"' '\n' '\\']+
           { fun buf ->
             let s = get lexbuf  in
               ( Buffer.add_string buf s
               ; string lexbuf buf
               )
           }
   | '"'   { fun buf -> ID (Buffer.contents buf) }
   | _     { fun _buf -> fail "unexpected character inside a string " }
