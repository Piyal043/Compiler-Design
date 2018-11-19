/* C Declarations */

%{
	#include<stdio.h>
	int sym[26],store[26];
	int forswitch,val,i;
	int stack[1000],check[1000];
	int l=0;
	extern char *yytext;
	
%}

/* BISON Declarations */

%token num VAR If Else Main Int COLON Double String lfb rfb lsb rsb comma fs Add Sub Mul Div as bt st ploop nloop Switch Case Default str

%nonassoc IfX
%nonassoc Else
%nonassoc ploop
%nonassoc nloop
%left st bt
%left Add Sub
%left Mul Div	

/* Simple grammar rules */

%%

program: Main lfb rfb lsb cstatement rsb { printf("\nsuccessful compilation\n"); }
	 ;

cstatement: /* empty */

	| cstatement statement
	
	| cstatement cdeclaration
	
	| cstatement structure
	
	;
	
cdeclaration:	TYPE ID1 	{ printf("\nvalid declaration\n"); }
			;
			
TYPE : Int

     | Double

     | String
     ;

ID1  : ID1 comma  statement fs	{
						
			}

     | statement	{
				
			}
     ;

statement: fs

	| expression  			{ printf("\nvalue of expression: %d\n", $1); }

        | VAR as expression  		{ 
							sym[$1] = $3; 
							printf("\nValue of the variable %c : %d\t\n",$1+'a',$3);
						}

	;

expression: num				{ $$ = $1; 	}

	| VAR				{ $$ = sym[$1]; }

	| expression Add expression	{ $$ = $1 + $3; }

	| expression Sub expression	{ $$ = $1 - $3; }

	| expression Mul expression	{ $$ = $1 * $3; }

	| expression Div expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    	}

	| expression st expression	{ $$ = $1 < $3; }

	| expression bt expression	{ $$ = $1 > $3; }

	| lfb expression rfb		{ $$ = $2;	}
	
	| ploop lfb VAR as expression comma statement rfb lsb expression rsb {
		printf("%d %d %d\n",$3,sym[$3],$10);
		for(sym[$3]=$5;sym[$3]<=$7;sym[$3]+=1)
		{
			printf("expression in loop: %d\n",sym[$10]);
		}
		}
		
	;
	
structure :  Switch lfb expression rfb lsb ccase rsb {
														printf("Switch statement.\n");
														forswitch = $3;
														printf("Inside switch %d\n",$3);
														int m=0,no=0;
														for(m=0;m<l;m++){
														if(check[m]==forswitch)
															printf("%d\n",stack[forswitch]);
														else
															no=1;
															}
														if(no==1){printf(" %d \n",val);}
														l=0;
													}
		;
ccase: caselist| caselist defaultstm	;

caselist: casestm | casestm caselist ;

casestm: Case expression COLON expression 	{ 
												//printf("Now in Case: %d\n",$4);
												stack[$2]=$4;
												check[l]=$2;
												l++;
											}
		| Case expression COLON str { printf(" get %s\n",yytext);}
		;

defaultstm: Default COLON expression 		{ 			
												//printf("Now in Case: %d\n",$3);
												val=$3;
											}
	;
	
%%

int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}

