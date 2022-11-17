%language "c++"
%skeleton "lalr1.cc"

%define api.value.type variant
%param {Driver* driver}

%code requires {
    #include <string>
    namespace yy { class Driver; }
}

%code {
    #include "driver.hh"
    namespace yy {parser::token_type yylex(parser::semantic_type* yylval, Driver* driver);}
}

%token <std::string> NAME 
%token <int> INTEGER
%token WHILE             "while"   
       INPUT              "?"
       IF                "if"
       SCOLON            ";"
       LCB               "{"
       RCB               "}"
       LRB               "("
       RRB               ")"
       OUTPUT            "print"
       ASSIGN            "="
       OR                "||" 
       AND               "&&"
       NOT               "!"
       EQUAL             "=="
       NOT_EQUAL         "!="
       GREATER           ">"
       LESS              "<"
       LESS_OR_EQUAL     "<="
       GREATER_OR_EQUAL  ">="
       PLUS              "+"  
       MINUS             "-"
       MUL               "*"
       DIV               "/"
       MOD               "%"

%%

program:    stms                                {};

scope:      open_sc stms close_sc               {};

open_sc:    LCB                                 {};

close_sc:   RCB                                 {
                                                };

stms:       stm                                 {};
          | stms stm                            {};
          | stms scope                          {};

stm:        assign                              {};
          | if                                  {};
          | while                               {};
          | output                              {};

assign:     lval ASSIGN expr1 SCOLON            {};

lval:       NAME                                {
                                                };

expr1:       expr2 PLUS expr2                   {};
           | expr2 MINUS expr2                  {};
           | expr2                              {};

expr2:      expr3 MUL expr3                     {};
          | expr3 DIV expr3                     {};
          | expr3 MOD expr3                     {};
          | expr3                               {};

expr3:      LRB expr1 RRB                       {}; 
          | NAME                                {
                                                };
          | INTEGER                             {};
          | INPUT                               {};                  

condition:  expr1 AND expr1                     {};
          | expr1 OR expr1                      {};      
          | NOT expr1                           {};    
          | expr1 EQUAL expr1                   {};  
          | expr1 NOT_EQUAL expr1               {};  
          | expr1 GREATER expr1                 {};  
          | expr1 LESS expr1                    {};  
          | expr1 GREATER_OR_EQUAL expr1        {};  
          | expr1 LESS_OR_EQUAL expr1           {};
          | expr1                               {};

if:        IF LRB condition RRB scope           {};

while:     WHILE LRB condition RRB scope        {};

output:    OUTPUT expr1 SCOLON                  {};
                         
%%

namespace yy {

    parser::token_type yylex (parser::semantic_type* yylval, Driver* driver) {
		return driver->yylex(yylval);
	}

	void parser::error (const std::string& msg) {
		std::cout << msg << " in line: " << std::endl;
	}
}