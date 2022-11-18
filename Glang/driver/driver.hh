#pragma once

#ifndef yyFlexLexer
#include <FlexLexer.h>
#endif

#include <string>
#include <fstream>
#include <sstream>
#include <memory>

#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/raw_ostream.h"

#include "parser.hh"

namespace glang {

struct CodeGenCtx {
    CodeGenCtx();
    std::unique_ptr<llvm::LLVMContext> m_context = nullptr;
    std::unique_ptr<llvm::Module> m_module = nullptr;
    std::unique_ptr<llvm::IRBuilder<>> m_builder = nullptr;
};

} // namespace glang

namespace yy {
    class Driver final {
    public:
        ~Driver() = default;
        Driver(std::istream& in, std::ostream& out);
        parser::token_type yylex(parser::semantic_type* yylval);
        bool parse();
    private:
        std::unique_ptr<yyFlexLexer> m_lexer = nullptr;
        glang::CodeGenCtx m_codegenCtx;
    };
}
