%{
#include <stdio.h>
#include <stdlib.h>

%}

CHAR		[A-Za-z_]
INTEIRO		[0-9]+
FLOAT		{INTEIRO}*"."{INTEIRO}+
BOOLEANO	("True"|"False")
ID 			{CHAR}({CHAR}|{INTEIRO})*

%%

[\n]		{}
[ \t]		{}

"main"		{return TK_MAIN;}

("int"|"float"|"boolean"|"char")    {yylval.label = yytext ;return TK_TIPO;}

"for"		{return TK_FOR;}
"while"		{return TK_WHILE;}
"if"		{return TK_IF;}
"else"		{return TK_ELSE;}
"function"	{return TK_FUNCTION;}
"return"	{return TK_RETURN;}
("<"|"<="|">"|">=")	{return TK_CONDITIONAL;}
("+"|"-"|"*"|"/"|"++"|"--"|"+="|"-=") {return *yytext;}

({INTEIRO}|{FLOAT}|{BOOLEANO}|'{CHAR}')	{yylval.traducao = yytext ;return TK_VALUE;}

{ID}		{yylval.label = yytext ;return TK_ID;}

[(){}[\];,=]	{ return *yytext; }

%%