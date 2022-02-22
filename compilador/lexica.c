%{
#include <stdio.h>
#include <stdlib.h>

#define TK_INT 1
#define TK_FLOAT 2
#define TK_BOOLEAN 3
#define TK_CHAR 4

#define TK_INT_VALUE 5
#define TK_FLOAT_VALUE 6
#define TK_BOOLEAN_VALUE 7
#define TK_CHAR_VALUE 8
#define TK_ID 9

#define TK_FOR 11
#define TK_WHILE 12
#define TK_IF 13
#define TK_ELSE 14

#define TK_MAIN 15
#define TK_FUNCTION 16
#define TK_OPERATOR 17
#define TK_CONDITIONAL 18
#define TK_RETURN 19

%}

CHAR		[A-Za-z_]
INTEIRO		[0-9]+
FLOAT		{INTEIRO}*"."{INTEIRO}+
BOOLEANO	("True"|"False")
ID 			{CHAR}({CHAR}|{INTEIRO})*

%%

[\n]		{return 10;}
[ \t]		{}

"main"		{return TK_MAIN;}
"int"		{return TK_INT;}
"float"		{return TK_FLOAT;}
"boolean"	{return TK_BOOLEAN;}
"char"		{return TK_CHAR;}
"for"		{return TK_FOR;}
"while"		{return TK_WHILE;}
"if"		{return TK_IF;}
"else"		{return TK_ELSE;}
"function"	{return TK_FUNCTION;}
"return"	{return TK_RETURN;}
("<"|"<="|">"|">=")	{return TK_CONDITIONAL;}
("+"|"-"|"*"|"/"|"++"|"--"|"+="|"-=") {return TK_OPERATOR;}

{INTEIRO}	{return TK_INT_VALUE;}
{FLOAT}		{return TK_FLOAT_VALUE;}
{BOOLEANO}  {return TK_BOOLEAN_VALUE;}
{CHAR}		{return TK_CHAR_VALUE;}

{ID}		{return TK_ID;}

[(){}[\];,=]	{ return 100; }

%%

void main()
{
	int val;
	while ( (val = yylex()) > 0 ) {
		if(val == 10)
		{
			printf("\n");
			continue;
		}
		printf("%d ",val);		
	}

	printf("\n");	
}