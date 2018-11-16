/* C Declarations */

%{
	#include<stdio.h>
	int sym[26],store[26];
%}

/* BISON Declarations */

%token NUM VAR IF ELSE VOIDMAIN INT FLOAT CHAR LP RP LB RB CM SM PLUS MINUS MULT DIV ASSIGN GT LT
%nonassoc IFX
%nonassoc ELSE
%left LT GT
%left PLUS MINUS
%left MULT DIV	

/* Simple grammar rules */

%%

program: VOIDMAIN LP RP LB cstatement RB { printf("\nsuccessful compilation\n"); }
	 ;

cstatement: /* empty */

	| cstatement statement
	
	| cdeclaration
	;
	
cdeclaration:	TYPE ID1 SM	{ printf("\nvalid declaration\n"); }
			;
			
TYPE : INT

     | FLOAT

     | CHAR
     ;

ID1  : ID1 CM VAR	{
						
			}

     |VAR	{
				
			}
     ;

statement: SM

	| expression SM 			{ printf("\nvalue of expression: %d\n", $1); }

        | VAR ASSIGN expression SM 		{ 
							sym[$1] = $3; 
							printf("\nValue of the variable: %d\t\n",$3);
						}

	;

expression: NUM				{ $$ = $1; 	}

	| VAR				{ $$ = sym[$1]; }

	| expression PLUS expression	{ $$ = $1 + $3; }

	| expression MINUS expression	{ $$ = $1 - $3; }

	| expression MULT expression	{ $$ = $1 * $3; }

	| expression DIV expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    	}

	| expression LT expression	{ $$ = $1 < $3; }

	| expression GT expression	{ $$ = $1 > $3; }

	| LP expression RP		{ $$ = $2;	}
	;
%%

int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}

