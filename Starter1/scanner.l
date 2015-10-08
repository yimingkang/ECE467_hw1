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

BOOLVAL     true|false
BRACK       \(|\)
BRACK_CU    \{|\}
BRACK_SQ    \[|\]
COLON       :
COMMA       ,
DATA_TYPE   bool|int|float
DQUOTE      "
FLOATVAL    [+-]?([1-9][0-9]*|0?)\.[0-9]+
IDENTIFIER  [a-zA-Z_]+[0-9a-zA-Z_]*
INTVAL      [+-]?([1-9][0-9]*|0)
KW_COND     else|if
KW_FUNC     dp3|lit|rsq
KW_VOID     void
KW_WHILE    while
OP_ASSIGN   =
OP_CMP      !|>|<|>=|<=|!=|==|&&|\|\|
OP_OP       \+|-|\*|\/|^
QUALIFIER   const
QUOTE       '
SEMICOL     ;
VEC_TYPE    [bi]?vec[234]
WS          [ \t\n]

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

{COMMA} {
    yTRACE(T_COMMA);
    return T_COMMA;
        }

{WS} {
     }

{INTVAL} {
    if (strlen(yytext) > 7){
        // Might overflow int dont store
        yERROR("Integer out of range [-2097152, 2097151]");
    }else{
        // Will not overflow int 
        int val = atoi(yytext);

        // max is +/- 2^21-1
        if(val < -2097152 || val > 2097151){
            yERROR("Integer out of range [-2097151, 2097152]");
        }
        yylval.num = val;
    }
    yTRACE(T_INTVAL);
    return T_INTVAL;
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
            yERROR(yytext);
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
            yERROR(yytext);
    }
    yTRACE(T_BOOL);
    return T_BOOL;
}

{KW_COND} {
    yylval.text = (char *) malloc((strlen(yytext) + 1) * sizeof(char));

    // possible buffer overflow if there's a bug in parser
    // b/c we're not checking the size of yytext in strcpy
    strcpy(yylval.text, yytext);
    yTRACE(T_COND);
    return T_COND;
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
            yERROR(yytext);
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
            yERROR(yytext);
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
            yERROR(yytext);
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

{OP_OP} {
    yylval.c = yytext[0];
    yTRACE(T_OP);
    return (T_OP);
}

{IDENTIFIER} {
    yylval.text = (char *) malloc(strlen((yytext) + 1) * sizeof(char));

    // possible buffer overflow if there's a bug in parser
    // b/c we're not checking the size of yytext in strcpy
    strcpy(yylval.text, yytext);
    yTRACE(T_ID);
    return (T_ID);
}

{FLOATVAL} {
    // check for out of range??
    float fval = atof(yytext);
    yylval.fval = fval;
    yTRACE(T_FLOATVAL);
    return T_FLOATVAL;
}


.           { yERROR("Unknown token"); }

%%

