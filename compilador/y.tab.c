/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "sintatica.y" /* yacc.c:339  */

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


#line 129 "y.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TK_MAIN = 258,
    TK_FUNCTION = 259,
    TK_OPERATOR = 260,
    TK_RELACIONAL = 261,
    TK_RETURN = 262,
    TK_FIM = 263,
    TK_ERROR = 264,
    TK_TIPO = 265,
    TK_ID = 266,
    TK_CIN = 267,
    TK_COUT = 268,
    TK_INT = 269,
    TK_FLOAT = 270,
    TK_CHAR = 271,
    TK_STRING = 272,
    TK_BOOLEANO = 273,
    TK_INT_VALUE = 274,
    TK_FLOAT_VALUE = 275,
    TK_CHAR_VALUE = 276,
    TK_STRING_VALUE = 277,
    TK_BOOLEANO_VALUE = 278,
    TK_NEGACAO = 279,
    TK_OR = 280,
    TK_AND = 281,
    TK_FOR = 282,
    TK_WHILE = 283,
    TK_IF = 284,
    TK_ELSE = 285,
    TK_DO = 286,
    TK_SWITCH = 287,
    TK_CASE = 288,
    TK_BREAK = 289,
    TK_CONTINUE = 290,
    TK_UNARIO = 291,
    TK_COMPOSTO = 292
  };
#endif
/* Tokens.  */
#define TK_MAIN 258
#define TK_FUNCTION 259
#define TK_OPERATOR 260
#define TK_RELACIONAL 261
#define TK_RETURN 262
#define TK_FIM 263
#define TK_ERROR 264
#define TK_TIPO 265
#define TK_ID 266
#define TK_CIN 267
#define TK_COUT 268
#define TK_INT 269
#define TK_FLOAT 270
#define TK_CHAR 271
#define TK_STRING 272
#define TK_BOOLEANO 273
#define TK_INT_VALUE 274
#define TK_FLOAT_VALUE 275
#define TK_CHAR_VALUE 276
#define TK_STRING_VALUE 277
#define TK_BOOLEANO_VALUE 278
#define TK_NEGACAO 279
#define TK_OR 280
#define TK_AND 281
#define TK_FOR 282
#define TK_WHILE 283
#define TK_IF 284
#define TK_ELSE 285
#define TK_DO 286
#define TK_SWITCH 287
#define TK_CASE 288
#define TK_BREAK 289
#define TK_CONTINUE 290
#define TK_UNARIO 291
#define TK_COMPOSTO 292

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 254 "y.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  48
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   276

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  51
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  9
/* YYNRULES -- Number of rules.  */
#define YYNRULES  55
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  126

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   292

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      43,    44,    40,    38,    42,    39,     2,    41,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    45,
       2,    48,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    46,     2,    47,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    49,     2,    50,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   115,   115,   214,   218,   227,   232,   237,   238,   239,
     241,   245,   247,   253,   263,   286,   293,   313,   347,   377,
     436,   450,   454,   488,   515,   544,   564,   570,   582,   592,
     605,   634,   645,   656,   672,   724,   728,   732,   740,   776,
     809,   826,   859,   863,   873,   886,   899,   912,   922,   932,
     948,   957,   966,   976,   985,  1000
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TK_MAIN", "TK_FUNCTION", "TK_OPERATOR",
  "TK_RELACIONAL", "TK_RETURN", "TK_FIM", "TK_ERROR", "TK_TIPO", "TK_ID",
  "TK_CIN", "TK_COUT", "TK_INT", "TK_FLOAT", "TK_CHAR", "TK_STRING",
  "TK_BOOLEANO", "TK_INT_VALUE", "TK_FLOAT_VALUE", "TK_CHAR_VALUE",
  "TK_STRING_VALUE", "TK_BOOLEANO_VALUE", "TK_NEGACAO", "TK_OR", "TK_AND",
  "TK_FOR", "TK_WHILE", "TK_IF", "TK_ELSE", "TK_DO", "TK_SWITCH",
  "TK_CASE", "TK_BREAK", "TK_CONTINUE", "TK_UNARIO", "TK_COMPOSTO", "'+'",
  "'-'", "'*'", "'/'", "','", "'('", "')'", "';'", "'['", "']'", "'='",
  "'{'", "'}'", "$accept", "S", "PARAMS", "TESTE", "COMANDOS",
  "CONDICINAIS", "LOOPS", "COMANDO", "E", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,    43,    45,
      42,    47,    44,    40,    41,    59,    91,    93,    61,   123,
     125
};
# endif

