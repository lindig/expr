

%token <float> FLOAT_LITERAL
%token <bool> BOOL_LITERAL
%token <string> ID
%token LPAREN RPAREN
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

expression:
  | float_expr EOF   { Float $1 }
  | bool_expr EOF    { Bool $1 }

float_expr:
  | FLOAT_LITERAL    { FloatLiteral $1 }
  | ID               { ID $1 }
  | LPAREN float_expr RPAREN { $2 }
  | float_expr PLUS float_expr { Plus ($1, $3) }
  | float_expr MINUS float_expr { Minus ($1, $3) }
  | float_expr TIMES float_expr { Times ($1, $3) }
  | float_expr DIVIDE float_expr { Divide ($1, $3) }
  | MINUS float_expr %prec UMINUS { Minus (FloatLiteral 0.0, $2) }

bool_expr:
  | BOOL_LITERAL     { BoolLiteral $1 }
  | LPAREN bool_expr RPAREN { $2 }
  | NOT bool_expr    { Not $2 }
  | bool_expr AND bool_expr { And ($1, $3) }
  | bool_expr OR bool_expr { Or ($1, $3) }
  | float_expr EQUAL float_expr      { Equal ($1, $3) }
  | float_expr NOTEQUAL float_expr   { NotEqual ($1, $3) }
  | float_expr LESS float_expr       { Less ($1, $3) }
  | float_expr GREATER float_expr    { Greater ($1, $3) }
  | float_expr LESSEQUAL float_expr  { LessEqual ($1, $3) }
  | float_expr GREATEREQUAL float_expr { GreaterEqual ($1, $3) }
