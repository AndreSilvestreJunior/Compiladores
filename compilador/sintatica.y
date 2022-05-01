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
string tipo_id(string id);
string search_declaration(std::queue<string> fila, string temp);
void preprocess();
void preprocess_func();
void clear_queue(std::queue<string> *fila);
void inserir_id(string id,string temp, int pos);
void inserir_tipo(string temp,string tipo, int pos);
void switch_queue( std::queue<string> *destino, std::queue<string> *origem );

std::vector< std::queue<string> > declaracoes;
std::vector< std::queue<string> > comandos;

bool is_main = False;

string functions = "";

std::vector< std::map<string,string> > hashs_id;
std::vector< std::map<string,string> > hashs_tipo;
int count_block = 0;

std::map<string,string> func_tipos;
std::map< string, std::queue<string> > func_dec;
std::map< string, std::queue<string> > func_op;
string current_func = "";

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

%token TK_UNARIO
%token TK_COMPOSTO

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

				preprocess_func();
				preprocess();
			

				for( std::pair<string, std::queue<string> > it : func_dec )
				{
					string name = it.first;
					std::queue<string> fila_dec = it.second;

					cout << fila_dec.front() << ";" << endl;
				}

				cout << endl;

				for( std::pair<string, std::queue<string> > it : func_dec )
				{
					string name = it.first;
					std::queue<string> fila_dec = it.second;

					cout << fila_dec.front() << "\n";
					fila_dec.pop();

					while(!fila_dec.empty())
					{						
						if(fila_dec.front() != "{")
							cout << "\t";

						cout << fila_dec.front() << "\n";
						fila_dec.pop();
					}

					std::queue<string> fila_op = func_op[name];

					while(!fila_op.empty())
					{
						string str =  fila_op.front();
						if( str.find("funcao") != -1 )
						{
							vector<string> result;
				    		boost::split(result, str, boost::is_any_of(" "));

							std::map<string,std::queue<string>>::iterator it;
							it = func_dec.find(result[1]);
							if( it == func_dec.end()) 
								yyerror("Funcao " + result[1] + " nao foi declarada!");
							
							fila_op.pop();
							continue;
						}						

						if(str != "}")
							cout << "\t";						
						
						cout << str << "\n";						
						
						fila_op.pop();
					}
				}
				
				cout << "\nint main()\n{" << endl;

				while(!declaracoes[0].empty())
				{
					cout << "\t" << declaracoes[0].front() << "\n";
					declaracoes[0].pop();
				}

				while(!comandos[0].empty())
				{
					string str =  comandos[0].front();
					if( str.find("funcao") != -1 )
					{
						vector<string> result;
						boost::split(result, str, boost::is_any_of(" "));

						std::map<string,std::queue<string>>::iterator it;
						it = func_dec.find(result[1]);
						if( it == func_dec.end()) 
							yyerror("Funcao " + result[1] + " nao foi declarada!");
						
						comandos[0].pop();
						continue;
					}										

					cout << "\t" << str << "\n";
					comandos[0].pop();
				}

				cout << "}\n" << endl;
			}
			;

PARAMS 		: PARAMS ',' PARAMS
			{
				$$.traducao = $1.traducao + ',' + $3.traducao;
			}
			| TK_TIPO TK_ID
			{
				$$.label = gentempcode();		
				
				inserir_id($2.label,$$.label,count_block);
				inserir_tipo($$.label,$1.label, count_block);

				$$.traducao = $1.label + " " + $$.label;
			}
			| E
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
				string label_fim = gentemplabel() + ":";
				
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