#define YYPACT_NINF -52

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-52)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      41,     9,   233,   -52,    -1,    55,   -34,   -21,   -20,   -15,
     -52,    75,   -14,   233,   -52,   -52,   -52,   -52,    40,   -52,
      41,    41,    41,    75,     3,    10,    -3,   -52,   -52,   -52,
     -52,   -52,   233,   233,    -6,   170,   -12,   233,   202,    58,
     208,   233,    75,   233,   233,    61,   233,   170,   -52,   -52,
     -52,   -52,   -52,   202,   202,    78,   170,   174,    49,    89,
     233,   233,   233,   233,   233,   233,   233,    80,   233,   170,
      93,    23,   170,    53,   -22,    65,   170,   106,    66,   117,
     128,    92,   145,    36,    52,    70,   233,   -52,   170,   170,
       2,   174,   174,     0,     0,    90,   170,   -52,   202,   -52,
      88,   202,    94,   -52,   233,   -52,   -52,   233,   -52,   -52,
     -52,   -52,   170,   -52,    97,   233,    74,   -52,    81,   153,
     170,   -52,    75,   -52,    96,   -52
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
      10,     0,     0,    35,     0,     0,     0,     0,     0,     0,
      14,    12,     0,     0,    31,    32,    33,    34,     0,     2,
      10,    10,    10,    12,     0,     0,    55,    50,    51,    53,
      54,    52,     0,     0,     0,    29,    22,     0,     6,     0,
       0,     0,     0,     0,     0,     0,     0,    16,     1,     7,
       8,     9,    11,     6,     6,     0,    44,    43,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    30,
       0,     0,     5,     0,    55,     0,    25,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    42,    47,    46,
      45,    38,    39,    41,    40,     0,    24,     4,     6,    28,
       0,     6,     0,    36,     0,    18,    13,     0,    15,    21,
      20,    49,    48,    23,     3,     0,     0,    37,     0,     0,
      26,    27,     0,    17,     0,    19
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -52,   -52,   -51,    35,    -4,   -52,   -52,   -41,    -2
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,    18,    71,    19,    20,    21,    22,    23,    72
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      35,    78,    83,    84,    58,    26,    60,    45,    60,    41,
      36,    47,    24,    27,    28,    29,    30,    31,    32,    52,
      25,   101,    42,    43,    55,    61,    62,    61,    44,    46,
      56,    57,    59,    33,    67,    69,    68,    34,    76,    77,
      48,    79,    80,    55,    82,     1,    53,   114,     2,     3,
     116,     4,     5,    54,     6,    49,    50,    51,    88,    89,
      90,    91,    92,    93,    94,    98,    96,    99,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    73,    98,     1,
     109,   124,     2,     3,   112,     4,     5,    60,     6,    81,
      16,    17,    37,    86,    98,    60,   110,    85,    38,    95,
     100,    39,   118,    40,    97,   119,    61,    62,   102,    14,
      15,   104,    60,   120,    61,    62,    98,   111,   121,    63,
      64,    65,    66,    60,    16,    17,   122,    63,    64,    65,
      66,    61,    62,    87,    60,   107,   115,   113,   117,    98,
     125,     0,    61,    62,    63,    64,    65,    66,     0,     0,
     103,    60,     0,    61,    62,    63,    64,    65,    66,    60,
       0,   105,     0,     0,     0,     0,    63,    64,    65,    66,
      61,    62,   106,     0,     0,     0,    60,     0,    61,    62,
      60,     0,     0,    63,    64,    65,    66,     0,     0,   108,
       0,    63,    64,    65,    66,    61,    62,   123,     0,    61,
      62,     0,     0,     0,     0,     0,     0,     0,    63,    64,
      65,    66,    70,    26,    65,    66,     0,     0,     0,    74,
      75,    27,    28,    29,    30,    31,    32,    27,    28,    29,
      30,    31,    32,     0,     0,     0,     0,     0,     0,     0,
       0,    33,     0,     0,    26,    34,     0,    33,     0,     0,
       0,    34,    27,    28,    29,    30,    31,    32,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    33,     0,     0,     0,    34
};

