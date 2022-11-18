%language "c++"
%skeleton "lalr1.cc"

%define api.value.type variant
%param {Driver* driver}

%code requires {
    #include <string>
    #include <memory>
    namespace yy { class Driver; }
    namespace glang { class INode; class ScopeN; }
}

%code {
    #include "driver.hh"
    #include "node.hh"
    namespace yy {parser::token_type yylex(parser::semantic_type* yylval, Driver* driver);}
}

%token <std::string> IDENTIFIER 
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

%nterm<std::shared_ptr<glang::ScopeN>> scope
%nterm<std::shared_ptr<glang::ScopeN>> close_sc
%nterm<std::shared_ptr<glang::INode>>  stm
%nterm<std::shared_ptr<glang::INode>>  assign
%nterm<std::shared_ptr<glang::INode>>  lval
%nterm<std::shared_ptr<glang::INode>>  if 
%nterm<std::shared_ptr<glang::INode>>  while
%nterm<std::shared_ptr<glang::INode>>  expr1
%nterm<std::shared_ptr<glang::INode>>  expr2
%nterm<std::shared_ptr<glang::INode>>  expr3
%nterm<std::shared_ptr<glang::INode>>  condition
%nterm<std::shared_ptr<glang::INode>>  output 
%nterm<std::shared_ptr<glang::INode>>  stms
%nterm<std::shared_ptr<glang::INode>>  open_sc


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

lval:       IDENTIFIER                          {
                                                };

expr1:       expr2 PLUS expr2                   {};
           | expr2 MINUS expr2                  {};
           | expr2                              {};

expr2:      expr3 MUL expr3                     {};
          | expr3 DIV expr3                     {};
          | expr3 MOD expr3                     {};
          | expr3                               {};

expr3:      LRB expr1 RRB                       {}; 
          | IDENTIFIER                          {
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