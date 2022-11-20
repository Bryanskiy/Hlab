%language "c++"
%skeleton "lalr1.cc"

%define api.value.type variant
%param {Driver* driver}

%code requires {
    #include <string>
    #include <memory>
    namespace yy { class Driver; }
    namespace glang { class INode; class ScopeN; class FuncDeclN; }
}

%code {
    #include "driver.hh"
    #include "node.hh"
    namespace yy {parser::token_type yylex(parser::semantic_type* yylval, Driver* driver);}
}

%token <std::string> IDENTIFIER 
%token <int> INTEGER
%token WHILE             "while"   
       RETURN            "return"
       INPUT             "?"
       IF                "if"
       FN                "fn"
       SCOLON            ";"
       LCB               "{"
       RCB               "}"
       LRB               "("
       RRB               ")"
       COMMA             ","
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

%nterm<std::shared_ptr<glang::ScopeN>>     globalScope
%nterm<std::shared_ptr<glang::ScopeN>>     scope
%nterm<std::shared_ptr<glang::ScopeN>>     closeSc
%nterm<std::shared_ptr<glang::ScopeN>>     openSc
%nterm<std::shared_ptr<glang::INode>>      func
%nterm<std::shared_ptr<glang::FuncDeclN>>  funcSign
%nterm<std::shared_ptr<glang::INode>>      argList
%nterm<std::shared_ptr<glang::INode>>      stm
%nterm<std::shared_ptr<glang::INode>>      declVar
%nterm<std::shared_ptr<glang::INode>>      lval
%nterm<std::shared_ptr<glang::INode>>      if 
%nterm<std::shared_ptr<glang::INode>>      while
%nterm<std::shared_ptr<glang::INode>>      expr1
%nterm<std::shared_ptr<glang::INode>>      expr2
%nterm<std::shared_ptr<glang::INode>>      expr3
%nterm<std::shared_ptr<glang::INode>>      condition
%nterm<std::shared_ptr<glang::INode>>      output 
%nterm<std::shared_ptr<glang::INode>>      stms


%%

program:        globalScope                         { driver->codegen(); };

globalScope:    declVar globalScope                 {                                                         
                                                        auto&& scope = driver->m_currentScope;
                                                        scope->insertChild($1); 
                                                    };
              | func globalScope                    { 
                                                        auto&& scope = driver->m_currentScope;
                                                        scope->insertChild($1);
                                                    };
              | /* empty */                         {};

func:           FN funcSign scope                   {
                                                        $$ = std::make_shared<glang::FuncN>($3, $2);
                                                    };
funcSign:       IDENTIFIER LRB argList RRB          {
                                                        auto&& scope = driver->m_currentScope;
                                                        auto&& currentFunctionArgs = driver->m_currentFunctionArgs;

                                                        assert(scope->getDeclIfVisible($1) == nullptr && "decl with same name exists");

                                                        for(const std::string& name : currentFunctionArgs) {
                                                            auto&& node = std::make_shared<glang::DeclVarN>();
                                                            scope->insertDecl(name, node);
                                                        }

                                                        $$ = std::make_shared<glang::FuncDeclN>($1, currentFunctionArgs);
                                                        scope->insertDecl($1, $$);
                                                        currentFunctionArgs.clear();
                                                    };
              | IDENTIFIER LRB RRB                  {
                                                        auto&& scope = driver->m_currentScope;
                                                        assert(scope->getDeclIfVisible($1) == nullptr && "decl with same name exists");
                                                        $$ = std::make_shared<glang::FuncDeclN>($1); 
                                                        scope->insertDecl($1, $$);
                                                    };

argList:        argList COMMA IDENTIFIER            {
                                                        auto&& currentFunctionArgs = driver->m_currentFunctionArgs;
                                                        currentFunctionArgs.push_back($3); 
                                                    };
              | IDENTIFIER                          {
                                                        auto&& currentFunctionArgs = driver->m_currentFunctionArgs;
                                                        currentFunctionArgs.push_back($1); 
                                                    };

scope:          openSc stms closeSc                 {$$ = $3;};

openSc:         LCB                                 {
                                                        auto&& scope = driver->m_currentScope;
                                                        scope = std::make_shared<glang::ScopeN>(scope);
                                                    };

closeSc:        RCB                                 {
                                                        auto&& scope = driver->m_currentScope;
                                                        $$ = scope;
                                                        scope = scope->getParent();
                                                    };


stms:           stm                                 {
                                                        auto&& scope = driver->m_currentScope;
                                                        scope->insertChild($1);
                                                    };

              | stms stm                            {
                                                        auto&& scope = driver->m_currentScope;
                                                        scope->insertChild($2);
                                                    };

stm:            declVar                             { $$ = $1; };
              | if                                  { $$ = $1; };
              | while                               { $$ = $1; };
              | output                              { $$ = $1; };

declVar:        lval ASSIGN expr1 SCOLON            { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Assign, $3); };

lval:           IDENTIFIER                          {
                                                        auto&& scope = driver->m_currentScope;
                                                        auto&& node = scope->getDeclIfVisible($1);
                                                        if(!node) {
                                                            node = std::make_shared<glang::DeclVarN>();
                                                            scope->insertDecl($1, node);
                                                        }
                                                        $$ = node;
                                                    };

expr1:          expr2 PLUS expr2                    { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Plus, $3); };
              | expr2 MINUS expr2                   { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Minus, $3); };
              | expr2                               { $$ = $1; };

expr2:          expr3 MUL expr3                     { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Mult, $3); };
              | expr3 DIV expr3                     { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Div, $3); };
              | expr3 MOD expr3                     { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Mod, $3); };
              | expr3                               { $$ = $1; };

expr3:          LRB expr1 RRB                       { $$ = $2; }; 
              | IDENTIFIER                          
                                                    {
                                                        auto&& scope = driver->m_currentScope;
                                                        auto&& node = scope->getDeclIfVisible($1);
                                                        assert(node != nullptr);
                                                        $$ = node;
                                                    };
              | INTEGER                             { $$ = std::make_shared<glang::I32N>($1); };
              | INPUT                               { $$ = std::make_shared<glang::UnOpN>(glang::UnOp::Input, nullptr); };

condition:    expr1 AND expr1                       { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::And, $3); };
            | expr1 OR expr1                        { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Or, $3); };      
            | NOT expr1                             { $$ = std::make_shared<glang::UnOpN>(glang::UnOp::Not, $2); };    
            | expr1 EQUAL expr1                     { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Equal, $3); };  
            | expr1 NOT_EQUAL expr1                 { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::NotEqual, $3); };  
            | expr1 GREATER expr1                   { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Greater, $3); };  
            | expr1 LESS expr1                      { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Less, $3); };  
            | expr1 GREATER_OR_EQUAL expr1          { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::GreaterOrEqual, $3); };  
            | expr1 LESS_OR_EQUAL expr1             { $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::LessOrEqual, $3); };
            | expr1                                 { $$ = $1; };

if:          IF LRB condition RRB scope             { $$ = std::make_shared<glang::IfN>($5, $3); };

while:       WHILE LRB condition RRB scope          { $$ = std::make_shared<glang::WhileN>($5, $3); };

output:      OUTPUT expr1 SCOLON                    { $$ = std::make_shared<glang::UnOpN>(glang::UnOp::Output, $2); };
                         
%%

namespace yy {

    parser::token_type yylex (parser::semantic_type* yylval, Driver* driver) {
		return driver->yylex(yylval);
	}

    void parser::error (const std::string& msg) {
        std::cout << msg << " in line: " << std::endl;
	}
}