static const yytype_int8 yycheck[] =
{
       2,    42,    53,    54,    10,    11,     6,    11,     6,    43,
      11,    13,     3,    19,    20,    21,    22,    23,    24,    23,
      11,    43,    43,    43,    46,    25,    26,    25,    43,    43,
      32,    33,    34,    39,    46,    37,    48,    43,    40,    41,
       0,    43,    44,    46,    46,     4,    43,    98,     7,     8,
     101,    10,    11,    43,    13,    20,    21,    22,    60,    61,
      62,    63,    64,    65,    66,    42,    68,    44,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    19,    42,     4,
      44,   122,     7,     8,    86,    10,    11,     6,    13,    28,
      49,    50,    37,    44,    42,     6,    44,    19,    43,    19,
      47,    46,   104,    48,    11,   107,    25,    26,    43,    34,
      35,    45,     6,   115,    25,    26,    42,    47,    44,    38,
      39,    40,    41,     6,    49,    50,    45,    38,    39,    40,
      41,    25,    26,    44,     6,    43,    48,    47,    44,    42,
      44,    -1,    25,    26,    38,    39,    40,    41,    -1,    -1,
      44,     6,    -1,    25,    26,    38,    39,    40,    41,     6,
      -1,    44,    -1,    -1,    -1,    -1,    38,    39,    40,    41,
      25,    26,    44,    -1,    -1,    -1,     6,    -1,    25,    26,
       6,    -1,    -1,    38,    39,    40,    41,    -1,    -1,    44,
      -1,    38,    39,    40,    41,    25,    26,    44,    -1,    25,
      26,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    38,    39,
      40,    41,    10,    11,    40,    41,    -1,    -1,    -1,    11,
      12,    19,    20,    21,    22,    23,    24,    19,    20,    21,
      22,    23,    24,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    39,    -1,    -1,    11,    43,    -1,    39,    -1,    -1,
      -1,    43,    19,    20,    21,    22,    23,    24,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    39,    -1,    -1,    -1,    43
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     4,     7,     8,    10,    11,    13,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    49,    50,    52,    54,
      55,    56,    57,    58,     3,    11,    11,    19,    20,    21,
      22,    23,    24,    39,    43,    59,    11,    37,    43,    46,
      48,    43,    43,    43,    43,    55,    43,    59,     0,    54,
      54,    54,    55,    43,    43,    46,    59,    59,    10,    59,
       6,    25,    26,    38,    39,    40,    41,    46,    48,    59,
      10,    53,    59,    19,    11,    12,    59,    59,    58,    59,
      59,    28,    59,    53,    53,    19,    44,    44,    59,    59,
      59,    59,    59,    59,    59,    19,    59,    11,    42,    44,
      47,    43,    43,    44,    45,    44,    44,    43,    44,    44,
      44,    47,    59,    47,    53,    48,    53,    44,    59,    59,
      59,    44,    45,    44,    58,    44
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    51,    52,    53,    53,    53,    53,    54,    54,    54,
      54,    55,    55,    56,    56,    56,    56,    57,    57,    57,
      58,    58,    58,    58,    58,    58,    58,    58,    58,    58,
      58,    58,    58,    58,    58,    58,    58,    58,    59,    59,
      59,    59,    59,    59,    59,    59,    59,    59,    59,    59,
      59,    59,    59,    59,    59,    59
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     3,     2,     1,     0,     2,     2,     2,
       0,     2,     0,     4,     1,     4,     2,     6,     4,     8,
       5,     5,     2,     5,     4,     3,     6,     6,     4,     2,
       3,     1,     1,     1,     1,     1,     4,     5,     3,     3,
       3,     3,     3,     2,     2,     3,     3,     3,     4,     4,
       1,     1,     1,     1,     1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 116 "sintatica.y" /* yacc.c:1646  */
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
#line 1536 "y.tab.c" /* yacc.c:1646  */
    break;

  case 3:
#line 215 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).traducao = (yyvsp[-2]).traducao + ',' + (yyvsp[0]).traducao;
			}
#line 1544 "y.tab.c" /* yacc.c:1646  */
    break;

  case 4:
#line 219 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();		
				
				inserir_id((yyvsp[0]).label,(yyval).label,count_block);
				inserir_tipo((yyval).label,(yyvsp[-1]).label, count_block);

				(yyval).traducao = (yyvsp[-1]).label + " " + (yyval).label;
			}
#line 1557 "y.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 228 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).traducao = (yyvsp[0]).label;
			}
#line 1565 "y.tab.c" /* yacc.c:1646  */
    break;

  case 6:
#line 232 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).traducao = "";
			}
#line 1573 "y.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 241 "sintatica.y" /* yacc.c:1646  */
    {
			}
#line 1580 "y.tab.c" /* yacc.c:1646  */
    break;

  case 12:
#line 247 "sintatica.y" /* yacc.c:1646  */
    {
				
				(yyval).traducao = "";
			}
#line 1589 "y.tab.c" /* yacc.c:1646  */
    break;

  case 13:
