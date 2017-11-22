%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_OF_IDENTIFIERS 256

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

typedef struct {
   char* name;
   int size;
} Variable;

void yyerror (char *s);

void addNewVariable(int size, char* variable);
void moveIntToVariable(int newVal, char* variable);
void moveVariableToVariable(char* variableFrom, char* variableTo);
int sizeOfSymbolTable();
int getNumSize(int n);
Variable getVariable(char* varName);
int checkVariableDefined(char* variable);
void checkIdentifier(char* variable);

Variable identifiers[NUM_OF_IDENTIFIERS] = {};
int numVariables = 0;

%}

%union {int size; char* name; int num;}    /* Type definitions */

%start PROGRAM

%token begining
%token end
%token body
%token print 
%token input_keyword
%token move
%token add
%token to
%token semi_colon
%token string_literal
%token statement_terminator

%token <num> integer
%token <size> variable_size
%token <name> identifier

%%

/* grammar rules. */

PROGRAM : BEGINING_CONTENT BODY_CONTENT END {;}
        ;

/* Beginning content consists of begining keyword, statement terminator and n variable
   declarations */
BEGINING_CONTENT : begining statement_terminator DECLARATIONS {;}
		 ;

DECLARATIONS : DECLARATIONS DECLARATION {;}
	     | {;}
	     ;

DECLARATION : variable_size identifier statement_terminator {addNewVariable($1, $2);}
	    ;

/*Body content consists of begining keyword, statement terminator and n statements */

BODY_CONTENT : body statement_terminator STATEMENTS {;}
	     ;

STATEMENTS : STATEMENTS STATEMENT {;}
	   | {;}
           ;

/* All statements must finish in a statement terminator */
STATEMENT : SUB_STATEMENT statement_terminator {;}

SUB_STATEMENT : MOVE {;}
	      | PRINT {;}
              | INPUT {;}
              | ADD {;}
	      ;

MOVE : move integer to identifier {moveIntToVariable($2, $4);}
     | move identifier to identifier {moveVariableToVariable($2, $4);}
     ;

ADD : add integer to identifier {checkIdentifier($4);}
    | add identifier to identifier {checkIdentifier($2); checkIdentifier($4);}
    ;

INPUT : input_keyword INPUT_REMAINDER {;}
      ;

INPUT_REMAINDER : identifier {checkIdentifier($1);}
		| identifier semi_colon INPUT_REMAINDER {checkIdentifier($1);}

PRINT : print TO_PRINT {;}
      ;

TO_PRINT : string_literal TO_PRINT_REMAINDER {;}
	 | identifier TO_PRINT_REMAINDER {checkIdentifier($1);}
         ;

TO_PRINT_REMAINDER : {;}
		   | semi_colon identifier TO_PRINT_REMAINDER {checkIdentifier($2);}
                   | semi_colon string_literal TO_PRINT_REMAINDER {;}
                   ;

END : end statement_terminator {exit(0);}
%%

int main() {
   return yyparse();
}


void yyerror(char *s) {fprintf(stderr, "%s\n", s);}

void addNewVariable(int size, char* variable) {
    if(checkVariableDefined(variable) == 0) {
        printf("Variable %s declared twice, exiting...\n", variable);
	exit(1);
    }
    
    numVariables++;

    Variable var;
    char* temp = (char *) calloc(strlen(variable)+1, sizeof(char));
    strcpy(temp, variable);
    var.name = temp;
    var.size = size;
    identifiers[numVariables - 1] = var; 
}

int checkVariableDefined(char* variable) {
   for(int i=0; i < sizeOfSymbolTable(); i++) {
       if(identifiers[i].name != NULL) {
	       if(strcmp(identifiers[i].name, variable) == 0) {
		  return 0;
	       } 
       }
   }
   return -1;
}

void moveIntToVariable(int newVal, char* variable) {
    if(checkVariableDefined(variable) == 0) {
	    Variable var = getVariable(variable);

	    if(getNumSize(newVal) > var.size) {
		printf("WARNING: Moving integer to identifier of insufficient capacity. Moving %d to variable %s at line number %d\n", newVal, var.name, yylineno);
	    }
    } else {
         printf("Use of undefined variable %s at line %d, exiting...\n", variable, yylineno);
         exit(-1);
    }
}


void moveVariableToVariable(char* variableFrom, char* variableTo) {
    if(checkVariableDefined(variableFrom) != 0) {
         printf("Use of undefined variable %s at line %d, exiting...\n", variableFrom, yylineno);
         exit(-1);
    }

    if(checkVariableDefined(variableTo) != 0) {
         printf("Use of undefined variable %s at line %d, exiting...\n", variableTo, yylineno);
         exit(-1);
    }

    Variable varFrom = getVariable(variableFrom);
    Variable varTo = getVariable(variableTo);

    if(varFrom.size > varTo.size) {
        printf("WARNING: Moving identifier value to identifier of insufficient capacity. Moving value of variable %s to variable %s at line number %d\n", varFrom.name, varTo.name, yylineno);
    }
}
void checkIdentifier(char* variable) {
    if(checkVariableDefined(variable) != 0) {
         printf("Use of undefined variable %s at line %d, exiting...\n", variable, yylineno);
         exit(-1);
    }
}

Variable getVariable(char* varName) {

   for(int i=0; i < sizeOfSymbolTable(); i++) {
       if(strcmp(identifiers[i].name, varName) == 0) {
          return identifiers[i];
       } 
   }

}

int sizeOfSymbolTable() {
   return (sizeof(identifiers) / sizeof(identifiers[0]));
}

int getNumSize(int n) {
   if(n < 0) n = -n;
   
   int d = 1;

   while(n > 9) {
      n /= 10;
      d++;
   }
   return d;
}


