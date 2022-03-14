%{
#include <iostream>
#include <string>
#include <sstream>
#include <map>
#include <queue>

#define YYSTYPE atributos

using namespace std;

int var_temp_qnt;

struct atributos
{
	string label;
	string traducao;
	string tipo;

	std::queue<string> declaracoes;
	std::queue<string> comandos;
};

int yylex(void);
void yyerror(string);
string gentempcode();
void inserir_tipo(string temp,string tipo);
void inserir_id(string id,string temp);

std::map<string,string> hash_tipo;
std::map<string,string> hash_id;
%}

%token TK_MAIN
%token TK_FUNCTION
%token TK_OPERATOR
%token TK_RELACIONAL
%token TK_RETURN
%token TK_FIM TK_ERROR

%token TK_TIPO

%token TK_ID

%token TK_INT
%token TK_FLOAT
%token TK_CHAR
%token TK_BOOLEANO

%token TK_INT_VALUE
%token TK_FLOAT_VALUE
%token TK_CHAR_VALUE
%token TK_BOOLEANO_VALUE

%token TK_OPLOGICO

%token TK_FOR
%token TK_WHILE
%token TK_IF
%token TK_ELSE

%start S

%left '+'

%%
S 			: TK_FUNCTION TK_MAIN '('PARAMS')' BLOCO
			{
				cout << "/*Compilador Mongoloide*/\n" << "int main(" << $4.traducao << ")" << $6.traducao << endl;
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
				$$.traducao = "{\n";

				while (!$2.declaracoes.empty())
				{					
					$$.traducao += '\t' + $2.declaracoes.front();
					$2.declaracoes.pop();
				}

				while (!$2.comandos.empty())
				{				
					$$.traducao += '\t' + $2.comandos.front();
					$2.comandos.pop();
				}

				$$.traducao += "}";
			}
			|
			{
				$$.traducao = "";
			}
			;

COMANDOS 	: COMANDO COMANDOS
			{
				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();
				
				while ($$.comandos.size() != 0)
					$$.comandos.pop();
				
				while ($1.declaracoes.size() != 0)
				{
					$$.declaracoes.push($1.declaracoes.front());
					$1.declaracoes.pop();
				}				

				while ($2.declaracoes.size() != 0)
				{					
					$$.declaracoes.push($2.declaracoes.front());
					$2.declaracoes.pop();
				}

				while (!$1.comandos.empty())
				{					
					$$.comandos.push($1.comandos.front());
					$1.comandos.pop();
				}

				while (!$2.comandos.empty())
				{
					$$.comandos.push($2.comandos.front());
					$2.comandos.pop();
				}
			}		
			|
			{
				$$.traducao = "";
			}
			;