#line 254 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();
				string label = gentemplabel();
				loop_stack.push_back("label " + label);

				declaracoes[count_block].push("int " + (yyval).label + ";");
				comandos[count_block].push((yyval).label + " = !" + (yyvsp[-1]).label + ";");
				comandos[count_block].push("if(" + (yyval).label + ") goto " + label + ";");
			}
#line 1603 "y.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 264 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();	
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
#line 1630 "y.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 287 "sintatica.y" /* yacc.c:1646  */
    {
				string label = gentemplabel();
				switch_value = (yyvsp[-1]).label;
				loop_stack.push_back("label " + label);
				loop_ends.push_back(label);
			}
#line 1641 "y.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 294 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();

				if(switch_value == "" )
					yyerror("Nenhum switch foi iniciado!");

				declaracoes[count_block].push("int " + (yyval).label + ";");
				comandos[count_block].push((yyval).label + " = " + "(" + switch_value + " == " + (yyvsp[0]).label + ")" );

				string label_aux = gentempcode();
				declaracoes[count_block].push("int " + label_aux + ";");				
				comandos[count_block].push(label_aux + " = !" + (yyval).label);

				string label = gentemplabel();
				comandos[count_block].push("if(" + label_aux + ")" + "goto " + label + ";");
				loop_stack.push_back("label " + label);
			}
#line 1663 "y.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 314 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();				
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

				declaracoes[count_block].push("bool " + (yyval).label + ";");
				comandos[count_block].push((yyval).label + " = " + (yyvsp[-1]).label + ";");
				comandos[count_block].push("if(" + (yyval).label + ") goto " + label_ini + ";");
				comandos[count_block].push("label " + label_fim + ";");
			}
#line 1701 "y.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 348 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();				
				string label_ini = gentemplabel();
				string label_fim = gentemplabel();
				std::queue< string > aux_queue;

				while(!comandos[count_block].empty())
				{
					string str = comandos[count_block].front();

					if( str.find((yyvsp[-1]).label) != -1 )
					{
						aux_queue.push("label " + label_ini );
					}

					aux_queue.push(str);
					comandos[count_block].pop();
				}

				comandos[count_block] = aux_queue;

				declaracoes[count_block].push("bool " + (yyval).label + ";");
				comandos[count_block].push((yyval).label + " = !" + (yyvsp[-1]).label + ";");
				comandos[count_block].push("if(" + (yyval).label + ") goto " + label_fim + ";");

				loop_stack.push_back( "goto " + label_ini + ";" + "label " + label_fim);
				loop_ends.push_back(label_fim);
				loop_starts.push_back(label_ini);
			}
#line 1735 "y.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 378 "sintatica.y" /* yacc.c:1646  */
    {	
				if((yyvsp[-3]).tipo != "bool")
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

					if( str.find((yyvsp[-5]).label + " = ") != -1  && check == True)
					{
						aux_queue.push(str);					
						aux_queue.push(label_ini + ":" );

						comandos[count_block].pop();
						
						check = False;
						continue;
					}

					else if( str.find((yyvsp[-1]).label) != -1 )
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
				
				comandos[count_block].push(temp + " = " + "!" + (yyvsp[-3]).label + ";");								
				comandos[count_block].push("if(" + temp + ") goto " + label_fim + ";" );			
				
				loop_stack.push_back( cmd + "goto " + label_ini + ";" + label_fim);				
				loop_ends.push_back(label_fim);
			}
#line 1796 "y.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 437 "sintatica.y" /* yacc.c:1646  */
    {
				std::queue <string> aux;
				std::queue <string> aux2;

				func_dec[(yyvsp[-3]).label] = aux;
				func_op[(yyvsp[-3]).label] = aux2;

				func_dec[(yyvsp[-3]).label].push("\nvoid " + (yyvsp[-3]).label + "(" + (yyvsp[-1]).traducao +  ")");

				current_func = (yyvsp[-3]).label;

				func_tipos[current_func] = "void";
			}
#line 1814 "y.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 451 "sintatica.y" /* yacc.c:1646  */
    {
				is_main = True;
			}
