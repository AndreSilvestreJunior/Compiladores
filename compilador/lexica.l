%{
#include <stdio.h>
#include <stdlib.h>

%}

CHAR		[A-Za-z_]
INTEIRO		[0-9]+
FLOAT		{INTEIRO}*"."{INTEIRO}+
BOOLEANO	("True"|"False")
ID 			{CHAR}({CHAR}|{INTEIRO})*
ASPAS       ["]
STRING      {ASPAS}.*{ASPAS}

%%

[\n]		{return TK_FIM;}
[ \t]		{}

"main"		{return TK_MAIN;}

("int"|"float"|"bool"|"char"|"string")    {yylval.label = yytext ;return TK_TIPO;}

"for"		{return TK_FOR;}
"while"		{return TK_WHILE;}
"if"		{return TK_IF;}
"else"		{return TK_ELSE;}
"do"        {return TK_DO;}
"switch"    {return TK_SWITCH;}
"case"      {return TK_CASE;}
"function"	{return TK_FUNCTION;}
"return"	{return TK_RETURN;}
"break"     {return TK_BREAK;}
"continue"  {return TK_CONTINUE;}

"scan"       {return TK_CIN;}
"print"      {return TK_COUT;}

("+"|"-"|"*"|"/") {return *yytext;}
("+="|"-="|"*="|"/=") { yylval.label = yytext; return TK_COMPOSTO; }
("<"|"<="|">"|">="|"==")	{yylval.label = yytext; return TK_RELACIONAL;}

"!"     { return TK_NEGACAO; }
"||"    { return TK_OR; }
"&&"    { return TK_AND; }

{INTEIRO}   {yylval.traducao = yytext ;return TK_INT_VALUE;}
{FLOAT}     {yylval.traducao = yytext ;return TK_FLOAT_VALUE;}
{BOOLEANO}  {yylval.traducao = yytext ;return TK_BOOLEANO_VALUE;}
'{CHAR}'	{yylval.traducao = yytext ;return TK_CHAR_VALUE;}
{STRING}    {yylval.traducao = yytext ;return TK_STRING_VALUE;}

{ID}		{yylval.label = yytext ;return TK_ID;}

[(){}[\];,=]	{ return *yytext; }

%%