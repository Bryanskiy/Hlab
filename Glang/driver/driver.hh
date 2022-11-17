#pragma once

#ifndef yyFlexLexer
#include <FlexLexer.h>
#endif

#include <string>
#include <fstream>
#include <sstream>
#include <memory>

#include "parser.hh"

namespace yy {
    class Driver final {
    public:
        ~Driver() = default;
        Driver(std::istream& in, std::ostream& out);
        parser::token_type yylex(parser::semantic_type* yylval);
        bool parse();
    private:
        std::unique_ptr<yyFlexLexer> lexer = nullptr;
    };
}
