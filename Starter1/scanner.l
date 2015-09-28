%{
/**********************************************************************
 *
 * **YOUR GROUP INFO SHOULD GO HERE**
 *
 *  Interface to the scanner module for CSC467 course project
 **********************************************************************/


#include "common.h"
#include "parser.tab.h"
#include "string.h"


#define YY_USER_INIT { yyin = inputFile; }
#define	yyinput      input
#define yTRACE(x)    { if (traceScanner) fprintf(traceFile, "TOKEN %3d : %s\n", x, yytext); }
#define yERROR(x)    { fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: %s\n", yyline, x); errorOccurred = TRUE; yyterminate(); }

int CheckInt(void);
int yyline = 1;
int tokenID = 0;

%}
%option noyywrap

WS          [ \t\n]
INTVAL      [+-]?([1-9][0-9]+|0)
DATA_TYPE   bool|int|float|[bi]?vec[234]
QUALIFIER   const
FLOATVAL    [+-]?([0-9][1-9]*|).[0-9]+
BOOLVAL     true|false
KW_COND     else|if
KW_VOID     void
KW_WHILE    while
KW_FUNC     dp3|lit|rsq
BRACK       \(|\)
BRACK_SQ    \[|\]
SCOPE       \{|\}
COMMA       ,
SEMICOL     ;
COLON       :
OP_ASSIGN   =
OP_CMP      >|<|>=|<=|!=?|==|&&|\|\|
OP_OP       +|-|*|/|^


%%
"/*"        {
              int c1      = 0;
              int c2      = yyinput();
              int curline = yyline;
              for(;;) {
                if (c2 == EOF) {
                  fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: Unmatched /*\n", curline);
                  errorOccurred = TRUE;
                  yyterminate();
                }
                if (c1 == '*' && c2 == '/')
                  break;
                c1 = c2;
                c2 = yyinput();
                if (c1 == '\n' && c2 != EOF)
                  yyline++;
              }
            }

{WS} {
        printf("HI space\n");
}

{INTVAL} {
        printf("HI int\n");
        return T_INT;
}

{COMMA} {
        printf("HI comma\n");
        return T_INT;
}

{SEMICOL} {
        printf("HI Semi\n");
        return T_INT;
}

{COL} {
        printf("HI col\n");
        return T_INT;
}

.           { yERROR("Unknown token"); }

%%
