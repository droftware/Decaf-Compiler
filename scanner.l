/*=========================================================================
								FLEX CODE
						ADHISH SINGLA 201403004
						AAYUSH MAINI  201301012
=========================================================================*/
%option yylineno
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include<iostream>
	#include <vector>
	#include "ASTDefinitions.h"
	#include "parser.tab.h"
	#define YY_DECL extern "C" int yylex()
	char linebuf[500];
	extern FILE *flex_out;
	extern int errors;
	extern union NODE yylval;
	using namespace std;
%}

/*=========================================================================
							TOKEN Definitions
=========================================================================*/

delim			[ \t\n]
ws				{delim}+
alpha			[A-Za-z]
digit			[0-9]
id				{alpha}({alpha}|{digit})*
integer			{digit}+(\.{digit}+)?(E[+-]?{digit}+)?
character 		\'{alpha}\'
str 			(\\n|\\t|\\'|\\\\|\\\"|[^\\"'])
	
/*=========================================================================
	REGULAR EXPRESSIONS defining the tokens for the Simple language
=========================================================================*/

%%
\n.*		{
				strncpy(linebuf, yytext+1, sizeof(linebuf));
				yyless(1);
			}
"class"		{
				fprintf( flex_out,"CLASS\n");
				return CLASS;
			}
"{"			{
				return LCP;
			}
"}"			{
				return RCP;
			}
"("			{
				return LRP;
			}
")"			{
				return RRP;
			}
"["			{
				return LSP;
			}
"]"			{
				return RSP;
			}
";"			{
				return SC;
			}
"!"			{
				return NOT;
			}

"+"			{
				return ADD;
			}
"-"			{
				return SUBTRACT;
			}
"*"			{
				return MULTIPLY;
			}
"/"			{
				return DIVIDE;
			}
"%"			{
				return MOD;
			}
"="			{
				return EQ;
			}
"+="		{
				return ADDEQ;
			}
"-="		{
				return SUBTRACTEQ;
			}

"int"		{
				yylval.string = strdup("INT");
				fprintf( flex_out,"INT_DECLARATION\n");
				return TYPE;
			}
"boolean"	{
				yylval.string = strdup("BOOLEAN");
				fprintf( flex_out,"BOOLEAN_DECLARATION\n");
				return TYPE;
			}
"callout"	{
				fprintf( flex_out,"CALLOUT\n");
				return CALLOUT;
			}

">"			{
				return GT;
			}
"<"			{
				return LT;
			}
">=" 		{
				return GE;
			}
"<="		{
				return LE;
			}

"&&"		{
				return ANDAND;
			}
"||"		{
				return OROR;
			}

"=="		{
				return EQEQ;
			}
"!="		{
				return NOTEQ;
			}

true|false	{
				yylval.string = strdup(yytext);
				fprintf( flex_out,"BOOLEAN: %s\n", yytext);
				return BOOLEAN;
			}

{delim}		{
				;
			}
","			{
				return COMMA;
			}
{id}		{
				yylval.string = strdup(yytext);
				fprintf( flex_out,"ID: %s\n", yytext);
				return ID;
			}
{integer}	{
				yylval.number = atoi(yytext);
				fprintf( flex_out,"INT: %s\n", yytext);
				return INT;
			}
{character}	{
				yylval.string = strdup(yytext);
				fprintf( flex_out,"CHARACTER: %s\n", yytext);
				return CHARACTER;
			}

\"{str}*\"	{
				yylval.string = strdup(yytext);
				fprintf( flex_out,"STRING: %s\n", yytext);
				return STRING;
			}

.			{
				errors++;
				fprintf(stderr, "Line %d: \x1b[31m Syntax Error \x1b[0m at %s:\n \x1b[31m %s \x1b[0m \n", yylineno, yytext, linebuf);
			} 
%%

/************************** End Scanner File *****************************/