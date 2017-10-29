%{

/*
 * Lex file for the jibuc language. 
 * This section contains imports and variable declarations.
 */

%}

%%
[\t]+          /* ignore whitespace */;
^BEGINING      {printf("BEGINING ");}
^BODY          {printf("BODY ");}
^END           {printf("END ");}
^PRINT         {printf("PRINT ");}
^INPUT         {printf("INPUT ");}
^MOVE          {printf("MOVE ");}
^ADD           {printf("ADD ");}
TO             {printf("TO ");}
^X+            {printf("VARABLE_SIZE ");}
\".*?\"        {printf("STRING_LITERAL ");}
[0-9]+         {printf("INTEGER ");}
[A-Za-z][A-Za-z0-9\-]* {printf("IDENTIFIER ");}
;              {printf("SEMI_COLON ");}
\.             {printf("STATEMENT_TERMINATOR");}
%%

int main() {
    yylex();
    exit(0);
}

int yywrap() {}
