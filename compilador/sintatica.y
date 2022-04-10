%{
#include <iostream>
#include <string>
#include <sstream>
#include <map>
#include <queue>
#include <vector>
#include <boost/algorithm/string.hpp>

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
};

int yylex(void);
void yyerror(string);
string gentempcode();
string gentemplabel();
string temp_id(string id);
void clear_queue(std::queue<string> *fila);
void inserir_id(string id,string temp, int pos);
void inserir_tipo(string temp,string tipo, int pos);
void switch_queue( std::queue<string> *destino, std::queue<string> *origem );

std::vector< std::queue<string> > declaracoes;
std::vector< std::queue<string> > comandos;

std::vector< std::map<string,string> > hashs_id;
std::vector< std::map<string,string> > hashs_tipo;
int count_block = 0;

std::vector< string > loop_stack;

%}

%token TK_MAIN
%token TK_FUNCTION
%token TK_OPERATOR
%token TK_RELACIONAL
%token TK_RETURN
%token TK_FIM TK_ERROR

%token TK_TIPO
%token TK_ID

%token TK_CIN
%token TK_COUT

%token TK_INT
%token TK_FLOAT
%token TK_CHAR
%token TK_BOOLEANO

%token TK_INT_VALUE
%token TK_FLOAT_VALUE
%token TK_CHAR_VALUE
%token TK_STRING_VALUE
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

				while(!declaracoes[0].empty())
				{
					cout << "\t" << declaracoes[0].front() << "\n";
					declaracoes[0].pop();
				}

				while(!comandos[0].empty())
				{
					cout << "\t" << comandos[0].front() << "\n";
					comandos[0].pop();
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
			|
			{
				
				$$.traducao = "";
			}		
			;

COMANDO     : TK_FUNCTION TK_MAIN '('PARAMS')'
			{
				if(!count_block)
					comandos[0].push("int main(" + $4.traducao + ")");
				
				else
					yyerror("Fução main declarada incorretamente!");
			}
			| TK_TIPO TK_ID
			{
				std::map<string,string>::iterator it;
				
				it = hashs_id[count_block].find($2.label);
				if( it != hashs_id[count_block].end()) 
					yyerror("ERROR - Variaveis com mesmo ID declaradas!");					

				$$.label = gentempcode();		

				inserir_id($2.label,$$.label,count_block);
				inserir_tipo($$.label,$1.label, count_block);		

				declaracoes[count_block].push($1.label + " " + $$.label + "; #" + $2.label);				
			}
			| TK_TIPO TK_ID '=' E
			{
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

				declaracoes[count_block].push($1.label + " " + $$.label + "; #" + $2.label + "\n");					
				comandos[count_block].push($$.label + " = " + conversao + $4.label + ";\n");
			}
			| TK_ID '=' E
			{
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

				comandos[count_block].push(temporaria + " = " + conversao + $3.label + ";");
			}
			| TK_IF '('E')'
			{
				$$.label = gentempcode();
				string label = gentemplabel();
				loop_stack.push_back("label " + label);

				declaracoes[count_block].push("bool " + $$.label + ";");
				comandos[count_block].push($$.label + " = !" + $3.label + ";");
				comandos[count_block].push("if(" + $$.label + ") goto " + label + ";");
			}
			| TK_ELSE '('E')'
			{
				comandos[count_block].push("else(!" + $3.label + ')');
				comandos[count_block].push("\tgoto labelif;");
			}
			| TK_WHILE '('E')'
			{
				comandos[count_block].push("while(!" + $3.label + ')');
				comandos[count_block].push("\tgoto labelif;");
			}
			| TK_FOR '(' COMANDO ';' E ';' COMANDO ')'
			{	
				std::queue< string > aux_queue;
				string label_ini = gentemplabel();
				string label_fim = gentemplabel();

				while(!comandos[count_block].empty())
				{
					string str = comandos[count_block].front();

					if( str.find($5.label) != -1 )
					{
						aux_queue.push("label " + label_ini );
					}

					aux_queue.push(str);
					comandos[count_block].pop();
				}

				comandos[count_block] = aux_queue;

				string temp = gentempcode();
				declaracoes[count_block].push("bool " + temp + ";");
				
				comandos[count_block].push(temp + " = " + "!" + $5.label + ";");								
				comandos[count_block].push("if(" + temp + ") goto " + label_fim + ";" );			
				
				loop_stack.push_back( "goto " + label_ini + ";" + "label " + label_fim);				
			}
			| '{'
			{
				std::map <string,string> aux_tipo;
				std::map <string,string> aux_id;
				
				hashs_id.push_back(aux_id);
				hashs_tipo.push_back(aux_tipo);

				std::queue<string> aux_declaracoes;
				std::queue<string> aux_comandos;

				declaracoes.push_back(aux_declaracoes);
				comandos.push_back(aux_comandos);

				count_block += 1;

				declaracoes[count_block].push("\n");
			}
			| '}'
			{
				int bloco_anterior = count_block - 1;
				switch_queue(&(comandos[bloco_anterior]), &(declaracoes[count_block]));
				switch_queue(&(comandos[bloco_anterior]), &(comandos[count_block]));

				if(!loop_stack.empty())
				{
					string str = loop_stack.back();

					vector<string> result;
				    boost::split(result, str, boost::is_any_of(";"));
 
    				for (int i = 0; i < result.size(); i++)
        				comandos[bloco_anterior].push(result[i] + ";");

					loop_stack.pop_back();
				}

				hashs_id.pop_back();
				hashs_tipo.pop_back();
				count_block -= 1;

				comandos[count_block].push("\n");
			}
			| TK_FIM
			{
				$$.traducao = "";
			}
			| TK_COUT '('TK_STRING_VALUE')'
			{
				comandos[count_block].push("cout << " + $3.traducao + " << endl;");
			}
			| TK_ID '=' TK_CIN '('')'
			{
				string temp = temp_id($1.label);				
			
				comandos[count_block].push("cin >> " + temp + ";");				
			}			
			;

E 			: E '+' E
			{
				$$.label = gentempcode();						

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
				
				declaracoes[count_block].push($$.tipo + " " + $$.label + ";");
				comandos[count_block].push($$.label +	" = " + $1.label + " + " + $3.label + ";");				
			}
			| E '-' E
			{
				$$.label = gentempcode();		

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
				
				declaracoes[count_block].push($$.tipo + " " + $$.label + ";");
				comandos[count_block].push($$.label +	" = " + $1.label + " - " + $3.label + ";");
			}
			| E '/' E
			{
				$$.label = gentempcode();		

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
				
				declaracoes[count_block].push($$.tipo + " " + $$.label + ";");
				comandos[count_block].push($$.label +	" = " + $1.label + " / " + $3.label + ";");	
			}
			| E '*' E
			{
				$$.label = gentempcode();					

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
				
				declaracoes[count_block].push($$.tipo + " " + $$.label + ";");
				comandos[count_block].push($$.label +	" = " + $1.label + " * " + $3.label + ";");
			}
			| '(' E ')'
			{
				$$.label = $2.label;
			}
			| TK_NEGACAO E
			{	
				$$.label = gentempcode();
				$$.tipo = "bool";

				if($2.tipo != "bool")
					yyerror("Operacao invalida!");							

				inserir_tipo($$.label,$$.tipo, count_block);

				declaracoes[count_block].push($$.tipo + " " + $$.label + ";");
				comandos[count_block].push($$.label +	" = " + "!" + $2.label + ";");		
			}
			| E TK_AND E
			{
				$$.label = gentempcode();
				$$.tipo = "bool";

				if($1.tipo != "bool" || $3.tipo != "bool")
					yyerror("Operacao invalida!");					

				inserir_tipo($$.label,$$.tipo, count_block);

				declaracoes[count_block].push($$.tipo + " " + $$.label + ";");
				comandos[count_block].push($$.label +	" = " + $1.label + " && " + $3.label + ";");
			}					
			| E TK_OR E
			{
				$$.label = gentempcode();
				$$.tipo = "bool";

				if($1.tipo != "bool" || $3.tipo != "bool")
					yyerror("Operacao invalida!");			

				inserir_tipo($$.label,$$.tipo, count_block);

				declaracoes[count_block].push($$.tipo + " " + $$.label + ";");
				comandos[count_block].push($$.label +	" = " + $1.label + " || " + $3.label + ";");	
			}
			| E TK_RELACIONAL E
			{
				$$.label = gentempcode();
				$$.tipo = "bool";			
				
				inserir_tipo($$.label,$$.tipo, count_block);

				declaracoes[count_block].push("bool " + $$.label + ";");
				comandos[count_block].push($$.label + " = " + $1.label + " " + $2.label + " " + $3.label + ";");
			}
			| '(' TK_TIPO ')' E
			{				
				$$.label = gentempcode();
				$$.tipo = $2.label;

				inserir_tipo($$.label,$$.tipo, count_block);

				declaracoes[count_block].push($2.label + " " + $$.label + ";");
				comandos[count_block].push($$.label + " = (" + $2.label + ")" + $4.label);
			}
			| TK_INT_VALUE
			{
				$$.label = gentempcode();
				
				declaracoes[count_block].push("int " + $$.label + "; #" + $1.traducao);
				comandos[count_block].push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"int",count_block);
			}
			| TK_FLOAT_VALUE
			{
				$$.label = gentempcode();

				declaracoes[count_block].push("float " + $$.label + "; #" + $1.traducao);
				comandos[count_block].push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"float",count_block);
			}		
			| TK_BOOLEANO_VALUE
			{				
				$$.label = gentempcode();
				$$.tipo = "bool";

				declaracoes[count_block].push("bool " + $$.label + "; #" + $1.traducao);
				comandos[count_block].push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"bool",count_block);
			}		
			| TK_CHAR_VALUE
			{
				$$.label = gentempcode();				

				declaracoes[count_block].push("char " + $$.label + "; #" + $1.traducao);
				comandos[count_block].push($$.label + " = " + $1.traducao + ";");

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

string gentemplabel()
{
	static int qnt = 1;
	
	return "label" + std::to_string(qnt++);
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

	std::queue<string> aux_declaracoes;
	std::queue<string> aux_comandos;

	declaracoes.push_back(aux_declaracoes);
	comandos.push_back(aux_comandos);

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