#line 1822 "y.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 455 "sintatica.y" /* yacc.c:1646  */
    {
				std::map<string,string>::iterator it;
				
				it = hashs_id[count_block].find((yyvsp[0]).label);
				if( it != hashs_id[count_block].end()) 
					yyerror("ERROR - Variaveis com mesmo ID declaradas!");					

				(yyval).label = gentempcode();		
				
				inserir_id((yyvsp[0]).label,(yyval).label,count_block);
				inserir_tipo((yyval).label,(yyvsp[-1]).label, count_block);						

				if((yyvsp[-1]).label == "int")
					comandos[count_block].push((yyval).label + " = " + "0;");

				else if((yyvsp[-1]).label == "float")
					comandos[count_block].push((yyval).label + " = " + "0.0;");

				else if((yyvsp[-1]).label == "char")
					comandos[count_block].push((yyval).label + " = " + "'';");

				else if((yyvsp[-1]).label == "string")
				{
					(yyvsp[-1]).label = "char*";
				}
				else if((yyvsp[-1]).label == "bool")
				{					
					comandos[count_block].push((yyval).label + " = " + "False ;");
					(yyvsp[-1]).label = "int";
				}			

				declaracoes[count_block].push((yyvsp[-1]).label + " " + (yyval).label + "; //" + (yyvsp[0]).label);
			}
#line 1860 "y.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 489 "sintatica.y" /* yacc.c:1646  */
    {
				std::map<string,string>::iterator it;
				
				it = hashs_id[count_block].find((yyvsp[-3]).label);
				if( it != hashs_id[count_block].end()) 
					yyerror("ERROR - Variaveis com mesmo ID declaradas!");					

				(yyval).label = gentempcode();		
				
				inserir_id((yyvsp[-3]).label,(yyval).label,count_block);
				inserir_tipo((yyval).label,(yyvsp[-4]).label, count_block);

				int tamanho = stoi((yyvsp[-1]).traducao);

				declaracoes[count_block].push((yyvsp[-4]).label + " " + (yyval).label + "[" + (yyvsp[-1]).traducao + "]" + ";");

				string inicial_val;

				if ((yyvsp[-4]).label == "int")
					inicial_val = "0"; 

				for(int i = 0; i < tamanho; i++)
				{
					comandos[count_block].push((yyval).label + "[" + to_string(i) + "] = " + inicial_val + ";");
				}
			}
#line 1891 "y.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 516 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();
				inserir_id((yyvsp[-2]).label, (yyval).label, count_block);
				inserir_tipo((yyval).label, (yyvsp[-3]).label, count_block);

				string temporaria = (yyval).label;
				string tipo = (yyvsp[-3]).label;

				string tipo_exp = hashs_tipo[count_block][(yyvsp[0]).label];
				string conversao = "";				

				if(tipo == "int" && tipo_exp == "float")
					conversao += "(int)";

				else if(tipo == "float" && tipo_exp == "int")
					conversao += "(float)";
				
				else if(tipo == "bool" && tipo_exp != "bool")
					conversao += "(int)";	
				
				else if((yyvsp[-3]).label == "string")
				{
					(yyvsp[-3]).label = "char*";
				}

				declaracoes[count_block].push((yyvsp[-3]).label + " " + (yyval).label + "; //" + (yyvsp[-2]).label + "\n");					
				comandos[count_block].push((yyval).label + " = " + conversao + (yyvsp[0]).label + ";\n");
			}
#line 1924 "y.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 545 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = (yyvsp[0]).label;
				string temporaria = temp_id((yyvsp[-2]).label);
				string tipo = hashs_tipo[count_block][temporaria];
				
				string conversao = "";				
				string tipo_exp = hashs_tipo[count_block][(yyvsp[0]).label];

				if(tipo == "int" && tipo_exp == "float")
					conversao += "(int)";

				else if(tipo == "float" && tipo_exp == "int")
					conversao += "(float)";
				
				else if(tipo == "bool" && tipo_exp != "bool")
					conversao += "(int)";

				comandos[count_block].push(temporaria + " = " + conversao + (yyvsp[0]).label + ";");
			}
#line 1948 "y.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 565 "sintatica.y" /* yacc.c:1646  */
    {
				string temp = temp_id((yyvsp[-5]).label);

				comandos[count_block].push(temp + "[" + (yyvsp[-3]).traducao + "] = " + (yyvsp[0]).label + ";");
			}
#line 1958 "y.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 571 "sintatica.y" /* yacc.c:1646  */
    {
				string temp = temp_id((yyvsp[-5]).label);

				std::map<string,std::queue<string>>::iterator it;
				
				it = func_dec.find((yyvsp[-3]).label);
				if( it == func_dec.end())					
					comandos[count_block].push("funcao " + (yyvsp[-3]).label);		

				comandos[count_block].push(temp + " = " + (yyvsp[-3]).label + "(" + (yyvsp[-1]).traducao + ");" );
			}
#line 1974 "y.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 583 "sintatica.y" /* yacc.c:1646  */
    {
				std::map<string,std::queue<string>>::iterator it;
				
				it = func_dec.find((yyvsp[-3]).label);
				if( it == func_dec.end()) 
					comandos[count_block].push("funcao " + (yyvsp[-3]).label);							

				comandos[count_block].push((yyvsp[-3]).label + "(" + (yyvsp[-1]).traducao + ");" );
			}
