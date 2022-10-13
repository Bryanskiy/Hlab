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

    // while(1):
    llvm::BasicBlock *loop = llvm::BasicBlock::Create(module->getContext(), "loop", mainFunc);
    builder->CreateBr(loop);
    builder->SetInsertPoint(loop);

    // call @draw
    auto drawFunc = module->getFunction("draw");
    builder->CreateCall(drawFunc->getFunctionType(), module->getFunction("draw"));

    // call @update
    auto updateFunc = module->getFunction("draw");
    builder->CreateCall(updateFunc->getFunctionType(), module->getFunction("update"));

    // call @swap
    auto swapFunc = module->getFunction("draw");
    builder->CreateCall(swapFunc->getFunctionType(), module->getFunction("swap"));

    builder->CreateBr(loop);
}

void create_declarations(llvm::Module* module, llvm::IRBuilder<>* builder) {
    // declare void @main()
    llvm::FunctionType *funcType = 
        llvm::FunctionType::get(builder->getVoidTy(), false);

    llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "main", module);
    llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "init_world", module);
    llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "draw", module);
    llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "update", module);
    llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "swap", module);

    // declare @dr_init_window
    funcType = llvm::FunctionType::get(builder->getVoidTy(), {builder->getInt32Ty(), builder->getInt32Ty()}, false);
    llvm::Function *dr_init_window =
        llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "dr_init_window", module);
}

void init_world_codegen(llvm::Module* module, llvm::IRBuilder<>* builder) {
    std::unordered_map<int, llvm::BasicBlock*> id2bb;
    std::unordered_map<int, llvm::Value*> id2value;

    auto&& initWorldFunc = module->getFunction("init_world");
    id2bb[0] = llvm::BasicBlock::Create(module->getContext(), "0", initWorldFunc);
    id2bb[3] = llvm::BasicBlock::Create(module->getContext(), "3", initWorldFunc);
    id2bb[6] = llvm::BasicBlock::Create(module->getContext(), "6", initWorldFunc);
    id2bb[7] = llvm::BasicBlock::Create(module->getContext(), "7", initWorldFunc);
    id2bb[10] = llvm::BasicBlock::Create(module->getContext(), "10", initWorldFunc);
    id2bb[19] = llvm::BasicBlock::Create(module->getContext(), "19", initWorldFunc);
    id2bb[22] = llvm::BasicBlock::Create(module->getContext(), "22", initWorldFunc);
    id2bb[23] = llvm::BasicBlock::Create(module->getContext(), "23", initWorldFunc);
    id2bb[26] = llvm::BasicBlock::Create(module->getContext(), "26", initWorldFunc);

    // 0:
    //  %1 = alloca i32, align 4
    //  %2 = alloca i32, align 4
    //  store i32 0, i32* %1, align 4
    //  br label %3
    builder->SetInsertPoint(id2bb[0]);
    id2value[1] = builder->CreateAlloca(builder->getInt32Ty());
    id2value[2] = builder->CreateAlloca(builder->getInt32Ty());
    builder->CreateStore(llvm::ConstantInt::get(builder->getInt32Ty(), 0), id2value[1]);
    builder->CreateBr(id2bb[3]);

    // 3:                                                ; preds = %23, %0
    //   %4 = load i32, i32* %1, align 4
    //   %5 = icmp slt i32 %4, 600
    //   br i1 %5, label %6, label %26
    builder->SetInsertPoint(id2bb[3]);
    id2value[4] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[5] = builder->CreateICmpSLT(id2value[4], llvm::ConstantInt::get(builder->getInt32Ty(), 600));
    builder->CreateCondBr(id2value[5], id2bb[6], id2bb[26]);

    // 6:                                                ; preds = %3
    //  store i32 0, i32* %2, align 4
    //  br label %7
    builder->SetInsertPoint(id2bb[6]);
    builder->CreateStore(llvm::ConstantInt::get(builder->getInt32Ty(), 0), id2value[2]);
    builder->CreateBr(id2bb[7]);

    // 7:                                                ; preds = %19, %6
    // %8 = load i32, i32* %2, align 4
    // %9 = icmp slt i32 %8, 400
    // br i1 %9, label %10, label %22
    builder->SetInsertPoint(id2bb[7]);
    id2value[8] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);
    id2value[9] = builder->CreateICmpSLT(id2value[8], llvm::ConstantInt::get(builder->getInt32Ty(), 400));
    builder->CreateCondBr(id2value[9], id2bb[10], id2bb[22]);

    // 10:                                               ; preds = %7
    // %11 = call i32 (...) @dr_rand()
    // %12 = srem i32 %11, 16
    // %13 = load i32, i32* %1, align 4
    // %14 = sext i32 %13 to i64
    // %15 = getelementptr inbounds [600 x [400 x i32]], [600 x [400 x i32]]* @current_surf, i64 0, i64 %14
    // %16 = load i32, i32* %2, align 4
    // %17 = sext i32 %16 to i64
    // %18 = getelementptr inbounds [400 x i32], [400 x i32]* %15, i64 0, i64 %17
    // store i32 %12, i32* %18, align 4
    // br label %19
    builder->SetInsertPoint(id2bb[10]);
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
