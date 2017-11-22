%{

/*
 * Lex file for the jibuc language. 
 * This section contains imports and variable declarations.
 */

#include "y.tab.h"
#include <string.h>

char* temp;
%}

%option yylineno


%%
[\t ]+              /* ignore whitespace */;
(?i:BEGINING)       {return begining;}
(?i:BODY)           {return body;}
(?i:END)            {return end;}
(?i:PRINT)          {return print;}
(?i:INPUT)          {return input_keyword;}
(?i:MOVE)           {return move;}
(?i:ADD)            {return add;}
(?i:TO)             {return to;}
\n                  {}
^X+            {yylval.size = strlen(yytext); return variable_size;}
[0-9]+         {yylval.num = atoi(yytext); return integer;}
[A-Za-z][A-Za-z0-9\-]* { temp = (char*) calloc(strlen(yytext)+1, sizeof(char)); strcpy(temp, yytext); yylval.name = temp; return identifier;}
[0-9]+[A-Za-z0-9\-]* {printf("INVALID_IDENTIFIER (%s) at line %d ", yytext, yylineno); return(0);} /* Catches invalid identifiers beginning with a number */
;              {return semi_colon;}
\"(\\.|[^"\\])*\"        {return string_literal;}
\.             {return statement_terminator;}
.              {printf("Encountered invalid syntax"); return(0);}
%%

int yywrap(void) {return 1;}
