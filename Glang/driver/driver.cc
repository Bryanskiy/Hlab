#include "driver.hh"

namespace yy {
    
Driver::Driver(std::istream& in, std::ostream& out) {
    m_lexer = std::make_unique<yyFlexLexer>(in, out);
}

bool Driver::parse() {
    parser parser(this);
    bool res = parser.parse();
    return !res;
}

parser::token_type Driver::yylex(parser::semantic_type* yylval) {
    parser::token_type token = static_cast<parser::token_type>(m_lexer->yylex());
    if(token == yy::parser::token_type::IDENTIFIER) {
        std::string name(m_lexer->YYText());
        parser::semantic_type tmp;
        tmp.as<std::string>() = name;
        yylval->swap<std::string>(tmp);
    } 
    else if(token == yy::parser::token_type::INTEGER) {
        yylval->as<int>() = std::atoi(m_lexer->YYText());
    }

    return token;
}

void Driver::codegen() {
    auto&& module = m_codegenCtx.m_module;
    auto&& builder = m_codegenCtx.m_builder;
    auto&& context = m_codegenCtx.m_context;

    // __pcl_start
    llvm::FunctionType *pclStartTy = llvm::FunctionType::get(builder->getInt32Ty(), false);
    auto&& pclStart = llvm::Function::Create(pclStartTy, llvm::Function::ExternalLinkage, "start", *module);

    llvm::BasicBlock *initBB = llvm::BasicBlock::Create(*context, "entry", pclStart);
    builder->SetInsertPoint(initBB);

    m_currentScope->codegen(m_codegenCtx);
}

void Driver::dumpIR(std::ostream& out) {
    std::string s;
    llvm::raw_string_ostream os(s);
    m_codegenCtx.m_module->print(os, nullptr);
    os.flush();
    out << s;
}

} // namespace yy