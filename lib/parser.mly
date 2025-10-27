

%token <float> FLOAT_LITERAL
%token <bool> BOOL_LITERAL
%token LPAREN RPAREN
%token EOL 
%token EOF

%token OR AND NOT  EQUAL NOTEQUAL 
%token LESS GREATEREQUAL LESSEQUAL GREATER  PLUS MINUS TIMES DIVIDE UMINUS 

%left OR
%left AND
%right NOT /* Unary operator */
%nonassoc EQUAL NOTEQUAL LESS GREATEREQUAL LESSEQUAL GREATER /* Relational operators */
%left PLUS MINUS
%left TIMES DIVIDE
%nonassoc UMINUS /* Unary minus (implicit) */

/* The final type of the entry point */
%start expression
%type <Ast.expression> expression

%%

/* Main entry point: an expression can be either a float result (A) or a boolean result (B) */
expression:
  | float_expr EOF   { A_Expr $1 }
  | bool_expr EOF    { B_Expr $1 }
  | float_expr EOL   { A_Expr $1 }
  | bool_expr EOL    { B_Expr $1 }

/* Float arithmetic expressions */
float_expr:
  | FLOAT_LITERAL    { FloatLiteral $1 }
  | LPAREN float_expr RPAREN { $2 }
  | float_expr PLUS float_expr { Plus ($1, $3) }
  | float_expr MINUS float_expr { Minus ($1, $3) }
  | float_expr TIMES float_expr { Times ($1, $3) }
  | float_expr DIVIDE float_expr { Divide ($1, $3) }
  | MINUS float_expr %prec UMINUS { Minus (FloatLiteral 0.0, $2) }

/* Boolean logical expressions */
bool_expr:
  | BOOL_LITERAL     { BoolLiteral $1 }
  | LPAREN bool_expr RPAREN { $2 }
  | NOT bool_expr    { Not $2 }
  | bool_expr AND bool_expr { And ($1, $3) }
  | bool_expr OR bool_expr { Or ($1, $3) }

/* Boolean relational expressions (Float arithmetic required on both sides) */
  | float_expr EQUAL float_expr      { Equal ($1, $3) }
  | float_expr NOTEQUAL float_expr   { NotEqual ($1, $3) }
  | float_expr LESS float_expr       { Less ($1, $3) }
  | float_expr GREATER float_expr    { Greater ($1, $3) }
  | float_expr LESSEQUAL float_expr  { LessEqual ($1, $3) }
  | float_expr GREATEREQUAL float_expr { GreaterEqual ($1, $3) }
