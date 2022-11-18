#include "node.hh"

namespace glang {

std::shared_ptr<DeclVarN> ScopeN::getDeclIfVisible(const std::string& name) const {
    std::shared_ptr<DeclVarN> ret = nullptr;
    auto&& it = m_symTable.find(name);
    if(it != m_symTable.end()) {
        return it->second;
    }
    if(m_parent) {
        return m_parent->getDeclIfVisible(name);
    }
    return ret;
}

llvm::Value* ScopeN::codegen(CodeGenCtx& ctx) {
    for(auto&& child : m_childs) {
        child->codegen(ctx);
    }
    nullptr;
}

llvm::Value* I32N::codegen(CodeGenCtx& ctx) {
    return ctx.m_builder->getInt32(m_val);
}

llvm::Value* BinOpN::codegen(CodeGenCtx& ctx) {
    llvm::Value* lhsCodeGen = m_lhs->codegen(ctx);
    llvm::Value* rhsCodeGen = m_rhs->codegen(ctx);
    switch (m_op) {
    case BinOp::Plus:
        return ctx.m_builder->CreateAdd(lhsCodeGen, rhsCodeGen);
    case BinOp::Minus:
        return ctx.m_builder->CreateSub(lhsCodeGen, rhsCodeGen);
    case BinOp::Div:
        return ctx.m_builder->CreateSDiv(lhsCodeGen, rhsCodeGen);
    case BinOp::Mod:
        // todo
        assert(0);
    case BinOp::Mult:
        return ctx.m_builder->CreateMul(lhsCodeGen, rhsCodeGen);
    case BinOp::And:
        return ctx.m_builder->CreateAnd(lhsCodeGen, rhsCodeGen);
    case BinOp::Or:
        return ctx.m_builder->CreateOr(lhsCodeGen, rhsCodeGen);
    case BinOp::Equal:
        return ctx.m_builder->CreateICmpEQ(lhsCodeGen, rhsCodeGen);
    case BinOp::NotEqual:
        return ctx.m_builder->CreateICmpNE(lhsCodeGen, rhsCodeGen);
    case BinOp::Greater:
        return ctx.m_builder->CreateICmpSGT(lhsCodeGen, rhsCodeGen);
    case BinOp::Less:
        return ctx.m_builder->CreateICmpSLT(lhsCodeGen, rhsCodeGen);
    case BinOp::GreaterOrEqual:
        return ctx.m_builder->CreateICmpSGE(lhsCodeGen, rhsCodeGen);
    case BinOp::LessOrEqual:
        return ctx.m_builder->CreateICmpSLE(lhsCodeGen, rhsCodeGen);
    case BinOp::Assign:
        assert(0); // todo 
    default:
        assert(0);
    }

    nullptr;
}

llvm::Value* UnOpN::codegen(CodeGenCtx& ctx) {
    llvm::Value* valCodegen = m_val->codegen(ctx);
    switch (m_op) {
        case UnOp::Not:
            return ctx.m_builder->CreateNot(valCodegen);
        case UnOp::Input:
            assert(0); // todo
        case UnOp::Output:
            assert(0); // todo
        default:
            assert(0);
    };

    nullptr;
}

} // namespace glang