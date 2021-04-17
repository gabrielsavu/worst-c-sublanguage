%require "3.7.6"
%language "c"

%{

#include <stdio.h>
#include <string.h>

int column;
extern int yylineno;
extern char* yytext;

int yylex();
int yyerror(const char* s);
%}


%token IDENTIFIER 
%token CONSTANT
%token CONDITIONAL_OPERATOR CONDITIONAL_BINARY_OPERATOR UNARY_OPERATOR BINARY_OPERATOR ASSIGMENT_OPERATOR
%token DATA_TYPE STRUCT_DATA_TYPE TYPE_QUALIFIER
%token POINTER
%token COMMA SEMICOLON OPEN_BRACELET CLOSE_BRACELET OPEN_PARENTHESIS CLOSE_PARENTHESIS
%token IF ELSE WHILE


%start start_point
%%

data_type:
	DATA_TYPE
;

pointer_list:
	%empty
	| POINTER pointer_list
;

type_qualifier_list:
	%empty
	| TYPE_QUALIFIER type_qualifier_list
;

variable_identifier_list:
	pointer_list type_qualifier_list pointer_list IDENTIFIER
	| variable_identifier_list COMMA variable_identifier_list
;

declaration:
	type_qualifier_list data_type variable_identifier_list SEMICOLON
;

expresion_helper:
	IDENTIFIER
	| CONSTANT
	| declaration
	| IDENTIFIER UNARY_OPERATOR
	| IDENTIFIER BINARY_OPERATOR CONSTANT
	| IDENTIFIER BINARY_OPERATOR IDENTIFIER
	| IDENTIFIER ASSIGMENT_OPERATOR expresion_helper
;

expresion:
	expresion_helper
	| OPEN_PARENTHESIS expresion_helper CLOSE_PARENTHESIS
	| expresion_helper expresion
;

expresion_list:
	expresion SEMICOLON
	| expresion SEMICOLON expresion_list
;

conditional_expresion:
	expresion CONDITIONAL_BINARY_OPERATOR expresion
;

if_stmt:
	IF OPEN_PARENTHESIS conditional_expresion CLOSE_PARENTHESIS OPEN_BRACELET expresion_list CLOSE_BRACELET
	| IF OPEN_PARENTHESIS conditional_expresion CLOSE_PARENTHESIS OPEN_BRACELET expresion_list CLOSE_BRACELET ELSE OPEN_BRACELET expresion_list CLOSE_BRACELET

;

if_stmt_list:
	if_stmt
	| if_stmt if_stmt_list
;

while_stmt:
	WHILE OPEN_PARENTHESIS conditional_expresion CLOSE_PARENTHESIS OPEN_BRACELET expresion_list CLOSE_BRACELET
;

while_stmt_list:
	while_stmt
	| while_stmt while_stmt_list
;

function_body_helper:
	if_stmt_list
	| while_stmt_list
	| expresion_list
;

function_body:
	%empty
	| function_body_helper function_body
;


function_parameters_list:
	type_qualifier_list data_type pointer_list type_qualifier_list pointer_list IDENTIFIER
	| function_parameters_list COMMA function_parameters_list
;


function_definition:
	type_qualifier_list data_type IDENTIFIER OPEN_PARENTHESIS CLOSE_PARENTHESIS SEMICOLON
	| type_qualifier_list data_type IDENTIFIER OPEN_PARENTHESIS function_parameters_list CLOSE_PARENTHESIS SEMICOLON
	| type_qualifier_list data_type IDENTIFIER OPEN_PARENTHESIS CLOSE_PARENTHESIS OPEN_BRACELET function_body CLOSE_BRACELET
	| type_qualifier_list data_type IDENTIFIER OPEN_PARENTHESIS function_parameters_list CLOSE_PARENTHESIS OPEN_BRACELET function_body CLOSE_BRACELET
;

function_definition_list:
	function_definition
	| function_definition function_definition_list
;

/* Start point */

start_point: 
	start_point_helper
	| start_point_helper start_point
;

start_point_helper:
	function_definition_list
;


%%


int yyerror(const char* s) {
	fprintf (stderr, "error: %s '%s' in line %d column %d\n", s, yytext,  yylineno, column);
	return 0;
}


int main(int argc, char* argv[]) {
	return yyparse();
}