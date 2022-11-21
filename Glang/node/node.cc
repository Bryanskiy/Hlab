#include "node.hh"

namespace glang {

CodeGenCtx::CodeGenCtx() {
    m_context = std::make_unique<llvm::LLVMContext>();
    m_module = std::make_unique<llvm::Module>("main", *m_context);
    m_builder = std::make_unique<llvm::IRBuilder<>>(*m_context);

    // __glang_print
    llvm::FunctionType* glangPrintTy = llvm::FunctionType::get(m_builder->getVoidTy(), {m_builder->getInt32Ty()}, false);
    auto* glangPrint = llvm::Function::Create(glangPrintTy, llvm::Function::ExternalLinkage, "__glang_print", *m_module);

    // __glang_scan
    llvm::FunctionType* glangScanTy = llvm::FunctionType::get(m_builder->getInt32Ty(), false);
    auto* glangScan = llvm::Function::Create(glangScanTy, llvm::Function::ExternalLinkage, "__glang_scan", *m_module);
}

std::shared_ptr<DeclN> ScopeN::getDeclIfVisible(const std::string& name) const {
    std::shared_ptr<DeclN> ret = nullptr;
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
    return nullptr;
}

llvm::Value* I32N::codegen(CodeGenCtx& ctx) {
    return ctx.m_builder->getInt32(m_val);
}

llvm::Value* DeclVarN::codegen(CodeGenCtx& ctx) {
    auto&& builder = ctx.m_builder;
    if (!m_alloca) {
        m_alloca = builder->CreateAlloca(builder->getInt32Ty());
    }
    return builder->CreateLoad(builder->getInt32Ty(), m_alloca);
}

void DeclVarN::store(CodeGenCtx& ctx, llvm::Value* val) {
    ctx.m_builder->CreateStore(val, m_alloca);
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
        std::shared_ptr<DeclVarN> decl = std::dynamic_pointer_cast<DeclVarN>(m_lhs);
        decl->store(ctx, rhsCodeGen);
        return nullptr;
    }

    assert(0);
    nullptr;
}

llvm::Value* UnOpN::codegen(CodeGenCtx& ctx) {
    auto&& module = ctx.m_module;
    auto&& builder = ctx.m_builder;
    llvm::Value* valCodegen;
    if (m_val) {
        valCodegen = m_val->codegen(ctx);
    }
    switch (m_op) {
        case UnOp::Not:
            return ctx.m_builder->CreateNot(valCodegen);
        case UnOp::Output:
        {
            auto* glangPrint = module->getFunction("__glang_print");
            assert(glangPrint && "Driver shall create decl for __glang_print");

            llvm::Value* args[] = { valCodegen };
            return builder->CreateCall(glangPrint, args);
        }
        case UnOp::Input:
        {
            auto* glangScan = module->getFunction("__glang_scan");
            assert(glangScan && "Driver shall create decl for __glang_scan");

            return builder->CreateCall(glangScan);
        }
    };
    assert(0);
    nullptr;
}

llvm::Value* IfN::codegen(CodeGenCtx& ctx) {
    auto&& module = ctx.m_module;
    auto&& builder = ctx.m_builder;
    auto&& context = ctx.m_context;

    auto&& funcHeader = m_currentScope->getParentFunc();
    auto* func = module->getFunction(funcHeader->getName());
    assert(func && "Driver shall create decl for func");

    llvm::BasicBlock *taken = llvm::BasicBlock::Create(*context, "", func);
    llvm::BasicBlock *notTaken = llvm::BasicBlock::Create(*context, "", func);

    auto* conditionCodegen = m_condition->codegen(ctx);

    builder->CreateCondBr(conditionCodegen, taken, notTaken);
    builder->SetInsertPoint(taken);
    m_block->codegen(ctx);
    builder->CreateBr(notTaken);
    builder->SetInsertPoint(notTaken);
    return nullptr;
}

llvm::Value* WhileN::codegen(CodeGenCtx& ctx) {
    auto&& module = ctx.m_module;
    auto&& builder = ctx.m_builder;
    auto&& context = ctx.m_context;

    auto&& funcHeader = m_currentScope->getParentFunc();
    auto* func = module->getFunction(funcHeader->getName());
    assert(func && "Driver shall create decl for func");

    llvm::BasicBlock *takenBB = llvm::BasicBlock::Create(*context, "", func);
    llvm::BasicBlock *notTakenBB = llvm::BasicBlock::Create(*context, "", func);
    llvm::BasicBlock *conditionBB = llvm::BasicBlock::Create(*context, "", func);

    builder->CreateBr(conditionBB);
    builder->SetInsertPoint(conditionBB);
    auto* conditionCodegen = m_condition->codegen(ctx);
    builder->CreateCondBr(conditionCodegen, takenBB, notTakenBB);

    builder->SetInsertPoint(takenBB);
    auto* blockCodegen = m_block->codegen(ctx);
    builder->CreateBr(conditionBB);

    builder->SetInsertPoint(notTakenBB);
    return nullptr;
}

llvm::Value* FuncDeclN::codegen(CodeGenCtx& ctx) {
    if (!m_func) {
        auto&& module = ctx.m_module;
        auto&& builder = ctx.m_builder;
        auto&& context = ctx.m_context;

        std::vector<llvm::Type*> argTypes;
        for (std::size_t i = 0; i < m_argNames.size(); ++i) {
            argTypes.push_back(builder->getInt32Ty());
        }

        llvm::FunctionType* functTy = llvm::FunctionType::get(builder->getInt32Ty(), argTypes, false);
        m_func = llvm::Function::Create(functTy, llvm::Function::ExternalLinkage, m_name, *module);
    }
    return m_func;
}

llvm::Value* FuncN::codegen(CodeGenCtx& ctx) {
    auto&& module = ctx.m_module;
    auto&& builder = ctx.m_builder;
    auto&& context = ctx.m_context;

    m_header->codegen(ctx); // create func declaration

    auto&& funcName = m_header->getName();
    auto* func = module->getFunction(funcName);

    llvm::BasicBlock *initBB = llvm::BasicBlock::Create(*context, "entry", func);
    builder->SetInsertPoint(initBB);

    auto&& argNames = m_header->getArgNames();
    auto&& symTable = m_scope->getSymTab();

    for(std::size_t i = 0; i < argNames.size(); ++i) {
        auto&& it = symTable.find(argNames[i]);
        if(it != symTable.end()) {
            auto&& decl = std::dynamic_pointer_cast<DeclVarN>(it->second);
            decl->codegen(ctx);
            auto&& argVal = func->getArg(i);
            decl->store(ctx, argVal);
        }
    }

    m_scope->codegen(ctx);
    return nullptr;
}

llvm::Value* RetN::codegen(CodeGenCtx& ctx) {
    auto* valCodegen = m_val->codegen(ctx);
    ctx.m_builder->CreateRet(valCodegen);
}

llvm::Value* FuncCallN::codegen(CodeGenCtx& ctx) {
    auto&& module = ctx.m_module;
    auto&& builder = ctx.m_builder;
    auto&& context = ctx.m_context;

    auto* funcDecl = llvm::dyn_cast<llvm::Function>(m_funcDecl->codegen(ctx));
    auto* funcTy = funcDecl->getFunctionType();

    auto&& symTable = m_currScope->getSymTab();

    std::vector<llvm::Value*> args;
    for (auto&& name : m_argNames) {
        auto&& it = symTable.find(name);
        assert(it != symTable.end());
        args.push_back(it->second->codegen(ctx));
    }

    auto* ret = builder->CreateCall(funcTy, funcDecl, args);
    return ret;
}

} // namespace glang