COMANDO     : TK_FUNCTION TK_ID '('PARAMS')'
			{
				std::queue <string> aux;
				std::queue <string> aux2;

				func_dec[$2.label] = aux;
				func_op[$2.label] = aux2;

				func_dec[$2.label].push("\nvoid " + $2.label + "(" + $4.traducao +  ")");

				current_func = $2.label;

				func_tipos[current_func] = "void";
			}
			| TK_FUNCTION TK_MAIN '('PARAMS')'
			{
				is_main = True;
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
			| TK_TIPO TK_ID '[' TK_INT_VALUE ']'
			{
				std::map<string,string>::iterator it;
				
				it = hashs_id[count_block].find($2.label);
				if( it != hashs_id[count_block].end()) 
					yyerror("ERROR - Variaveis com mesmo ID declaradas!");					

				$$.label = gentempcode();		
				
				inserir_id($2.label,$$.label,count_block);
				inserir_tipo($$.label,$1.label, count_block);

				int tamanho = stoi($4.traducao);

				declaracoes[count_block].push($1.label + " " + $$.label + "[" + $4.traducao + "]" + ";");

				string inicial_val;

				if ($1.label == "int")
					inicial_val = "0"; 

				for(int i = 0; i < tamanho; i++)
				{
					comandos[count_block].push($$.label + "[" + to_string(i) + "] = " + inicial_val + ";");
				}
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
			| TK_ID '[' TK_INT_VALUE ']' '=' E
			{
				string temp = temp_id($1.label);

				comandos[count_block].push(temp + "[" + $3.traducao + "] = " + $6.label + ";");
			}
			| TK_ID '=' TK_ID '(' PARAMS ')'
			{
				string temp = temp_id($1.label);

				std::map<string,std::queue<string>>::iterator it;
				
				it = func_dec.find($3.label);
				if( it == func_dec.end())					
					comandos[count_block].push("funcao " + $3.label);		

				comandos[count_block].push(temp + " = " + $3.label + "(" + $5.traducao + ");" );
			}
			| TK_ID '(' PARAMS ')'
			{
				std::map<string,std::queue<string>>::iterator it;
				
				it = func_dec.find($1.label);
				if( it == func_dec.end()) 
					comandos[count_block].push("funcao " + $1.label);							

				comandos[count_block].push($1.label + "(" + $3.traducao + ");" );
			}
			| TK_RETURN E
			{
				string temp = $2.label;
				string tipo = tipo_id(temp);

				if(!is_main)
				{
					func_dec[current_func].front().replace(0,5,tipo);
					func_tipos[current_func] = tipo;
				}

				comandos[count_block].push("return " + temp + ";");
			}
			| TK_ID TK_COMPOSTO E
			{
				string temp = temp_id($1.label);
				string op = $2.label;
				
				$$.label = gentempcode();
				declaracoes[count_block].push("int " + $$.label + ";");
				
				if( op == "+=")
				{
					comandos[count_block].push($$.label + " = " + temp + " + " + $3.label + ";");
					comandos[count_block].push(temp + " = " + $$.label + ";");					
				}
				else if(op == "-=")
				{
					comandos[count_block].push($$.label + " = " + temp + " - " + $3.label + ";");
					comandos[count_block].push(temp + " = " + $$.label + ";");	
				}
				else if(op == "*=")
				{
					comandos[count_block].push($$.label + " = " + temp + " * " + $3.label + ";");
					comandos[count_block].push(temp + " = " + $$.label + ";");	
				}
				else if(op == "/=")
				{
					comandos[count_block].push($$.label + " = " + temp + " / " + $3.label + ";");
					comandos[count_block].push(temp + " = " + $$.label + ";");	
				}
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
				
				if(is_main){
					switch_queue(&(declaracoes[bloco_anterior]), &(declaracoes[count_block]));
					switch_queue(&(comandos[bloco_anterior]), &(comandos[count_block]));

					if(!bloco_anterior)
						is_main = False;
				}

				else{
					func_dec[current_func].push("{");

					while(!declaracoes[count_block].empty())
					{
						string str = declaracoes[count_block].front();
						func_dec[current_func].push(str);
						declaracoes[count_block].pop();
					}

					while(!comandos[count_block].empty())
					{
						string str = comandos[count_block].front();
						func_op[current_func].push(str);
						comandos[count_block].pop();
					}

					func_op[current_func].push("}");
				}

				if(!loop_stack.empty())
				{
					string str = loop_stack.back();

					vector<string> result;
				    boost::split(result, str, boost::is_any_of(";"));
 
    				for (int i = 0; i < result.size(); i++)
						if(result[i].find("label"))
							comandos[bloco_anterior].push(result[i]);
        				else
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

				$$.tipo = "float";

				if(tipoExp1 == "char" || tipoExp2 == "char")
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
			| '-' E
			{
				$$.label = gentempcode();
				string aux = gentempcode();

				declaracoes[count_block].push("int " + aux + ";");

				comandos[count_block].push(aux + " = " + "-1;");
				comandos[count_block].push($$.label + " = " + $2.label + " * " + aux + ";");
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
				string tipo = hashs_tipo[count_block][temp];

				declaracoes[count_block].push("int " + tem_index + "; #" + $3.traducao);
				comandos[count_block].push(tem_index + " = " + $3.traducao + ";");

				inserir_tipo($$.label,"int",count_block);

				$$.label = gentempcode();
				declaracoes[count_block].push(tipo + $$.label + ";");
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

string tipo_id(string id){
	std::map<string,string>::iterator it;

	for(int i = count_block; i >= 0 ; i--)
	{
		it = hashs_tipo[i].find(id);

		if( it != hashs_tipo[i].end()) 
			return it->second;
	}

	yyerror("ERROR - Tipo da variavel " + id + " nao foi declarada!");
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

void preprocess()
{
	std::queue<string> new_cmds;
	std:queue<string> dlcs = declaracoes[0];

	while(!comandos[0].empty())
	{
		string str = comandos[0].front();

		if(str.find("(") != -1){
			
			std::vector<string> result;
			boost::split(result, str, boost::is_any_of("("));
			if(result.size() > 1)
			{
				string temp;
				string funcao;

				vector<string> result2;
				boost::split(result2, result[0], boost::is_any_of(" "));

				temp = result2[0];
				funcao = result2[2];				

				string tipo_func = func_tipos[funcao];
				string tipo_temp;

				while(!dlcs.empty())
				{
					string str = dlcs.front();

					if(str.find(temp) != -1)
					{
						vector<string> result;
						boost::split(result, str, boost::is_any_of(" "));

						tipo_temp = result[0];
						break;
					}

					dlcs.pop();
				}

				if(tipo_temp != tipo_func)
				{
					string label = gentempcode();
					string label2 = gentempcode();
					declaracoes[0].push(tipo_temp + " " + label + ";");
					declaracoes[0].push(tipo_func + " " + label2 + ";");
					
					new_cmds.push(label2 + " = " + funcao + "(" + result[result.size()-1]);
					new_cmds.push(label + " = (" + tipo_temp + ")" + label2 + ";");
					new_cmds.push(temp + " = " + label + ";");
					comandos[0].pop();
					continue;
				}
			}

		}

		new_cmds.push(str);
		comandos[0].pop();
	}

	comandos[0] = new_cmds;
}

void preprocess_func()
{
	for( std::pair<string, std::queue<string> > it : func_op )
	{
		std::queue<string> new_cmds;
		std::queue<string> cmds = it.second;

		std:queue<string> dlcs = func_dec[it.first];

		while(!cmds.empty())
		{
			string str = cmds.front();

			if(str.find("(") != -1){
				
				std::vector<string> result;
				boost::split(result, str, boost::is_any_of("("));
				if(result.size() > 1)
				{
					string temp;
					string funcao;

					vector<string> result2;
					boost::split(result2, result[0], boost::is_any_of(" "));

					temp = result2[0];
					funcao = result2[2];				

					string tipo_func = func_tipos[funcao];
					string tipo_temp;

					while(!dlcs.empty())
					{
						string str = dlcs.front();

						if(str.find(temp) != -1)
						{
							vector<string> result;
							boost::split(result, str, boost::is_any_of(" "));

							tipo_temp = result[0];
							break;
						}

						dlcs.pop();
					}

					if(tipo_temp != tipo_func)
					{
						string label = gentempcode();
						string label2 = gentempcode();
						func_dec[it.first].push(tipo_temp + " " + label + ";");
						func_dec[it.first].push(tipo_func + " " + label2 + ";");
						
						new_cmds.push(label2 + " = " + funcao + "(" + result[result.size()-1]);
						new_cmds.push(label + " = (" + tipo_temp + ")" + label2 + ";");
						new_cmds.push(temp + " = " + label + ";");
						cmds.pop();
						continue;
					}
				}

			}

			new_cmds.push(str);
			cmds.pop();
		}

		func_op[it.first] = new_cmds;
	}	
}