%{

/*
 * Lex file for the jibuc language. 
 * This section contains imports and variable declarations.
 */

%}

%%
[\t ]+          /* ignore whitespace */;
^BEGINING      {printf("BEGINING (%s) ", yytext);}
^BODY          {printf("BODY (%s) ", yytext);}
^END           {printf("END (%s) ", yytext);}
^PRINT         {printf("PRINT (%s) ", yytext);}
^INPUT         {printf("INPUT (%s) ", yytext);}
^MOVE          {printf("MOVE (%s) ", yytext);}
^ADD           {printf("ADD (%s) ", yytext);}
TO             {printf("TO (%s) ", yytext);}
^X+            {printf("VARABLE_SIZE (%s) ", yytext);}
[0-9]+         {printf("INTEGER (%s) ", yytext);}
[A-Za-z][A-Za-z0-9\-]* {printf("IDENTIFIER (%s) ", yytext);}
;              {printf("SEMI_COLON (%s) ", yytext);}
\"(\\.|[^"\\])*\"        {printf("STRING_LITERAL (%s) ", yytext);}
\.             {printf("STATEMENT_TERMINATOR (%s)", yytext);}
.              {printf("Encountered invalid syntax"); return(0);}
%%

int main() {
    yylex();
    return(0);
}

int yywrap() {}
