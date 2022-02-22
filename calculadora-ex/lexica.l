%{
#include "yacc.tab.h"
%}

%%

[0-9]+          yylval = atoi(yytext); return INTEIRO;

"+"             return '+';

[ \t]           ; /* ignora espaços e tabs (\t) */

"\n"            return FIM_LINHA;
		
