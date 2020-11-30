%option noyywrap
%{
#define YYSTYPE TreeNode *
#include "./common.h"  //nounput
#include "./main.tab.h"  // yacc header
int lineno=1;
%}
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

INTEGER [0-9]+
NUMBER [0-9]+(\.[0-9]+)?
CHAR \'.?\'
STRING \".+\"
LB "{"
RB "}"
LP "("
RP ")"
EQU "=="
GREATER ">"
LESS "<" 
GEQU ">="
LEQU "<="
NEQU "!="
LOGIC_AND "&&"
LOGIC_OR "||"
LOGIC_NOT "!"
WHILE "while"
IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
IF "if"
ELSE "else"
FOR "for"
ASSIGN "="
T_INT "int"
T_BOOL "bool"
T_CHAR "char"
T_DOUBLE "double"
T_VOID "void"
SEMICOLON ";"
COMMA ","
MAIN "main"
RETURN "return"
PRINTF "printf"
SCANF "scanf"

commentbegin "/*"
commentelement .|\n|\"\*\/\"
commentend "*/"
commentbegin2 "//"|"\|\|"
commentelement2 .
commentend2 \n
%x COMMENT
%x COMMENT2
%%

{commentbegin} {BEGIN COMMENT;}
<COMMENT>{commentelement} {}
<COMMENT>{commentend} {BEGIN INITIAL;}
{commentbegin2} {BEGIN COMMENT2;}
<COMMENT2>{commentelement2} {}
<COMMENT2>{commentend2} {BEGIN INITIAL;}


{IF} {return IF;}
{ELSE} {return ELSE;}
{FOR} {return FOR;}
{ASSIGN} {return ASS;}
{T_INT} {return T_INT;}
{T_BOOL} {return T_BOOL;}
{T_CHAR} {return T_CHAR;}
{T_DOUBLE} {return T_DOUBLE;}
{T_VOID} { return T_VOID;}
{SEMICOLON} {return  SEMICOLON;}
{COMMA} {return COMMA;}
{MAIN} {    
    TreeNode* node = new TreeNode(lineno, NODE_MAIN);
    yylval = node;
    return MAIN;
    }
{RETURN} {    
    TreeNode* node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_RETURN;
    yylval = node;
    return RETURN;
    }
{PRINTF} {
    TreeNode* node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_PRINTF;
    yylval = node;
    return PRINTF;
}
{SCANF} {
    TreeNode* node = new TreeNode(lineno, NODE_STMT);
    node->stype = STMT_SCANF;
    yylval = node;
    return SCANF;
}
{WHILE} {return WHILE;}

{EQU} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_EQU;
    yylval = node;
    return EQU;
    }
{GREATER} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_GREATER;
    yylval = node;
    return GTR;
}
{LESS} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_LESS;
    yylval = node;
    return LSS;
}
{GEQU} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_GEQU;
    yylval = node;
    return GEQ;
}
{LEQU} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_LEQU;
    yylval = node;
    return LEQ;
}
{NEQU} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_NEQU;
    yylval = node;
    return NEQ;
}
{LOGIC_AND} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_LOGIC_AND;
    yylval = node;
    return LOGICAL_AND;
}
{LOGIC_OR} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_LOGIC_OR;
    yylval = node;
    return LOGICAL_OR;
}
{LOGIC_NOT} {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_LOGIC_NOT;
    yylval = node;
    return LOGICAL_NOT;
}


"+" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_PLUS;
    yylval = node;
    return PLUS;
    }
"-" {    
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_MINUS;
    yylval = node;
    return MINUS;
    }
"*" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_MULTI;
    yylval = node;
    return TIMES;
}
"/" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_DIVIDE;
    yylval = node;
    return DIVIDE;
}
"%" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_MOD;
    yylval = node;
    return MOD;
}
"&" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_AND;
    yylval = node;
    return AND;
}
"|" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_OR;
    yylval = node;
    return OR;
}
"~" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_NOT;
    yylval = node;
    return NOT;
}
"++" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_PLUSPLUS;
    yylval = node;
    return PPLUS;
}
"--" {
    TreeNode* node = new TreeNode(lineno, NODE_EXPR);
    node->optype = OP_MINUSMINUS;
    yylval = node;
    return MMINUS;
    
}
"+=" {
    return PLUS_ASSIGN;
}
"-=" {
    return MIN_ASSIGN;
}
"/=" {
    return DIV_ASSIGN;
}
"%=" {
    return MOD_ASSIGN;
}
"*=" {
    return TIM_ASSIGN;
}
{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    // atoi将string类型的数字转化为int类型
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}
{STRING} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_STRING;
    node->str_val = string(yytext);
    yylval = node;
    return STRING;
}
{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->int_val = yytext[1];
    yylval = node;
    return CHAR;
}
{NUMBER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_DOUBLE;
    node->d_val = atof(yytext);
    yylval = node;
    return NUMBER;
}
{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}
{LB}        { return LB; }
{RB}        { return RB; }
{LP}        { return LP; }
{RP}        { return RP; }
{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%