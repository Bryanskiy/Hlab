#include <iostream>
#include <fstream>
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Constants.h"

void dump_codegen(llvm::Module* module) {
    std::string s;
    llvm::raw_string_ostream os(s);
    module->print(os, nullptr);
    os.flush();
    std::cout << s;
}

void main_codegen(llvm::Module* module, llvm::IRBuilder<>* builder) {
    auto mainFunc = module->getFunction("main");
    // entry:
    llvm::BasicBlock *entryBB = llvm::BasicBlock::Create(module->getContext(), "entry", mainFunc);
    builder->SetInsertPoint(entryBB);

    llvm::Value* val1 = builder->CreateAlloca(builder->getInt32Ty());
    builder->CreateStore(llvm::ConstantInt::get(builder->getInt32Ty(), 0), val1);

    // call  @dr_init_window
    auto initWindowFunc = module->getFunction("dr_init_window");
    builder->CreateCall(initWindowFunc->getFunctionType(), initWindowFunc,
        {llvm::ConstantInt::get(builder->getInt32Ty(), 600), 
         llvm::ConstantInt::get(builder->getInt32Ty(), 400)}
    );

    // call @init_world
    auto initWorldFunc = module->getFunction("init_world");
    builder->CreateCall(initWorldFunc->getFunctionType(), initWorldFunc);

    builder->CreateRetVoid();
}

void create_declarations(llvm::Module* module, llvm::IRBuilder<>* builder) {
    // declare void @main()
    llvm::FunctionType *funcType = 
        llvm::FunctionType::get(builder->getVoidTy(), false);
    llvm::Function *mainFunc =
        llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "main", module);

    // declare @init_world    
    llvm::Function *init_world =
        llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "init_world", module);

    // declare @dr_init_window
    funcType = llvm::FunctionType::get(builder->getVoidTy(), {builder->getInt32Ty(), builder->getInt32Ty()}, false);
    llvm::Function *dr_init_window =
        llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "dr_init_window", module);
}

void init_world_codegen(llvm::Module* module, llvm::IRBuilder<>* builder) {

}

int main()
{
    llvm::LLVMContext context;
    // ; ModuleID = 'main.c'
    // source_filename = "main.c"
    llvm::Module* module = new llvm::Module("main.c", context);
    llvm::IRBuilder<> builder(context);

    // @current_surf = dso_local global [600 x [400 x i32]] zeroinitializer, align 16
    // @tmp_surf = dso_local global [600 x [400 x i32]] zeroinitializer, align 16
    llvm::ArrayType* globals_type = llvm::ArrayType::get(llvm::ArrayType::get(builder.getInt32Ty(), 400), 600);
    llvm::Constant* current_surf = module->getOrInsertGlobal("current_surf", globals_type);
    llvm::Constant* tmp_surf = module->getOrInsertGlobal("tmp_surf", globals_type);

    create_declarations(module, &builder);
    main_codegen(module, &builder);
    init_world_codegen(module, &builder);
    dump_codegen(module);

    return 0;
}
