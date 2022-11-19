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

program:    stms                                { driver->codegen(); };

scope:      open_sc stms close_sc               {$$ = $3;};

open_sc:    LCB                                 {
                                                    auto&& scope = driver->m_currentScope;
                                                    scope = std::make_shared<glang::ScopeN>(scope);
                                                };

close_sc:   RCB                                 {
                                                    auto&& scope = driver->m_currentScope;
                                                    $$ = scope;
                                                    scope = scope->getParent();
                                                };

stms:       stm                                 {
                                                    auto&& scope = driver->m_currentScope;
                                                    scope->insertChild($1);
                                                };
          | stms stm                            {
                                                    auto&& scope = driver->m_currentScope;
                                                    scope->insertChild($2);
                                                };
          | stms scope                          {
                                                    auto&& scope = driver->m_currentScope;
                                                    scope->insertChild($2);
                                                };

stm:        assign                              { std::cout << "hello"; $$ = $1; };
          | if                                  { $$ = $1; };
          | while                               { $$ = $1; };
          | output                              { $$ = $1; };

assign:     lval ASSIGN expr1 SCOLON            { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Assign, $3); };

lval:       IDENTIFIER                          {
                                                    auto&& scope = driver->m_currentScope;
                                                    auto&& node = scope->getDeclIfVisible($1);
                                                    if(!node) {
                                                        node = std::make_shared<glang::DeclVarN>();
                                                        scope->insertDecl($1, node);
                                                    }
                                                    $$ = node;
                                                };

expr1:       expr2 PLUS expr2                   { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Plus, $3); };
           | expr2 MINUS expr2                  { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Minus, $3); };
           | expr2                              { $$ = $1; };

expr2:      expr3 MUL expr3                     { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Mult, $3); };
          | expr3 DIV expr3                     { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Div, $3); };
          | expr3 MOD expr3                     { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Mod, $3); };
          | expr3                               { $$ = $1; };

expr3:      LRB expr1 RRB                       { $$ = $2; }; 
          | IDENTIFIER                          {
                                                    auto&& scope = driver->m_currentScope;
                                                    auto&& node = scope->getDeclIfVisible($1);
                                                    assert(node != nullptr);
                                                    $$ = node;
                                                };
          | INTEGER                             { $$ = std::make_shared<glang::I32N>($1); };
          | INPUT                               { assert(0); };                  

condition:  expr1 AND expr1                     { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::And, $3); };
          | expr1 OR expr1                      { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Or, $3); };      
          | NOT expr1                           {};    
          | expr1 EQUAL expr1                   { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Equal, $3); };  
          | expr1 NOT_EQUAL expr1               { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::NotEqual, $3); };  
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