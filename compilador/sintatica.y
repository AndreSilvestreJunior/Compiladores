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
				$$.traducao = "{" + $2.traducao + "}";
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

COMANDO     : TK_INT COMANDO
			{
				inserir_dado($2.traducao,"int");
				for( std::pair<string,string> it : mymap )
					cout << it.first << " " << it.second << endl;
			}
			|
			TK_FLOAT COMANDO
			{
				inserir_dado($2.traducao,"float");
				for( std::pair<string,string> it : mymap )
					cout << it.first << " " << it.second << endl;
			}
			|
			TK_CHAR COMANDO
			{
				inserir_dado($2.traducao,"char");
				for( std::pair<string,string> it : mymap )
					cout << it.first << " " << it.second << endl;				
			}
			|
			TK_ID
			{
				$$.traducao = $1.label;
			}
			|
			TK_CHAR_VALUE
			{
				cout << "Sou um token tipo char" << endl;
				$$.traducao = $1.label;
			}
			|
			TK_FIM
			{
				$$.traducao = "\n";
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