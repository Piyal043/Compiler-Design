/* C Declarations */

%{
	#include<stdio.h>
	#include "n.tab.h"
	#include<stdlib.h>
	extern int yylval;
%}

/*RE and Actio
n*/

%%

"v_int"	{ return Int; }
"v_double"	{ return Double; }
"v_string"	{ return String; }

[0-9]+	{ 
		yylval = atoi(yytext);
		return num;
	}
	
"lfb"	{ return lfb; }
"rfb"	{ return rfb; }
"lsb"	{ return lsb; }
"rsb"	{ return rsb; }
"comma"	{ return comma; }
"fs"	{ return fs; }
"add"	{ return Add; }
"sub"	{ return Sub; }
"::" 	{ return COLON; }
"mul"	{ return Mul; }
"div"	{ return Div; }
"as"	{ return as;  }
"bt"	{ return bt; }
"st"	{ return st; }
"ploop"  {return ploop;}
"switch" {return Switch;}
"case" {return Case;}
[a-z][a-z]+ {
			return str;
			}

[a-z]	{
		yylval = *yytext - 'a';
		return	VAR;
	}

"@if"		{ return If;		}
"@else"		{ return Else;		}

"v_int main :"	{ return Main; }

[ \t\n]*	;

.	{
		yyerror("Unknown Character.\n");
	}
%%

/* user subroutines */

int main()
{
	yyin = freopen("a.txt","r",stdin);
	//yyout = freopen("out.txt","w",stdout);
	
	yyparse();

}

