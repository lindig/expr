

%token <float> FLOAT_LITERAL
%token <bool> BOOL_LITERAL
%token <string> ID
%token <string> STRING
%token LPAREN RPAREN
%token LBRACK RBRACK
%token KOMMA
%token EOF

%token OR AND NOT  EQUAL NOTEQUAL 
%token LESS GREATEREQUAL LESSEQUAL GREATER  PLUS MINUS TIMES DIVIDE UMINUS 

%left OR
%left AND
%right NOT
%nonassoc EQUAL NOTEQUAL LESS GREATEREQUAL LESSEQUAL GREATER
%left PLUS MINUS
%left TIMES DIVIDE
%nonassoc UMINUS /* Unary minus (implicit) */

/* The final type of the entry point */
%start expression
%type <Ast.expression> expression

%%

expression: expr { $1 }

expr:
  | FLOAT_LITERAL         { FloatLiteral $1 }
  | BOOL_LITERAL          { BoolLiteral $1 }
  | STRING                { StringLiteral $1 }
  | ID                    { ID $1 }
  | expr PLUS expr        { Plus ($1, $3) }
  | expr MINUS expr       { Minus ($1, $3) }
  | expr TIMES expr       { Times ($1, $3) }
  | expr DIVIDE expr      { Divide ($1, $3) }
  | MINUS expr %prec UMINUS { Minus (FloatLiteral 0.0, $2) }
  
  | NOT expr              { Not $2 }
  | expr AND expr         { And ($1, $3) }
  | expr OR expr          { Or ($1, $3) }
  | expr EQUAL expr       { Equal ($1, $3) }
  | expr NOTEQUAL expr    { NotEqual ($1, $3) }
  | expr LESS expr        { Less ($1, $3) }
  | expr GREATER expr     { Greater ($1, $3) }
  | expr LESSEQUAL expr   { LessEqual ($1, $3) }
  | expr GREATEREQUAL expr { GreaterEqual ($1, $3) }
  | expr EQUAL LBRACK expr 
               KOMMA  expr RBRACK { Inside ($1, $4, $6) }
  | expr NOTEQUAL LBRACK expr 
               KOMMA  expr RBRACK { Outside ($1, $4, $6) }