COMANDO     : TK_TIPO TK_ID TK_FIM
			{
				std::map<string,string>::iterator it;
				
				it = hash_id.find($2.label);
				if( it != hash_id.end()) 
					yyerror("ERROR - Variaveis com mesmo ID declaradas!");					

				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();
				
				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				$$.label = gentempcode();

				$$.declaracoes.push($1.label + " " + $$.label + "; #" + $2.label + "\n");

				inserir_id($2.label,$$.label);
				inserir_tipo($$.label,$1.label);
			}
			| TK_TIPO TK_ID '=' E TK_FIM
			{
				if($1.label == "char")
					yyerror("Operacao invalida!");

				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();
				
				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				while (!$4.declaracoes.empty())
				{
					$$.declaracoes.push($4.declaracoes.front() + "\n");
					$4.declaracoes.pop();
				}

				while (!$4.comandos.empty())
				{
					$$.comandos.push($4.comandos.front() + "\n");
					$4.comandos.pop();
				}

				$$.label = gentempcode();
				inserir_id($2.label, $$.label);
				inserir_tipo($$.label, $1.label);

				string temporaria = $$.label;
				string tipo = $1.label;
				
				string tipo_exp = hash_tipo[$4.label];
				string conversao = "";				

				if(tipo == "int" && tipo_exp == "float")
					conversao += "(int)";

				else if(tipo == "float" && tipo_exp == "int")
					conversao += "(float)";
				
				else if(tipo == "bool" && tipo_exp != "bool")
					conversao += "(bool)";				

				$$.declaracoes.push($1.label + " " + $$.label + "; #" + $2.label + "\n");
				$$.comandos.push($$.label + " = " + conversao + $4.label + ";\n");
			}
			| TK_ID '=' E TK_FIM
			{
				std::map<string,string>::iterator it;
				
				it = hash_id.find($1.label);
				if( it == hash_id.end()) 
					yyerror("Variavel '" + $1.label + "' não foi declarada!");

				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();
				
				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				while ($3.declaracoes.size() != 0)
				{					
					$$.declaracoes.push($3.declaracoes.front() + "\n");
					$3.declaracoes.pop();
				}

				while ($3.comandos.size() != 0)
				{				
					$$.comandos.push($3.comandos.front() + "\n");
					$3.comandos.pop();
				}

				string temporaria = hash_id[$1.label];				

				string tipo = hash_tipo[temporaria];
				
				string conversao = "";
				
				string tipo_exp = hash_tipo[$3.label];

				if(tipo == "int" && tipo_exp == "float")
					conversao += "(int)";

				else if(tipo == "float" && tipo_exp == "int")
					conversao += "(float)";
				
				else if(tipo == "bool" && tipo_exp != "bool")
					conversao += "(bool)";

				$$.comandos.push(temporaria + " = " + conversao + $3.label + ";\n");
			}
			| TK_FIM
			{
				$$.traducao = "";
			}
			;

