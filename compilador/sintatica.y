%{
#include <iostream>
#include <string>
#include <sstream>
#include <map>
#include <queue>
#include <vector>

#define YYSTYPE atributos

#define True 1
#define False 0

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
void inserir_tipo(string temp,string tipo, int pos);
void inserir_id(string id,string temp, int pos);
void clear_queue(std::queue<string> *fila);
void switch_queue( std::queue<string> *destino, std::queue<string> *origem );
string temp_id(string id);

std::vector< std::map<string,string> > hashs_id;
std::vector< std::map<string,string> > hashs_tipo;
int count_block = 0;

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

%token TK_NEGACAO
%token TK_OR
%token TK_AND

%token TK_FOR
%token TK_WHILE
%token TK_IF
%token TK_ELSE

%start S

%left '+' '-'
%left '*' '/'

%left TK_AND

%%

S 			: COMANDOS
			{
				cout << "/*Compilador NoMakeSense*/\n" << endl;

				while(!$1.declaracoes.empty())
				{
					cout << "\t" << $1.declaracoes.front() << "\n";
					$1.declaracoes.pop();
				}

				while(!$1.comandos.empty())
				{
					cout << "\t" << $1.comandos.front() << "\n";
					$1.comandos.pop();
				}
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

COMANDOS 	: COMANDO COMANDOS
			{
				clear_queue(&($$.declaracoes));				
				clear_queue(&($$.comandos));
				
				switch_queue( &($$.declaracoes), &($1.declaracoes) );	
				switch_queue( &($$.declaracoes), &($2.declaracoes) );			

				switch_queue(&($$.comandos), &($1.comandos));
				switch_queue(&($$.comandos), &($2.comandos));				
			}
			|
			{
				
				$$.traducao = "";
			}		
			;

COMANDO     : TK_FUNCTION TK_MAIN '('PARAMS')'
			{
				clear_queue( &($$.declaracoes) );
				clear_queue( &($$.comandos) );

				$$.comandos.push("int main(" + $4.traducao + ")");
			}
			| TK_TIPO TK_ID
			{
				std::map<string,string>::iterator it;
				
				it = hashs_id[count_block].find($2.label);
				if( it != hashs_id[count_block].end()) 
					yyerror("ERROR - Variaveis com mesmo ID declaradas!");					

				clear_queue(&($$.declaracoes));				
				clear_queue(&($$.comandos));

				$$.label = gentempcode();

				if(!count_block)
					$$.declaracoes.push($1.label + " " + $$.label + "; #" + $2.label);

				else
					$$.comandos.push($1.label + " " + $$.label + "; #" + $2.label);

				inserir_id($2.label,$$.label,count_block);
				inserir_tipo($$.label,$1.label, count_block);
			}
			| TK_TIPO TK_ID '=' E
			{
				clear_queue(&($$.declaracoes));				
				clear_queue(&($$.comandos));

				switch_queue( &($$.declaracoes), &($4.declaracoes) );		
				switch_queue( &($$.comandos), &($4.comandos) );		

				$$.label = gentempcode();
				inserir_id($2.label, $$.label, count_block);
				inserir_tipo($$.label, $1.label, count_block);

				string temporaria = $$.label;
				string tipo = $1.label;

				string tipo_exp = hashs_tipo[count_block][$4.label];
				string conversao = "";				

				if(tipo == "int" && tipo_exp == "float")
					conversao += "(int)";

				else if(tipo == "float" && tipo_exp == "int")
					conversao += "(float)";
				
				else if(tipo == "bool" && tipo_exp != "bool")
					conversao += "(bool)";				

				if(!count_block)
					$$.declaracoes.push($1.label + " " + $$.label + "; #" + $2.label + "\n");

				else
					$$.comandos.push($1.label + " " + $$.label + "; #" + $2.label + "\n");
					
				$$.comandos.push($$.label + " = " + conversao + $4.label + ";\n");
			}
			| TK_ID '=' E
			{
				clear_queue(&($$.declaracoes));				
				clear_queue(&($$.comandos));

				if(count_block == 0)
				{
					switch_queue( &($$.declaracoes), &($3.declaracoes) );
					switch_queue( &($$.comandos), &($3.comandos));
				}

				else
				{
					switch_queue( &($$.comandos), &($3.declaracoes) );
					switch_queue( &($$.comandos), &($3.comandos));
				}

				string temporaria = temp_id($1.label);
				string tipo = hashs_tipo[count_block][temporaria];
				
				string conversao = "";				
				string tipo_exp = hashs_tipo[count_block][$3.label];

				if(tipo == "int" && tipo_exp == "float")
					conversao += "(int)";

				else if(tipo == "float" && tipo_exp == "int")
					conversao += "(float)";
				
				else if(tipo == "bool" && tipo_exp != "bool")
					conversao += "(bool)";

				$$.comandos.push(temporaria + " = " + conversao + $3.label + ";\n");
			}
			| '{'
			{
				clear_queue(&($$.declaracoes));
				$$.comandos.push("{");

				std::map <string,string> aux_tipo;
				std::map <string,string> aux_id;

				hashs_id.push_back(aux_id);
				hashs_tipo.push_back(aux_tipo);

				count_block += 1;
			}
			| '}'
			{
				clear_queue(&($$.declaracoes));

				$$.comandos.push("}");

				hashs_id.pop_back();
				hashs_tipo.pop_back();
				count_block -= 1;
			}
			| TK_FIM
			{
				$$.traducao = "";
			}			
			;

E 			: E '+' E
			{
				$$.label = gentempcode();

				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));

				switch_queue( &($$.declaracoes), &($1.declaracoes) );
				switch_queue( &($$.comandos), &($1.comandos));
				
				switch_queue( &($$.declaracoes), &($3.declaracoes) );				
				switch_queue(&($$.comandos), &($3.comandos));			

				string tipoExp1 = hashs_tipo[count_block][$1.label];
				string tipoExp2 = hashs_tipo[count_block][$3.label];

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

				inserir_tipo($$.label,$$.tipo, count_block);
				
				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " + " + $3.label + ";");				
			}
			| E '-' E
			{
				$$.label = gentempcode();
				
				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));				

				switch_queue( &($$.declaracoes), &($1.declaracoes) );
				switch_queue(&($$.comandos), &($1.comandos));
				
				switch_queue( &($$.declaracoes), &($3.declaracoes) );				
				switch_queue(&($$.comandos), &($3.comandos));				

				string tipoExp1 = hashs_tipo[count_block][$1.label];
				string tipoExp2 = hashs_tipo[count_block][$3.label];

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

				inserir_tipo($$.label,$$.tipo, count_block);
				
				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " - " + $3.label + ";");
			}
			| E '/' E
			{
				$$.label = gentempcode();

				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));				

				switch_queue( &($$.declaracoes), &($1.declaracoes) );
				switch_queue(&($$.comandos), &($1.comandos));
				
				switch_queue( &($$.declaracoes), &($3.declaracoes) );
				switch_queue(&($$.comandos), &($3.comandos));			

				string tipoExp1 = hashs_tipo[count_block][$1.label];
				string tipoExp2 = hashs_tipo[count_block][$3.label];

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

				inserir_tipo($$.label,$$.tipo,count_block);
				
				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " / " + $3.label + ";");	
			}
			| E '*' E
			{
				$$.label = gentempcode();

				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));				

				switch_queue( &($$.declaracoes), &($1.declaracoes) );
				switch_queue(&($$.comandos), &($1.comandos));
				
				switch_queue( &($$.declaracoes), &($3.declaracoes) );
				switch_queue(&($$.comandos), &($3.comandos));			

				string tipoExp1 = hashs_tipo[count_block][$1.label];
				string tipoExp2 = hashs_tipo[count_block][$3.label];

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

				inserir_tipo($$.label,$$.tipo,count_block);
				
				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " * " + $3.label + ";");
			}
			| TK_NEGACAO E
			{	
				$$.label = gentempcode();
				$$.tipo = "bool";

				if($2.tipo != "bool")
					yyerror("Operacao invalida!");					

				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));

				switch_queue( &($$.declaracoes), &($2.declaracoes) );
				switch_queue(&($$.comandos), &($2.comandos));				

				inserir_tipo($$.label,$$.tipo, count_block);

				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + "!" + $2.label + ";");		
			}
			| E TK_AND E
			{
				$$.label = gentempcode();
				$$.tipo = "bool";

				if($1.tipo != "bool" || $3.tipo != "bool")
					yyerror("Operacao invalida!");	

				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));

				switch_queue( &($$.declaracoes), &($1.declaracoes) );
				switch_queue(&($$.comandos), &($1.comandos));

				switch_queue( &($$.declaracoes), &($3.declaracoes) );
				switch_queue(&($$.comandos), &($3.comandos));					

				inserir_tipo($$.label,$$.tipo, count_block);

				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " && " + $3.label + ";");
			}					
			| E TK_OR E
			{
				$$.label = gentempcode();
				$$.tipo = "bool";

				if($1.tipo != "bool" || $3.tipo != "bool")
					yyerror("Operacao invalida!");	

				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));

				switch_queue( &($$.declaracoes), &($1.declaracoes) );
				switch_queue(&($$.comandos), &($1.comandos));

				switch_queue( &($$.declaracoes), &($3.declaracoes) );
				switch_queue(&($$.comandos), &($3.comandos));				

				inserir_tipo($$.label,$$.tipo, count_block);

				$$.declaracoes.push($$.tipo + " " + $$.label + ";");
				$$.comandos.push($$.label +	" = " + $1.label + " || " + $3.label + ";");	
			}
			| E TK_RELACIONAL E
			{
				$$.label = gentempcode();
				$$.tipo = "bool";

				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));
				
				switch_queue( &($$.declaracoes), &($1.declaracoes) );
				switch_queue(&($$.comandos), &($1.comandos));

				switch_queue( &($$.declaracoes), &($3.declaracoes) );
				switch_queue(&($$.comandos), &($3.comandos));
				
				inserir_tipo($$.label,$$.tipo, count_block);

				$$.declaracoes.push("bool " + $$.label + ";");
				$$.comandos.push($$.label + " = " + $1.label + " " + $2.label + " " + $3.label + ";");
			}
			| '(' TK_TIPO ')' E
			{
				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));

				switch_queue( &($$.declaracoes), &($4.declaracoes) );
				switch_queue(&($$.comandos), &($4.comandos));
				
				$$.label = gentempcode();
				$$.tipo = $2.label;

				inserir_tipo($$.label,$$.tipo, count_block);

				$$.declaracoes.push($2.label + " " + $$.label + ";");
				$$.comandos.push($$.label + " = (" + $2.label + ")" + $4.label);
			}
			| TK_INT_VALUE
			{
				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));

				$$.label = gentempcode();
				
				$$.declaracoes.push("int " + $$.label + "; #" + $1.traducao);
				$$.comandos.push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"int",count_block);
			}
			| TK_FLOAT_VALUE
			{
				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));

				$$.label = gentempcode();

				$$.declaracoes.push("float " + $$.label + "; #" + $1.traducao);
				$$.comandos.push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"float",count_block);
			}		
			| TK_BOOLEANO_VALUE
			{				
				$$.label = gentempcode();
				$$.tipo = "bool";
				
				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));

				$$.declaracoes.push("bool " + $$.label + "; #" + $1.traducao);
				$$.comandos.push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"bool",count_block);
			}		
			| TK_CHAR_VALUE
			{
				$$.label = gentempcode();
				
				clear_queue(&($$.declaracoes));
				clear_queue(&($$.comandos));

				$$.declaracoes.push("char " + $$.label + "; #" + $1.traducao);
				$$.comandos.push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"char",count_block);
			}	
			| TK_ID
			{
				std::map<string,string>::iterator it;
				string temporaria = temp_id($1.label);

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

void inserir_tipo(string temp, string tipo, int pos){
	hashs_tipo[pos][temp] = tipo;
}

void inserir_id(string id, string temp, int pos){
	hashs_id[pos][id] = temp;
}

string temp_id(string id){
	std::map<string,string>::iterator it;

	for(int i = count_block; i >= 0 ; i--)
	{
		it = hashs_id[i].find(id);

		if( it != hashs_id[i].end()) 
			return it->second;
	}

	yyerror("ERROR - Variavel " + id + " nao foi declarada!");
}


int main(int argc, char* argv[])
{
	var_temp_qnt = 0;
	count_block = 0;

	std::map <string,string> aux_tipo;
	std::map <string,string> aux_id;

	hashs_id.push_back(aux_id);
	hashs_tipo.push_back(aux_tipo);

	yyparse();

	return 0;
}

void yyerror(string MSG)
{
	cout << MSG << endl;
	exit (0);
}

void clear_queue(std::queue<string> *fila)
{
	while (!fila->empty() != 0)
		fila->pop();
}

void switch_queue( std::queue<string> *destino, std::queue<string> *origem )
{
	while (!origem->empty())
		{
			destino->push(origem->front());
			origem->pop();
		}				
}