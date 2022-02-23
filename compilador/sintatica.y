%{
#include <iostream>
#include <string>
#include <sstream>

#define YYSTYPE atributos

using namespace std;

int var_temp_qnt;

struct atributos
{
	string label;
	string traducao;
};

int yylex(void);
void yyerror(string);
string gentempcode();
%}

%token TK_MAIN
%token TK_FUNCTION
%token TK_OPERATOR
%token TK_CONDITIONAL
%token TK_RETURN
%token TK_FIM TK_ERROR

%token TK_INT
%token TK_FLOAT
%token TK_BOOLEAN
%token TK_CHAR

%token TK_INT_VALUE
%token TK_FLOAT_VALUE
%token TK_BOOLEAN_VALUE
%token TK_CHAR_VALUE
%token TK_ID 

%token TK_FOR
%token TK_WHILE
%token TK_IF
%token TK_ELSE

%start S

%left '+'

%%

S 			: TK_FUNCTION TK_MAIN '(' ')'
			{
				cout << "/*Compilador FOCA*/\n" << "int main()\n{\n}" << endl; 
			}
			;

%%

#include "lex.yy.c"

int yyparse();

string gentempcode()
{
	var_temp_qnt++;
	return "t" + std::to_string(var_temp_qnt);
}

int main(int argc, char* argv[])
{
	var_temp_qnt = 0;

	yyparse();

	return 0;
}

void yyerror(string MSG)
{
	cout << MSG << endl;
	exit (0);
}				
