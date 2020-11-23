%option noyywrap
%top{
	#include<map>
	#include<fstream>
	#include<string.h>
	#include<iostream>
	#include <iomanip>
	using std::map;	
	std::ifstream input("./testin");
	using std::cout;
}
%{
	map<std::string,int> mapkeyword;
	map<std::string,int> mapid;
	int i=0,j=0;
%}

KEYWORD "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"
DIGIT [0-9]
LETTER [a-zA-Z]
ID ({LETTER}|_)({LETTER}|_|{DIGIT})*
NUMBER [1-9]{DIGIT}*|0
OPT "+="|"-="|"*="|"/="|"+"|"-"|"*"|"/"|"<="|">="|"=="|"="|"<"|">"
LEFTPAREN "("
RIGHTPAREN  ")" 
LEFTBRACKET "["
RIGHTBRACKET "]"
LEFTBRACE "{"
RIGHTBRACE "}"
SEMICOLON ";"
COMMA ","
COLON ":"
SQU "'"
LINES "\n"
SPACE " "
commentbegin "/*"
commentelement .|\n
commentend "*/"
%x COMMENT
%%
{KEYWORD} {
    auto it=mapkeyword.find(yytext);
	if(it!=mapkeyword.end())
	{
		cout<<std::setw(20)<<"KEYWORDS"<<std::setw(20)<<yytext<<std::setw(20)<<it->second<<std::endl;
	}
	else
	{
		mapkeyword[yytext]=i;
		cout<<std::setw(20)<<"KEYWORDS"<<std::setw(20)<<yytext<<std::setw(20)<<i<<std::endl;	
		i++;
	}

	}
{ID} {
	auto iter=mapid.find(yytext);
	if(iter!=mapid.end())
	{
		cout<<std::setw(20)<<"ID"<<std::setw(20)<<yytext<<std::setw(20)<<iter->second<<std::endl;
	}
	else
	{
		mapid[yytext]=j;
		cout<<std::setw(20)<<"ID"<<std::setw(20)<<yytext<<std::setw(20)<<j<<std::endl;
		j++;
	}
}
{LEFTPAREN} {cout<<std::setw(20)<<"LEFTPAREN"<<std::setw(20)<<yytext<<std::endl;}
{RIGHTPAREN} {cout<<std::setw(20)<<"RIGHTPAREN"<<std::setw(20)<<yytext<<std::endl;}
{LEFTBRACKET} {cout<<std::setw(20)<<"LEFTBRACKET"<<std::setw(20)<<yytext<<std::endl;}
{RIGHTBRACKET} {cout<<std::setw(20)<<"RIGHTBRACKET"<<std::setw(20)<<yytext<<std::endl;}
{LEFTBRACE} {cout<<std::setw(20)<<"LEFTBRACE"<<std::setw(20)<<yytext<<std::endl;}
{RIGHTBRACE} {cout<<std::setw(20)<<"RIGHTBRACE"<<std::setw(20)<<yytext<<std::endl;}
{SEMICOLON} {cout<<std::setw(20)<<"SEMICOLON"<<std::setw(20)<<yytext<<std::endl;}
{COMMA}  {cout<<std::setw(20)<<"COMMA"<<std::setw(20)<<yytext<<std::endl;}
{COLON}  {cout<<std::setw(20)<<"COLON"<<std::setw(20)<<yytext<<std::endl;}
{SQU}  {cout<<std::setw(20)<<"SQU"<<std::setw(20)<<yytext<<std::endl;}
{NUMBER} {cout<<std::setw(20)<<"NUMBER"<<std::setw(20)<<yytext<<std::setw(20)<<yytext<<std::endl;}
{OPT} {cout<<std::setw(20)<<"OPT"<<std::setw(20)<<yytext<<std::endl;}
{LINES} {}
{SPACE} {}
{commentbegin} {BEGIN COMMENT;}
<COMMENT>{commentelement} {}
<COMMENT>{commentend} {BEGIN INITIAL;}
%%
int main()
{
	cout<<std::setw(22)<<"单词"<<std::setw(22)<<"词素"<<std::setw(22)<<"属性"<<std::endl;
	yyFlexLexer lexer(&input);
	lexer.yylex();
	return 0;
}