#line 1988 "y.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 593 "sintatica.y" /* yacc.c:1646  */
    {
				string temp = (yyvsp[0]).label;
				string tipo = tipo_id(temp);

				if(!is_main)
				{
					func_dec[current_func].front().replace(0,5,tipo);
					func_tipos[current_func] = tipo;
				}

				comandos[count_block].push("return " + temp + ";");
			}
#line 2005 "y.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 606 "sintatica.y" /* yacc.c:1646  */
    {
				string temp = temp_id((yyvsp[-2]).label);
				string op = (yyvsp[-1]).label;
				
				(yyval).label = gentempcode();
				declaracoes[count_block].push("int " + (yyval).label + ";");
				
				if( op == "+=")
				{
					comandos[count_block].push((yyval).label + " = " + temp + " + " + (yyvsp[0]).label + ";");
					comandos[count_block].push(temp + " = " + (yyval).label + ";");					
				}
				else if(op == "-=")
				{
					comandos[count_block].push((yyval).label + " = " + temp + " - " + (yyvsp[0]).label + ";");
					comandos[count_block].push(temp + " = " + (yyval).label + ";");	
				}
				else if(op == "*=")
				{
					comandos[count_block].push((yyval).label + " = " + temp + " * " + (yyvsp[0]).label + ";");
					comandos[count_block].push(temp + " = " + (yyval).label + ";");	
				}
				else if(op == "/=")
				{
					comandos[count_block].push((yyval).label + " = " + temp + " / " + (yyvsp[0]).label + ";");
					comandos[count_block].push(temp + " = " + (yyval).label + ";");	
				}
			}
#line 2038 "y.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 635 "sintatica.y" /* yacc.c:1646  */
    {
				if(loop_ends.empty())
					comandos[count_block].push("break");

				else
				{
					string str = loop_ends.back();
					comandos[count_block].push("goto " + str + ";");
				}
			}
#line 2053 "y.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 646 "sintatica.y" /* yacc.c:1646  */
    {
				if(loop_starts.empty())
					comandos[count_block].push("continue");
				
				else
				{
					string str = loop_starts.back();
					comandos[count_block].push("goto " + str + ";");
				}				
			}
#line 2068 "y.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 657 "sintatica.y" /* yacc.c:1646  */
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
#line 2088 "y.tab.c" /* yacc.c:1646  */
    break;

  case 34:
#line 673 "sintatica.y" /* yacc.c:1646  */
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
#line 2144 "y.tab.c" /* yacc.c:1646  */
    break;

  case 35:
#line 725 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).traducao = "";
			}
#line 2152 "y.tab.c" /* yacc.c:1646  */
    break;

  case 36:
#line 729 "sintatica.y" /* yacc.c:1646  */
    {
				comandos[count_block].push("cout << " + (yyvsp[-1]).label + " << endl;");
			}
#line 2160 "y.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 733 "sintatica.y" /* yacc.c:1646  */
    {
				string temp = temp_id((yyvsp[-4]).label);				
			
				comandos[count_block].push("cin >> " + temp + ";");				
			}
#line 2170 "y.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 741 "sintatica.y" /* yacc.c:1646  */
    {
				string tipoExp1 = hashs_tipo[count_block][(yyvsp[-2]).label];
				string tipoExp2 = hashs_tipo[count_block][(yyvsp[0]).label];

				(yyval).tipo = "int";				

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + (yyvsp[-2]).label + ";");

					(yyvsp[-2]).label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + (yyvsp[0]).label + ";");

					(yyvsp[0]).label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if (tipoExp1 == "float" && tipoExp2 == "float" ){					
					(yyval).tipo = "float";
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");		

				(yyval).label = gentempcode();

				inserir_tipo((yyval).label,(yyval).tipo, count_block);		

				declaracoes[count_block].push((yyval).tipo + " " + (yyval).label + ";");			
				comandos[count_block].push((yyval).label +	" = " + (yyvsp[-2]).label + " + " + (yyvsp[0]).label + ";");				
			}
#line 2210 "y.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 777 "sintatica.y" /* yacc.c:1646  */
    {
				string tipoExp1 = hashs_tipo[count_block][(yyvsp[-2]).label];
				string tipoExp2 = hashs_tipo[count_block][(yyvsp[0]).label];

				(yyval).tipo = "int";

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + (yyvsp[-2]).label + ";");

					(yyvsp[-2]).label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + (yyvsp[0]).label + ";");

					(yyvsp[0]).label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");

				(yyval).label = gentempcode();

				inserir_tipo((yyval).label,(yyval).tipo, count_block);
				
				declaracoes[count_block].push((yyval).tipo + " " + (yyval).label + ";");
				comandos[count_block].push((yyval).label +	" = " + (yyvsp[-2]).label + " - " + (yyvsp[0]).label + ";");
			}
