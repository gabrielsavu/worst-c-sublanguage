%option yylineno noyywrap
%{

#include "parser.h"

static int next_column = 1;
int column = 1;
    
#define HANDLE_COLUMN column = next_column; next_column += strlen(yytext)


%} 

IDENTIFIER [_a-zA-Z][_a-zA-Z0-9]*

CONDITIONAL_OPERATOR [|][|]|[&][&]

UNARY_OPERATOR [-][-]|[+][+]

CONDITIONAL_BINARY_OPERATOR [<>]|[=][=]

BINARY_OPERATOR [<][<]|[->][>]|[&+\/\-*(){}\[\]\.,%~!?:|^]

ASSIGMENT_OPERATOR [<][<][=]|[>][>][=]|[+\-*\/!%^|&<>][=]|[=]

CONSTANT_DECIMAL [1-9][0-9]*|0
CONSTANT_FLOAT [0-9]*\.[0-9]+
CONSTANT_OCTAL [0][0-7]*
CONSTANT_HEX [0][xX][0-9A-Fa-f]+
CONSTANT_CHAR ['][ ,;'_\.\*\!\a-zA-Z]?[']
CONSTANT_STRING ["][ ,;'_\.\*\!\a-zA-Z]*["]

SUFFIX_FLOAT [flFL]
SUFFIX_INTEGER [uU][lL]|[lL][uU]|[uUlL]
SUFFIX_EXPONENT [eE][+-]?[0-9]+

NEWLINE \r\n|\r|\n
WHITESPACE [ \n\t\r]+


%%

void|double|float|long|int|short|unsigned|signed {
    HANDLE_COLUMN;
    printf("variable type: %s\n", yytext);
    return (DATA_TYPE);
}

struct|enum|union {
    HANDLE_COLUMN;
    printf("struct type: %s\n", yytext);
    return (STRUCT_DATA_TYPE);
}

const|volatile {
    HANDLE_COLUMN;
    printf("type qualifier: %s\n", yytext);
    return (TYPE_QUALIFIER);
}

";" {
    HANDLE_COLUMN;
    printf("semicolon: %s\n", yytext);
    return (SEMICOLON);
}

"," {
    HANDLE_COLUMN;
    printf("comma: %s\n", yytext);
    return (COMMA);
}


"{" {
    HANDLE_COLUMN;
    printf("open bracelet: %s\n", yytext);
    return (OPEN_BRACELET);
}


"}" {
    HANDLE_COLUMN;
    printf("close bracelet: %s\n", yytext);
    return (CLOSE_BRACELET);
}

"*" {
    HANDLE_COLUMN;
    printf("pointer: %s\n", yytext);
    return (POINTER);
}

"(" {
    HANDLE_COLUMN;
    printf("open parenthesis: %s\n", yytext);
    return (OPEN_PARENTHESIS);
}

")" {
    HANDLE_COLUMN;
    printf("close parenthesis: %s\n", yytext);
    return (CLOSE_PARENTHESIS);
}

if {
    HANDLE_COLUMN;
    printf("if stmt: %s\n", yytext);
    return (IF);
}

else {
    HANDLE_COLUMN;
    printf("else stmt: %s\n", yytext);
    return (ELSE);
}

while {
    HANDLE_COLUMN;
    printf("while stmt: %s\n", yytext);
    return (WHILE);
}

true|false {
    HANDLE_COLUMN;
    printf("boolean constant: %s\n", yytext);
    return (CONSTANT);
}

{IDENTIFIER} {
    HANDLE_COLUMN;
    printf("identifier: %s\n", yytext);
    return (IDENTIFIER);
}

{UNARY_OPERATOR} {
    HANDLE_COLUMN;
    printf("unary operator: %s\n", yytext);
    return (UNARY_OPERATOR); 
}

{BINARY_OPERATOR} { 
    HANDLE_COLUMN;
    printf("binary operator: %s\n", yytext);
    return (BINARY_OPERATOR); 
}

{CONDITIONAL_BINARY_OPERATOR} {
    HANDLE_COLUMN;
    printf("conditonal binary operator: %s\n", yytext);
    return (CONDITIONAL_BINARY_OPERATOR); 

}

{CONDITIONAL_OPERATOR} { 
    HANDLE_COLUMN;
    printf("conditional operator: %s\n", yytext);
    return (CONDITIONAL_OPERATOR); 
}

{ASSIGMENT_OPERATOR} {
    HANDLE_COLUMN;
    printf("assigment opreator: %s\n", yytext);
    return (ASSIGMENT_OPERATOR);
}

{CONSTANT_FLOAT}{SUFFIX_EXPONENT}?{SUFFIX_FLOAT}? {
    HANDLE_COLUMN;
    printf("constant float: %s\n", yytext);
    return (CONSTANT);
}

{CONSTANT_HEX}{SUFFIX_INTEGER}? {
    HANDLE_COLUMN;
    printf("constant hex: %s\n", yytext);
    return (CONSTANT);
}

{CONSTANT_DECIMAL}{SUFFIX_INTEGER}? {
    HANDLE_COLUMN;
    printf("constant decimal: %s\n", yytext);
    return (CONSTANT);
}

{CONSTANT_OCTAL}{SUFFIX_INTEGER}? {
    HANDLE_COLUMN;
    printf("constant octal: %s\n", yytext);
    return (CONSTANT);
}

{CONSTANT_CHAR} {
    HANDLE_COLUMN;
    printf("constant octal: %s\n", yytext);
    return (CONSTANT);
}

{CONSTANT_STRING} {
    HANDLE_COLUMN;
    printf("constant string: %s\n", yytext);
    return (CONSTANT);
}

{NEWLINE} { next_column = 1; HANDLE_COLUMN; }

{WHITESPACE} { HANDLE_COLUMN; }

<<EOF>> { next_column = 1; HANDLE_COLUMN; }

. { printf("other type\n"); HANDLE_COLUMN; }

%%
