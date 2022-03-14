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

[\n]		{return TK_FIM;}
[ \t]		{}

"main"		{return TK_MAIN;}

("int"|"float"|"bool"|"char")    {yylval.label = yytext ;return TK_TIPO;}

"for"		{return TK_FOR;}
"while"		{return TK_WHILE;}
"if"		{return TK_IF;}
"else"		{return TK_ELSE;}
"function"	{return TK_FUNCTION;}
"return"	{return TK_RETURN;}

("+"|"-"|"*"|"/"|"++"|"--"|"+="|"-=") {return *yytext;}
("<"|"<="|">"|">="|"==")	{yylval.label = yytext; return TK_RELACIONAL;}
("!"|"|"|"&")     { return *yytext; }

{INTEIRO}   {yylval.traducao = yytext ;return TK_INT_VALUE;}
{FLOAT}     {yylval.traducao = yytext ;return TK_FLOAT_VALUE;}
{BOOLEANO}  {yylval.traducao = yytext ;return TK_BOOLEANO_VALUE;}
'{CHAR}'	{yylval.traducao = yytext ;return TK_CHAR_VALUE;}

{ID}		{yylval.label = yytext ;return TK_ID;}

[(){}[\];,=]	{ return *yytext; }

%%