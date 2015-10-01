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
INTVAL      [+-]?([1-9][0-9]*|0)
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
DIGITS      [0-9]
LOWER       [a-z]
UPPER       [A-Z]
LETTERS     [a-zA-Z]
VALID_CHAR  [0-9a-zA-Z_]


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
                if (c1 == '*' && c2 == '/') {
                    break;
                }
                c1 = c2;
                c2 = yyinput();
                if (c1 == '\n' && c2 != EOF)
                  yyline++;
              }
            }

{WS} {
    yTRACE(WS);
     }

{INTVAL} {
    yTRACE(INTVAL);
    return INTVAL;
         }

{COMMA} {
    yTRACE(COMMA);
    return myToken1;
        }

{SEMICOL} {
    yTRACE(SEMICOL);
    return myToken1;
          }

{COLON} {
    yTRACE(COLON);
    return myToken1;
      }

{DATA_TYPE}{
        switch(yytext){
            case "bool":
                yTRACE(T_BOOL);
                return T_BOOL;
            case "int":
                yTRACE(T_INT);
                return T_INT;
            case "float":
                yTRACE(T_FLOAT);
                return T_FLOAT;       
        }
    }

{VEC_TYPE}{
    switch((char) *yytext){
        case 'b':
            yylval.num = (int) *(yytext + 4) - (int) '0'; 
            yTRACE(T_BVEC);
            return T_BVEC;
        case 'i':
            yylval.num = (int) *(yytext + 4) - (int) '0';
            yTRACE(T_IVEC);
            return T_IVEC;
        default:
            yylval.num = (int) *(yytext + 3) - (int) '0'; 
            yTRACE(T_VEC);
            return T_VEC;
    }
}
DATA_TYPE   bool|int|float
VEC_TYPE    [bi]?vec[234]
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
DIGITS      [0-9]
LOWER       [a-z]
UPPER       [A-Z]
LETTERS     [a-zA-Z]
VALID_CHAR  [0-9a-zA-Z_]

.           { yERROR("Unknown token"); }

%%
