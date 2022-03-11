%{
#include <iostream>
#include <string>
#include <sstream>
#include <map>

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
void inserir_dado(string key,string value);
std::map<string,string> mymap;
%}

%token TK_MAIN
%token TK_FUNCTION
%token TK_OPERATOR
%token TK_CONDITIONAL
%token TK_RETURN
%token TK_FIM TK_ERROR

%token TK_TIPO

%token TK_VALUE

%token TK_ID

%token TK_FOR
%token TK_WHILE
%token TK_IF
%token TK_ELSE

%start S

%left '+'

%%

S 			: TK_FUNCTION TK_MAIN '('PARAMS')' BLOCO
			{
				cout << "/*Compilador FOCA*/\n" << "int main(" << $4.traducao << ")" << $6.traducao << endl;
			}
			;

PARAMS 		: PARAMS ',' PARAMS
			{
				$$.traducao = $1.traducao + ',' + $3.traducao;
			}
			| TK_ID
			{
				$$.traducao = $1.label;
			}
			|
			{
				$$.traducao = "";
			}
			;

BLOCO		: '{' COMANDOS '}'
			{
				$$.traducao = "{\n" + $2.traducao + "\n}";
			}
			|
			{
				$$.traducao = "";
			}
			;

COMANDOS 	: COMANDO COMANDOS
			{
				$$.traducao = $1.traducao + $2.traducao;
			}		
			|
			{
				$$.traducao = "";
			}
			;

COMANDO     : TK_TIPO TK_ID
			{
				$$.traducao = $1.traducao + " " + $2.label;
			}
			|
			TK_TIPO TK_ID '=' E
			{
				$$.traducao = $1.label + " " + $2.label + " \n" + $4.traducao;
			} 
			;

E 			: E '+' E
			{
				$$.label = gentempcode();
				$$.traducao =  $1.label + "\n" + $$.label + "\n" + $3.traducao + "\n" + $$.label + 
					" = " + $1.label + " + " + $3.label + ";";
			}
			| E '-' E
			{
				$$.label = gentempcode();
				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + 
					" = " + $1.label + " - " + $3.label + ";\n";
			}
			| E '/' E
			{
				$$.label = gentempcode();
				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + 
					" = " + $1.label + " / " + $3.label + ";\n";
			}
			| E '*' E
			{
				$$.label = gentempcode();
				$$.traducao =  $1.label + "\n" + $$.label + "\n" + $3.traducao + "\n" + $$.label + 
					" = " + $1.label + " * " + $3.label + ";";				
			}
			| TK_VALUE
			{
				$$.label = gentempcode();
				$$.traducao =  $$.label;
			}
			| TK_ID
			{
				$$.traducao = " " +  $1.label;
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

void inserir_dado(string key, string value){
	mymap[key] = value;
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