#line 2247 "y.tab.c" /* yacc.c:1646  */
    break;

  case 40:
#line 810 "sintatica.y" /* yacc.c:1646  */
    {
				string tipoExp1 = hashs_tipo[count_block][(yyvsp[-2]).label];
				string tipoExp2 = hashs_tipo[count_block][(yyvsp[0]).label];

				(yyval).tipo = "float";

				if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");

				(yyval).label = gentempcode();

				inserir_tipo((yyval).label,(yyval).tipo,count_block);
				
				declaracoes[count_block].push((yyval).tipo + " " + (yyval).label + ";");
				comandos[count_block].push((yyval).label +	" = " + (yyvsp[-2]).label + " / " + (yyvsp[0]).label + ";");	
			}
#line 2268 "y.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 827 "sintatica.y" /* yacc.c:1646  */
    {
				string tipoExp1 = hashs_tipo[count_block][(yyvsp[-2]).label];
				string tipoExp2 = hashs_tipo[count_block][(yyvsp[0]).label];

				(yyval).tipo = "int";

				if ( tipoExp1 == "int" && tipoExp2 == "float" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + (yyvsp[-2]).label + ";");

					(yyvsp[-2]).label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if (tipoExp1 == "float" && tipoExp2 == "int" ){
					string temp_aux = gentempcode();
					declaracoes[count_block].push("float " + temp_aux + ";");
					comandos[count_block].push( temp_aux + " = " + "(float)" + (yyvsp[0]).label + ";");

					(yyvsp[0]).label = temp_aux;					
					inserir_tipo(temp_aux,"float",count_block);
				}
				else if(tipoExp1 == "char" || tipoExp2 == "char")
					yyerror("Operacao invalida!");

				(yyval).label = gentempcode();	

				inserir_tipo((yyval).label,(yyval).tipo,count_block);
				
				declaracoes[count_block].push((yyval).tipo + " " + (yyval).label + ";");
				comandos[count_block].push((yyval).label +	" = " + (yyvsp[-2]).label + " * " + (yyvsp[0]).label + ";");
			}
#line 2305 "y.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 860 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = (yyvsp[-1]).label;
			}
#line 2313 "y.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 864 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();
				string aux = gentempcode();

				declaracoes[count_block].push("int " + aux + ";");

				comandos[count_block].push(aux + " = " + "-1;");
				comandos[count_block].push((yyval).label + " = " + (yyvsp[0]).label + " * " + aux + ";");
			}
#line 2327 "y.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 874 "sintatica.y" /* yacc.c:1646  */
    {	
				(yyval).label = gentempcode();
				(yyval).tipo = "bool";

				if((yyvsp[0]).tipo != "bool")
					yyerror("Operacao invalida!");							

				inserir_tipo((yyval).label,(yyval).tipo, count_block);

				declaracoes[count_block].push((yyval).tipo + " " + (yyval).label + ";");
				comandos[count_block].push((yyval).label +	" = " + "!" + (yyvsp[0]).label + ";");		
			}
#line 2344 "y.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 887 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();
				(yyval).tipo = "bool";

				if((yyvsp[-2]).tipo != "bool" || (yyvsp[0]).tipo != "bool")
					yyerror("Operacao invalida!");					

				inserir_tipo((yyval).label,(yyval).tipo, count_block);

				declaracoes[count_block].push((yyval).tipo + " " + (yyval).label + ";");
				comandos[count_block].push((yyval).label +	" = " + (yyvsp[-2]).label + " && " + (yyvsp[0]).label + ";");
			}
#line 2361 "y.tab.c" /* yacc.c:1646  */
    break;

  case 46:
#line 900 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();
				(yyval).tipo = "bool";

				if((yyvsp[-2]).tipo != "bool" || (yyvsp[0]).tipo != "bool")
					yyerror("Operacao invalida!");			

				inserir_tipo((yyval).label,(yyval).tipo, count_block);

				declaracoes[count_block].push((yyval).tipo + " " + (yyval).label + ";");
				comandos[count_block].push((yyval).label +	" = " + (yyvsp[-2]).label + " || " + (yyvsp[0]).label + ";");	
			}
