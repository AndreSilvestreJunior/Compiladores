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
std::vector< string > loop_ends;
std::vector< string > loop_starts;

string switch_value = "";

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
%token TK_STRING
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
%token TK_DO
%token TK_SWITCH
%token TK_CASE
%token TK_BREAK
%token TK_CONTINUE

%start S

%left '+' '-'
%left '*' '/'

%left TK_AND

%%

S 			: TESTE
			{
				cout << "#include <iostream>\n" << endl;
				cout << "#define True 1;" << endl;
				cout << "#define False 0;\n" << endl;
				cout << "using namespace std;" << endl;
				cout << "\nint main(){\n" << endl;

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

				cout << "}\n" << endl;
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

TESTE		: COMANDOS TESTE
			| CONDICINAIS TESTE
			| LOOPS TESTE
			|
			{
			}
			;

COMANDOS 	: COMANDO COMANDOS
			|
			{
				
				$$.traducao = "";
			}		
			;

CONDICINAIS : TK_IF '('E')'
			{
				$$.label = gentempcode();
				string label = gentemplabel();
				loop_stack.push_back("label " + label);

				declaracoes[count_block].push("int " + $$.label + ";");
				comandos[count_block].push($$.label + " = !" + $3.label + ";");
				comandos[count_block].push("if(" + $$.label + ") goto " + label + ";");
			}
			| TK_ELSE
			{
				$$.label = gentempcode();	
				string label_fim = gentemplabel();			
				std::queue< string > aux_queue;

				while(!comandos[count_block].empty())
				{
					string str = comandos[count_block].front();

					if( str.find("label ") != -1 )
					{
						aux_queue.push("goto " + label_fim );
					}

					aux_queue.push(str);
					comandos[count_block].pop();
				}

				comandos[count_block] = aux_queue;

				loop_stack.push_back("label " + label_fim);
			}
			| TK_SWITCH '(' E ')'
			{
				string label = gentemplabel();
				switch_value = $3.label;
				loop_stack.push_back("label " + label);
				loop_ends.push_back(label);
			}
			| TK_CASE E
			{
				$$.label = gentempcode();

				if(switch_value == "" )
					yyerror("Nenhum switch foi iniciado!");

				declaracoes[count_block].push("int " + $$.label + ";");
				comandos[count_block].push($$.label + " = " + "(" + switch_value + " == " + $2.label + ")" );

				string label_aux = gentempcode();
				declaracoes[count_block].push("int " + label_aux + ";");				
				comandos[count_block].push(label_aux + " = !" + $$.label);

				string label = gentemplabel();
				comandos[count_block].push("if(" + label_aux + ")" + "goto " + label + ";");
				loop_stack.push_back("label " + label);
			}
			;
			
LOOPS		: TK_DO COMANDOS TK_WHILE '('E')'
			{
				$$.label = gentempcode();				
				string label_ini = gentemplabel();
				string label_fim = gentemplabel();
				std::queue< string > aux_queue;

				aux_queue.push("label " + label_ini);

				while(!comandos[count_block].empty())
				{
					string str = comandos[count_block].front();

					if(str.find("break") != -1)
					{
						aux_queue.push("goto " + label_fim + ";");
					}
					else if (str.find("continue") != -1)
					{
						aux_queue.push("goto " + label_ini + ";");
					}
					else
						aux_queue.push(str);

					comandos[count_block].pop();
				}

				comandos[count_block] = aux_queue;

				declaracoes[count_block].push("bool " + $$.label + ";");
				comandos[count_block].push($$.label + " = " + $5.label + ";");
				comandos[count_block].push("if(" + $$.label + ") goto " + label_ini + ";");
				comandos[count_block].push("label " + label_fim + ";");
			}			
			| TK_WHILE '('E')'
			{
				$$.label = gentempcode();				
				string label_ini = gentemplabel();
				string label_fim = gentemplabel();
				std::queue< string > aux_queue;

				while(!comandos[count_block].empty())
				{
					string str = comandos[count_block].front();

					if( str.find($3.label) != -1 )
					{
						aux_queue.push("label " + label_ini );
					}

					aux_queue.push(str);
					comandos[count_block].pop();
				}

				comandos[count_block] = aux_queue;

				declaracoes[count_block].push("bool " + $$.label + ";");
				comandos[count_block].push($$.label + " = !" + $3.label + ";");
				comandos[count_block].push("if(" + $$.label + ") goto " + label_fim + ";");

				loop_stack.push_back( "goto " + label_ini + ";" + "label " + label_fim);
				loop_ends.push_back(label_fim);
				loop_starts.push_back(label_ini);
			}			
			| TK_FOR '(' COMANDO ';' E ';' COMANDO ')'
			{	
				if($5.tipo != "bool")
					yyerror("Expressao invalida!");

				std::queue< string > aux_queue;
				string label_ini = gentemplabel();
				string label_fim = gentemplabel();
				
				string label_inter = gentemplabel();
				string cmd = label_inter + ":;";
				loop_starts.push_back(label_inter);		

				bool check = True;					

				while(!comandos[count_block].empty())
				{
					string str = comandos[count_block].front();

					if( str.find($3.label + " = ") != -1  && check == True)
					{
						aux_queue.push(str);					
						aux_queue.push(label_ini + ":" );

						comandos[count_block].pop();
						
						check = False;
						continue;
					}

					else if( str.find($7.label) != -1 )
					{
						cmd += str;
						comandos[count_block].pop();

						str = comandos[count_block].front();
						cmd += str;
						comandos[count_block].pop();

						continue;
					}

					aux_queue.push(str);
					comandos[count_block].pop();
				}

				comandos[count_block] = aux_queue;

				string temp = gentempcode();
				declaracoes[count_block].push("int " + temp + ";");
				
				comandos[count_block].push(temp + " = " + "!" + $5.label + ";");								
				comandos[count_block].push("if(" + temp + ") goto " + label_fim + ";" );			
				
				loop_stack.push_back( cmd + "goto " + label_ini + ";" + label_fim);				
				loop_ends.push_back(label_fim);
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

				if($1.label == "int")
					comandos[count_block].push($$.label + " = " + "0;");

				else if($1.label == "float")
					comandos[count_block].push($$.label + " = " + "0.0;");

				else if($1.label == "char")
					comandos[count_block].push($$.label + " = " + "'';");

				else if($1.label == "string")
				{
					$1.label = "char*";
				}
				else if($1.label == "bool")
				{					
					comandos[count_block].push($$.label + " = " + "False ;");
					$1.label = "int";
				}			

				declaracoes[count_block].push($1.label + " " + $$.label + "; //" + $2.label);
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
					conversao += "(int)";	
				
				else if($1.label == "string")
				{
					$1.label = "char*";
				}

				declaracoes[count_block].push($1.label + " " + $$.label + "; //" + $2.label + "\n");					
				comandos[count_block].push($$.label + " = " + conversao + $4.label + ";\n");
			}
			| TK_ID '=' E
			{
				$$.label = $3.label;
				string temporaria = temp_id($1.label);
				string tipo = hashs_tipo[count_block][temporaria];
				
				string conversao = "";				
				string tipo_exp = hashs_tipo[count_block][$3.label];

				if(tipo == "int" && tipo_exp == "float")
					conversao += "(int)";

				else if(tipo == "float" && tipo_exp == "int")
					conversao += "(float)";
				
				else if(tipo == "bool" && tipo_exp != "bool")
					conversao += "(int)";

				comandos[count_block].push(temporaria + " = " + conversao + $3.label + ";");
			}
			| TK_BREAK
			{
				if(loop_ends.empty())
					comandos[count_block].push("break");

				else
				{
					string str = loop_ends.back();
					comandos[count_block].push("goto " + str + ";");
				}
			}
			| TK_CONTINUE
			{
				if(loop_starts.empty())
					comandos[count_block].push("continue");
				
				else
				{
					string str = loop_starts.back();
					comandos[count_block].push("goto " + str + ";");
				}				
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
			}
			| '}'
			{
				int bloco_anterior = count_block - 1;
				switch_queue(&(declaracoes[bloco_anterior]), &(declaracoes[count_block]));
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
			}
			| TK_FIM
			{
				$$.traducao = "";
			}
			| TK_COUT '('E')'
			{
				comandos[count_block].push("cout << " + $3.label + " << endl;");
			}
			| TK_ID '=' TK_CIN '('')'
			{
				string temp = temp_id($1.label);				
			
				comandos[count_block].push("cin >> " + temp + ";");				
			}			
			;

E 			: E '+' E
			{
				string tipoExp1 = hashs_tipo[count_block][$1.label];
				string tipoExp2 = hashs_tipo[count_block][$3.label];

				$$.tipo = "int";				

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + $1.label + ";");

					$1.label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + $3.label + ";");

					$3.label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if (tipoExp1 == "float" && tipoExp2 == "float" ){					
					$$.tipo = "float";
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");		

				$$.label = gentempcode();

				inserir_tipo($$.label,$$.tipo, count_block);		

				declaracoes[count_block].push($$.tipo + " " + $$.label + ";");			
				comandos[count_block].push($$.label +	" = " + $1.label + " + " + $3.label + ";");				
			}
			| E '-' E
			{
				string tipoExp1 = hashs_tipo[count_block][$1.label];
				string tipoExp2 = hashs_tipo[count_block][$3.label];

				$$.tipo = "int";

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + $1.label + ";");

					$1.label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + $3.label + ";");

					$3.label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");

				$$.label = gentempcode();

				inserir_tipo($$.label,$$.tipo, count_block);
				
				declaracoes[count_block].push($$.tipo + " " + $$.label + ";");
				comandos[count_block].push($$.label +	" = " + $1.label + " - " + $3.label + ";");
			}
			| E '/' E
			{
				string tipoExp1 = hashs_tipo[count_block][$1.label];
				string tipoExp2 = hashs_tipo[count_block][$3.label];

				$$.tipo = "int";

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + $1.label + ";");

					$1.label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + $3.label + ";");

					$3.label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");

				$$.label = gentempcode();

				inserir_tipo($$.label,$$.tipo,count_block);
				
				declaracoes[count_block].push($$.tipo + " " + $$.label + ";");
				comandos[count_block].push($$.label +	" = " + $1.label + " / " + $3.label + ";");	
			}
			| E '*' E
			{
				string tipoExp1 = hashs_tipo[count_block][$1.label];
				string tipoExp2 = hashs_tipo[count_block][$3.label];

				$$.tipo = "int";

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + $1.label + ";");

					$1.label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + $3.label + ";");

					$3.label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");

				$$.label = gentempcode();	

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

				declaracoes[count_block].push("int " + $$.label + ";");
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
			| TK_ID '['TK_INT_VALUE']'
			{
				string tem_index = gentempcode();
				
				string temp = temp_id($1.label);

				declaracoes[count_block].push("int " + tem_index + "; #" + $3.traducao);
				comandos[count_block].push(tem_index + " = " + $3.traducao + ";");

				inserir_tipo($$.label,"int",count_block);

				$$.label = gentempcode();
				declaracoes[count_block].push("char " + $$.label + ";");
				comandos[count_block].push($$.label + " = " + temp + "[" + tem_index + "];");
			}
			| TK_INT_VALUE
			{
				$$.label = gentempcode();
				
				declaracoes[count_block].push("int " + $$.label + "; //" + $1.traducao);
				comandos[count_block].push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"int",count_block);
			}
			| TK_FLOAT_VALUE
			{
				$$.label = gentempcode();

				declaracoes[count_block].push("float " + $$.label + "; //" + $1.traducao);
				comandos[count_block].push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"float",count_block);
			}		
			| TK_BOOLEANO_VALUE
			{				
				$$.label = gentempcode();
				$$.tipo = "bool";

				declaracoes[count_block].push("int " + $$.label + "; //" + $1.traducao);
				comandos[count_block].push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"bool",count_block);
			}		
			| TK_CHAR_VALUE
			{
				$$.label = gentempcode();				

				declaracoes[count_block].push("char " + $$.label + "; //" + $1.traducao);
				comandos[count_block].push($$.label + " = " + $1.traducao + ";");

				inserir_tipo($$.label,"char",count_block);
			}
			| TK_STRING_VALUE
			{
				$$.label = gentempcode();
				int len = $1.traducao.size() + 1;

				declaracoes[count_block].push("char " + $$.label + "[" + to_string(len-2) + "]" + "; //" + $1.traducao);

				inserir_tipo($$.label, "string", count_block);

				for (size_t i = 1; i < $1.traducao.size()-1; i++)
				{
					string str = $$.label + "[" + to_string(i-1) + "] = '" + $1.traducao[i] + "';";
					comandos[count_block].push(str);
				}    
    
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