E 			: E '+' E
			{
				$$.label = gentempcode();

				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
				$$.comandos.pop();

				while ($1.declaracoes.size() != 0)
				{
					$$.declaracoes.push($1.declaracoes.front());
					$1.declaracoes.pop();
				}

				while ($1.comandos.size() != 0)
				{
					$$.comandos.push($1.comandos.front());
					$1.comandos.pop();
				}

				while ($3.declaracoes.size() != 0)
				{
					$$.declaracoes.push($3.declaracoes.front());
					$3.declaracoes.pop();
				}
				
				while ($3.comandos.size() != 0)
				{
					$$.comandos.push($3.comandos.front());
					$3.comandos.pop();
				}				

				string tipoExp1 = hash_tipo[$1.label];
				string tipoExp2 = hash_tipo[$3.label];

				$$.tipo = "int";

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					$1.label = "(float)" + $1.label;

					$$.tipo = "float";
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					$2.label = "(float)" + $2.label;

					$$.tipo = "float";
				}
				else if (tipoExp1 == "float" && tipoExp2 == "float" ){					
					$$.tipo = "float";
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");		

				inserir_tipo($$.label,$$.tipo);
				
				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " + " + $3.label + ";");				
			}
			| E '-' E
			{
				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				$$.label = gentempcode();

				while ($1.declaracoes.size() != 0)
				{
					$$.declaracoes.push($1.declaracoes.front());
					$1.declaracoes.pop();
				}

				while ($1.comandos.size() != 0)
				{
					$$.comandos.push($1.comandos.front());
					$1.comandos.pop();
				}

				while ($3.declaracoes.size() != 0)
				{
					$$.declaracoes.push($3.declaracoes.front());
					$3.declaracoes.pop();
				}
				
				while ($3.comandos.size() != 0)
				{
					$$.comandos.push($3.comandos.front());
					$3.comandos.pop();
				}				

				string tipoExp1 = hash_tipo[$1.label];
				string tipoExp2 = hash_tipo[$3.label];

				$$.tipo = "int";

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					$1.label = "(float)" + $1.label;

					$$.tipo = "float";
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					$2.label = "(float)" + $2.label;

					$$.tipo = "float";
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");

				inserir_tipo($$.label,$$.tipo);
				
				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " - " + $3.label + ";");
			}
			| E '/' E
			{
				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				$$.label = gentempcode();

				while ($1.declaracoes.size() != 0)
				{
					$$.declaracoes.push($1.declaracoes.front());
					$1.declaracoes.pop();
				}

				while ($1.comandos.size() != 0)
				{
					$$.comandos.push($1.comandos.front());
					$1.comandos.pop();
				}

				while ($3.declaracoes.size() != 0)
				{
					$$.declaracoes.push($3.declaracoes.front());
					$3.declaracoes.pop();
				}
				
				while ($3.comandos.size() != 0)
				{
					$$.comandos.push($3.comandos.front());
					$3.comandos.pop();
				}				

				string tipoExp1 = hash_tipo[$1.label];
				string tipoExp2 = hash_tipo[$3.label];

				$$.tipo = "int";

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					$1.label = "(float)" + $1.label;

					$$.tipo = "float";
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					$2.label = "(float)" + $2.label;

					$$.tipo = "float";
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");

				inserir_tipo($$.label,$$.tipo);
				
				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " / " + $3.label + ";");	
			}
			| E '*' E
			{
				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
					$$.comandos.pop();
					
				$$.label = gentempcode();

				while ($1.declaracoes.size() != 0)
				{
					$$.declaracoes.push($1.declaracoes.front());
					$1.declaracoes.pop();
				}

				while ($1.comandos.size() != 0)
				{
					$$.comandos.push($1.comandos.front());
					$1.comandos.pop();
				}

				while ($3.declaracoes.size() != 0)
				{
					$$.declaracoes.push($3.declaracoes.front());
					$3.declaracoes.pop();
				}
				
				while ($3.comandos.size() != 0)
				{
					$$.comandos.push($3.comandos.front());
					$3.comandos.pop();
				}				

				string tipoExp1 = hash_tipo[$1.label];
				string tipoExp2 = hash_tipo[$3.label];

				$$.tipo = "int";

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					$1.label = "(float)" + $1.label;

					$$.tipo = "float";
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					$2.label = "(float)" + $2.label;

					$$.tipo = "float";
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");

				inserir_tipo($$.label,$$.tipo);
				
				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " * " + $3.label + ";");
			}
			| '!' E
			{	
				if($2.label != "bool")
					yyerror("Operacao invalida!");					

				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				while ($2.declaracoes.size() != 0)
				{
					$$.declaracoes.push($2.declaracoes.front());
					$2.declaracoes.pop();
				}

				while ($2.comandos.size() != 0)
				{
					$$.comandos.push($2.comandos.front());
					$2.comandos.pop();
				}			

				$$.label = gentempcode();
				$$.tipo = "boolean";

				inserir_tipo($$.label,$$.tipo);

				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + "!" + $2.label + ";");		
			}
			| E '&''&' E
			{
				if($2.label != "bool")
					yyerror("Operacao invalida!");	

				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
				$$.comandos.pop();

				while ($1.declaracoes.size() != 0)
				{
					$$.declaracoes.push($1.declaracoes.front());
					$1.declaracoes.pop();
				}

				while ($1.comandos.size() != 0)
				{
					$$.comandos.push($1.comandos.front());
					$1.comandos.pop();
				}

				while ($4.declaracoes.size() != 0)
				{
					$$.declaracoes.push($4.declaracoes.front());
					$4.declaracoes.pop();
				}
				
				while ($4.comandos.size() != 0)
				{
					$$.comandos.push($4.comandos.front());
					$4.comandos.pop();
				}	

				$$.label = gentempcode();
				$$.tipo = "boolean";

				inserir_tipo($$.label,$$.tipo);

				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " && " + $4.label + ";");
			}					
			| E '|''|' E
			{
				if($2.label != "bool")
					yyerror("Operacao invalida!");	

				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
				$$.comandos.pop();

				while ($1.declaracoes.size() != 0)
				{
					$$.declaracoes.push($1.declaracoes.front());
					$1.declaracoes.pop();
				}

				while ($1.comandos.size() != 0)
				{
					$$.comandos.push($1.comandos.front());
					$1.comandos.pop();
				}

				while ($4.declaracoes.size() != 0)
				{
					$$.declaracoes.push($4.declaracoes.front());
					$4.declaracoes.pop();
				}
				
				while ($4.comandos.size() != 0)
				{
					$$.comandos.push($4.comandos.front());
					$4.comandos.pop();
				}	

				$$.label = gentempcode();
				$$.tipo = "boolean";

				inserir_tipo($$.label,$$.tipo);

				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " || " + $4.label + ";");	
			}
			| E TK_RELACIONAL E
			{
				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
					$$.comandos.pop();
				
				while ($1.declaracoes.size() != 0)
				{
					$$.declaracoes.push($1.declaracoes.front());
					$1.declaracoes.pop();
				}

				while ($1.comandos.size() != 0)
				{
					$$.comandos.push($1.comandos.front());
					$1.comandos.pop();
				}

				while ($3.declaracoes.size() != 0)
				{
					$$.declaracoes.push($3.declaracoes.front());
					$3.declaracoes.pop();
				}

				while ($3.comandos.size() != 0)
				{
					$$.comandos.push($3.comandos.front());
					$3.comandos.pop();
				}

				$$.label = gentempcode();
				inserir_tipo($$.label,"bool");

				$$.declaracoes.push("bool " + $$.label + ";");
				$$.comandos.push($$.label + " = " + $1.label + " " + $2.label + " " + $3.label + ";");
			}
			| '(' TK_TIPO ')' E
			{
				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				while ($4.declaracoes.size() != 0)
				{
					$$.declaracoes.push($4.declaracoes.front());
					$4.declaracoes.pop();
				}

				while ($4.comandos.size() != 0)
				{
					$$.comandos.push($4.comandos.front());
					$4.comandos.pop();
				}
				
				$$.label = gentempcode();
				$$.tipo = $2.label;

				inserir_tipo($$.label,$$.tipo);

				$$.declaracoes.push($2.label + " " + $$.label + ";");
				$$.comandos.push($$.label + " = (" + $2.label + ")" + $4.label);
			}
			| TK_INT_VALUE
			{
				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				$$.label = gentempcode();
				
				$$.declaracoes.push("int " + $$.label + "; #" + $1.traducao);
				$$.comandos.push($$.label + " = " + $1.traducao + ";");


				inserir_tipo($$.label,"int");
			}
			| TK_FLOAT_VALUE
			{
				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				$$.label = gentempcode();

				$$.declaracoes.push("float " + $$.label + "; #" + $1.traducao);
				$$.comandos.push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"float");
			}		
			| TK_BOOLEANO_VALUE
			{				
				$$.label = gentempcode();
				
				while ($$.declaracoes.size() != 0)
				$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				$$.declaracoes.push("bool " + $$.label + "; #" + $1.traducao);
				$$.comandos.push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"bool");
			}		
			| TK_CHAR_VALUE
			{
				$$.label = gentempcode();
				
				while ($$.declaracoes.size() != 0)
					$$.declaracoes.pop();

				while ($$.comandos.size() != 0)
					$$.comandos.pop();

				$$.declaracoes.push("char " + $$.label + "; #" + $1.traducao);
				$$.comandos.push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"char");
			}	
			| TK_ID
			{
				std::map<string,string>::iterator it;
				string temporaria;
				
				it = hash_id.find($1.label);
				if( it != hash_id.end()) 
					temporaria = hash_id[$1.label];
				else
					yyerror("Variavel '" + $1.label + "' não foi declarada!");

				$$.label = temporaria;
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

void inserir_tipo(string temp, string tipo){
	hash_tipo[temp] = tipo;
}

void inserir_id(string id, string temp){
	hash_id[id] = temp;
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