#line 2378 "y.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 913 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();
				(yyval).tipo = "bool";			
				
				inserir_tipo((yyval).label,(yyval).tipo, count_block);

				declaracoes[count_block].push("int " + (yyval).label + ";");
				comandos[count_block].push((yyval).label + " = " + (yyvsp[-2]).label + " " + (yyvsp[-1]).label + " " + (yyvsp[0]).label + ";");
			}
#line 2392 "y.tab.c" /* yacc.c:1646  */
    break;

  case 48:
#line 923 "sintatica.y" /* yacc.c:1646  */
    {				
				(yyval).label = gentempcode();
				(yyval).tipo = (yyvsp[-2]).label;

				inserir_tipo((yyval).label,(yyval).tipo, count_block);

				declaracoes[count_block].push((yyvsp[-2]).label + " " + (yyval).label + ";");
				comandos[count_block].push((yyval).label + " = (" + (yyvsp[-2]).label + ")" + (yyvsp[0]).label);
			}
#line 2406 "y.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 933 "sintatica.y" /* yacc.c:1646  */
    {
				string tem_index = gentempcode();
				
				string temp = temp_id((yyvsp[-3]).label);
				string tipo = hashs_tipo[count_block][temp];

				declaracoes[count_block].push("int " + tem_index + "; #" + (yyvsp[-1]).traducao);
				comandos[count_block].push(tem_index + " = " + (yyvsp[-1]).traducao + ";");

				inserir_tipo((yyval).label,"int",count_block);

				(yyval).label = gentempcode();
				declaracoes[count_block].push(tipo + (yyval).label + ";");
				comandos[count_block].push((yyval).label + " = " + temp + "[" + tem_index + "];");
			}
#line 2426 "y.tab.c" /* yacc.c:1646  */
    break;

  case 50:
#line 949 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();
				
				declaracoes[count_block].push("int " + (yyval).label + "; //" + (yyvsp[0]).traducao);
				comandos[count_block].push((yyval).label + " = " + (yyvsp[0]).traducao + ";");

				inserir_tipo((yyval).label,"int",count_block);
			}
#line 2439 "y.tab.c" /* yacc.c:1646  */
    break;

  case 51:
#line 958 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();

				declaracoes[count_block].push("float " + (yyval).label + "; //" + (yyvsp[0]).traducao);
				comandos[count_block].push((yyval).label + " = " + (yyvsp[0]).traducao + ";");

				inserir_tipo((yyval).label,"float",count_block);
			}
#line 2452 "y.tab.c" /* yacc.c:1646  */
    break;

  case 52:
#line 967 "sintatica.y" /* yacc.c:1646  */
    {				
				(yyval).label = gentempcode();
				(yyval).tipo = "bool";

				declaracoes[count_block].push("int " + (yyval).label + "; //" + (yyvsp[0]).traducao);
				comandos[count_block].push((yyval).label + " = " + (yyvsp[0]).traducao + ";");

				inserir_tipo((yyval).label,"bool",count_block);
			}
#line 2466 "y.tab.c" /* yacc.c:1646  */
    break;

  case 53:
#line 977 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();				

				declaracoes[count_block].push("char " + (yyval).label + "; //" + (yyvsp[0]).traducao);
				comandos[count_block].push((yyval).label + " = " + (yyvsp[0]).traducao + ";");

				inserir_tipo((yyval).label,"char",count_block);
			}
#line 2479 "y.tab.c" /* yacc.c:1646  */
    break;

  case 54:
#line 986 "sintatica.y" /* yacc.c:1646  */
    {
				(yyval).label = gentempcode();
				int len = (yyvsp[0]).traducao.size() + 1;

				declaracoes[count_block].push("char " + (yyval).label + "[" + to_string(len-2) + "]" + "; //" + (yyvsp[0]).traducao);

				inserir_tipo((yyval).label, "string", count_block);

				for (size_t i = 1; i < (yyvsp[0]).traducao.size()-1; i++)
				{
					string str = (yyval).label + "[" + to_string(i-1) + "] = '" + (yyvsp[0]).traducao[i] + "';";
					comandos[count_block].push(str);
				}     
			}
#line 2498 "y.tab.c" /* yacc.c:1646  */
    break;

  case 55:
#line 1001 "sintatica.y" /* yacc.c:1646  */
    {
				std::map<string,string>::iterator it;
				string temporaria = temp_id((yyvsp[0]).label);

				(yyval).label = temporaria;
			}
#line 2509 "y.tab.c" /* yacc.c:1646  */
    break;


#line 2513 "y.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 1009 "sintatica.y" /* yacc.c:1906  */


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
			cout << str << endl;

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
