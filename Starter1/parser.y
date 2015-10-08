%{
/***********************************************************************
 * --YOUR GROUP INFO SHOULD GO HERE--
 *
 *   Interface to the parser module for CSC467 course project.
 *
 *   Phase 2: Implement context free grammar for source language, and
 *            parse tracing functionality.
 *   Phase 3: Construct the AST for the source language program.
 ***********************************************************************/

/***********************************************************************
 *  C Definitions and external declarations for this module.
 *
 *  Phase 3: Include ast.h if needed, and declarations for other global or
 *           external vars, functions etc. as needed.
 ***********************************************************************/

#include <string.h>
#include "common.h"
//#include "ast.h"
//#include "symbol.h"
//#include "semantic.h"
#define YYERROR_VERBOSE
#define yTRACE(x)    { if (traceParser) fprintf(traceFile, "%s\n", x); }

void yyerror(char* s);    /* what to do in case of error            */
int yylex();              /* procedure for calling lexical analyzer */
extern int yyline;        /* variable holding current line number   */

%}

/***********************************************************************
 *  Yacc/Bison declarations.
 *  Phase 2:
 *    1. Add precedence declarations for operators (after %start declaration)
 *    2. If necessary, add %type declarations for some nonterminals
 *  Phase 3:
 *    1. Add fields to the union below to facilitate the construction of the
 *       AST (the two existing fields allow the lexical analyzer to pass back
 *       semantic info, so they shouldn't be touched).
 *    2. Add <type> modifiers to appropriate %token declarations (using the
 *       fields of the union) so that semantic information can by passed back
 *       by the scanner.
 *    3. Make the %type declarations for the language non-terminals, utilizing
 *       the fields of the union as well.
 ***********************************************************************/

%{
#define YYDEBUG 1
%}


// TODO:Modify me to add more data types
// Can access me from flex useing yyval

%union {
  int num;
  char *text;
  char c;
  float fval;
}
// TODO:Replace myToken with your tokens, you can use these tokens in flex
%token           myToken1
%token           myToken2
%token           T_ASSIGN
%token           T_BOOL
%token           T_BVEC
%token           T_CMP
%token           T_COLON
%token           T_COMMA
%token           T_COND
%token           T_CONST
%token           T_FLOAT
%token           T_FUNC
%token           T_INT
%token           T_INTVAL
%token           T_FLOATVAL
%token           T_IVEC
%token           T_LBRACK
%token           T_LBRACK_CU
%token           T_LBRACK_SQ
%token           T_OP
%token           T_RBRACK
%token           T_RBRACK_CU
%token           T_RBRACK_SQ
%token           T_SEMICOL
%token           T_VEC
%token           T_WHILE
%token           T_ID


%start    program

%%

/***********************************************************************
 *  Yacc/Bison rules
 *  Phase 2:
 *    1. Replace grammar found here with something reflecting the source
 *       language grammar
 *    2. Implement the trace parser option of the compiler
 *  Phase 3:
 *    1. Add code to rules for construction of AST.
 ***********************************************************************/
program
  :   tokens
  ;
tokens
  :  tokens token
  |
  ;
// TODO: replace myToken with the token the you defined.
token
  :  myToken1
  |  myToken2
  |  T_ASSIGN
  |  T_BOOL
  |  T_BVEC
  |  T_CMP
  |  T_COLON
  |  T_COMMA
  |  T_COND
  |  T_CONST
  |  T_FLOAT
  |  T_FUNC
  |  T_INT
  |  T_INTVAL
  |  T_FLOATVAL
  |  T_IVEC
  |  T_LBRACK
  |  T_LBRACK_CU
  |  T_LBRACK_SQ
  |  T_OP
  |  T_RBRACK
  |  T_RBRACK_CU
  |  T_RBRACK_SQ
  |  T_SEMICOL
  |  T_VEC
  |  T_WHILE
  |  T_ID
  ;


%%

/***********************************************************************ol
 * Extra C code.
 *
 * The given yyerror function should not be touched. You may add helper
 * functions as necessary in subsequent phases.
 ***********************************************************************/
void yyerror(char* s) {
  if (errorOccurred)
    return;    /* Error has already been reported by scanner */
  else
    errorOccurred = 1;

  fprintf(errorFile, "\nPARSER ERROR, LINE %d",yyline);
  if (strcmp(s, "parse error")) {
    if (strncmp(s, "parse error, ", 13))
      fprintf(errorFile, ": %s\n", s);
    else
      fprintf(errorFile, ": %s\n", s+13);
  } else
    fprintf(errorFile, ": Reading token %s\n", yytname[YYTRANSLATE(yychar)]);
}

