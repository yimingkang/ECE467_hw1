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
#define yRETURN(x)   {yTRACE(x); return x;}
#define yERROR(x)    { fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: %s\n", yyline, x); errorOccurred = TRUE; yyterminate(); }

int CheckInt(void);
int yyline = 1;
int tokenID = 0;

%}
%option noyywrap

WS          [ \t\n]
INTVAL      [+-]?([1-9][0-9]*|0)
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
BRACK_CU    \{|\}
COMMA       ,
SEMICOL     ;
COLON       :
DQUOTE      "
QUOTE       '
OP_ASSIGN   =
OP_CMP      !|>|<|>=|<=|!=|==|&&|\|\|
OP_OP       +|-|*|/|^
IDENTIFIER  [a-Z_]+[0-9a-Z_]*



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
    yTRACE(T_COMMA);
    return T_COMMA;
        }

{SEMICOL} {
    yTRACE(T_SEMICOL);
    return T_SEMICOL;
          }

{COLON} {
    yTRACE(T_COLON);
    return T_COLON;
      }

{DATA_TYPE} {
        switch(yytext[0]){
            case 'b' :
                yTRACE(T_BOOL);
                return T_BOOL;
            case 'i':
                yTRACE(T_INT);
                return T_INT;
            case 'f':
                yTRACE(T_FLOAT);
                return T_FLOAT;       
        }
    }

{VEC_TYPE} {
    switch(yytext[0]){
        case 'b':
            yylval.num = (int) *(yytext + 4) - (int) '0'; 
            yTRACE(T_BVEC);
            return T_BVEC;
        case 'i':
            yylval.num = (int) *(yytext + 4) - (int) '0';
            yTRACE(T_IVEC);
            return T_IVEC;
        case 'v':
            yylval.num = (int) *(yytext + 3) - (int) '0'; 
            yTRACE(T_VEC);
            return T_VEC;
        default:
            yERROR("Parser error! Should not have gone here: %s\n", yytext);
    }
}

{QUALIFIER} {
        yTRACE(T_CONST);
        return T_CONST;
}

{BOOLVAL} {
    switch(yytext[0]){
        case 't':
            yylval.num = 1;
            break;
        case 'f':
            yylval.num = 0;
            break;
        default:
            yERROR("Parser error! Should not have gone here: %s\n", yytext);
    }
    yTRACE(T_BOOL);
    return T_BOOL;
}

{KW_COND} {
    yylval.text = (char *) malloc((strlen(yytext) + 1) * sizeof(char));
    
    // possible buffer overflow if there's a bug in parser 
    // b/c we're not checking the size of yytext in strcpy
    strcpy(yylval.text, yytext);
    yTRACE(T_BOOL);
    return T_BOOL;
}

{KW_VOID} {
    yTRACE(T_VOID);
    return (T_VOID);
}

{KW_WHILE} {
    yTRACE(T_WHILE);
    return (T_WHILE);
}

{KW_FUNC} {
    yylval.text = (char *) malloc((strlen(yytext) + 1) * sizeof(char));
    
    // possible buffer overflow if there's a bug in parser 
    // b/c we're not checking the size of yytext in strcpy
    strcpy(yylval.text, yytext);
    yTRACE(T_FUNC);
    return (T_FUNC);
}
{BRACK} {
    switch(yytext[0]){
        case '(':
            yTRACE(T_LBRACK);
            return T_LBRACK;
        case ')':
            yTRACE(T_RBRACK);
            return T_RBRACK;
        default:
            yERROR("Parser error! Should not have gone here: %s\n", yytext);
    }
}

{BRACK_SQ} {
    switch(yytext[0]){
        case '[':
            yTRACE(T_LBRACK_SQ);
            return T_LBRACK_SQ;
        case ']':
            yTRACE(T_RBRACK_SQ);
            return T_RBRACK_SQ;
        default:
            yERROR("Parser error! Should not have gone here: %s\n", yytext);
    }
}

{BRACK_CU} {
    switch(yytext[0]){
        case '{':
            yTRACE(T_LBRACK_CU);
            return T_LBRACK_CU;
        case '}':
            yTRACE(T_RBRACK_CU);
            return T_RBRACK_CU;
        default:
            yERROR("Parser error! Should not have gone here: %s\n", yytext);
    }
}

{OP_ASSIGN} {
    yTRACE(T_ASSIGN);
    return (T_ASSIGN);
}

{OP_CMP} {
    yylval.text = (char *) malloc(strlen((yytext) + 1) * sizeof(char)); 

    // possible buffer overflow if there's a bug in parser 
    // b/c we're not checking the size of yytext in strcpy
    strcpy(yylval.text, yytext);
    yTRACE(T_CMP);
    return (T_CMP);
}

{OP_CMP} {
    yylval.c = yytext[0];
    yTRACE(T_OP);
    return (T_OP);
}

.           { yERROR("Unknown token"); }

%%
