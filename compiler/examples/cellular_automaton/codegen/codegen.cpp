#include <iostream>
#include <fstream>

#include "../draw.h"

#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Constants.h"
#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/raw_ostream.h"

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
    auto&& drawFunc = module->getFunction("draw");
    builder->CreateCall(drawFunc->getFunctionType(), drawFunc);

    // call @update
    auto&& updateFunc = module->getFunction("update");
    builder->CreateCall(updateFunc->getFunctionType(), updateFunc);

    // call @swap
    auto&& swapFunc = module->getFunction("swap");
    builder->CreateCall(swapFunc->getFunctionType(), swapFunc);

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

    llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "dr_flush", module);

    funcType = llvm::FunctionType::get(builder->getInt32Ty(), false);
    llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "dr_rand", module);

    // declare @dr_init_window
    funcType = llvm::FunctionType::get(builder->getVoidTy(), {builder->getInt32Ty(), builder->getInt32Ty()}, false);
    llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "dr_init_window", module);

    // declare @dr_put_pixel
    funcType = llvm::FunctionType::get(
        builder->getVoidTy(), 
        {
            builder->getInt32Ty(), 
            builder->getInt32Ty(), 
            builder->getInt32Ty()
        }, 
        false
    );
    llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "dr_put_pixel", module);

    llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "neighbors_count", module);
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
    auto&& dr_randFunc = module->getFunction("dr_rand");
    id2value[11] = builder->CreateCall(dr_randFunc->getFunctionType(), dr_randFunc);
    id2value[12] = builder->CreateSRem(id2value[11], llvm::ConstantInt::get(builder->getInt32Ty(), 16));
    id2value[13] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[14] = builder->CreateSExt(id2value[13], builder->getInt64Ty());
    /*
    auto&& current_surf = module->getGlobalVariable("current_surf");
    id2value[15] = builder->CreateGEP(
        current_surf->getType(),
        current_surf,
        {        
            llvm::ConstantInt::get(builder->getInt64Ty(), 0),
            id2value[14]
        }
    );
    id2value[16] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);
    id2value[17] = builder->CreateSExt(id2value[16], builder->getInt64Ty());
    id2value[18] = builder->CreateGEP(
        llvm::ArrayType::get(builder->getInt32Ty(), 400),
        id2value[15],
        {
            llvm::ConstantInt::get(builder->getInt64Ty(), 0),
            id2value[17] 
        }
    );
    builder->CreateStore(id2value[12], id2value[18]);
    builder->CreateBr(id2bb[19]);

    // 19:                                               ; preds = %10
    // %20 = load i32, i32* %2, align 4
    // %21 = add nsw i32 %20, 1
    // store i32 %21, i32* %2, align 4
    // br label %7, !llvm.loop !6
    builder->SetInsertPoint(id2bb[19]);
    id2value[20] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);
    id2value[21] = builder->CreateNSWAdd(id2value[20], llvm::ConstantInt::get(builder->getInt64Ty(), 1));
    builder->CreateStore(id2value[21], id2value[2]);
    builder->CreateBr(id2bb[7]);

    // 22:                                               ; preds = %7
    // br label %23
    builder->SetInsertPoint(id2bb[22]);
    builder->CreateBr(id2bb[23]);

    // 23:                                               ; preds = %22
    // %24 = load i32, i32* %1, align 4
    // %25 = add nsw i32 %24, 1
    // store i32 %25, i32* %1, align 4
    // br label %3, !llvm.loop !8
    builder->SetInsertPoint(id2bb[22]);
    id2value[24] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[25] = builder->CreateNSWAdd(id2value[24], llvm::ConstantInt::get(builder->getInt64Ty(), 1));
    builder->CreateStore(id2value[25], id2value[1]);
    builder->CreateBr(id2bb[3]);

    // 26:                                               ; preds = %3
    // ret void
    builder->SetInsertPoint(id2bb[26]);
    builder->CreateRetVoid();
    */
}

void neighbors_count_codegen(llvm::Module* module, llvm::IRBuilder<>* builder) {
    std::unordered_map<int, llvm::BasicBlock*> id2bb;
    std::unordered_map<int, llvm::Value*> id2value;

    auto&& neighbors_countFunc = module->getFunction("neighbors_count");
    
    id2bb[0] = llvm::BasicBlock::Create(module->getContext(), "0", neighbors_countFunc);
}

void swap_codegen(llvm::Module* module, llvm::IRBuilder<>* builder) {
    std::unordered_map<int, llvm::BasicBlock*> id2bb;
    std::unordered_map<int, llvm::Value*> id2value;

    auto&& swapFunc = module->getFunction("swap");
    
    id2bb[0] = llvm::BasicBlock::Create(module->getContext(), "0", swapFunc);
}

void draw_codegen(llvm::Module* module, llvm::IRBuilder<>* builder) {
    std::unordered_map<int, llvm::BasicBlock*> id2bb;
    std::unordered_map<int, llvm::Value*> id2value;

    auto&& drawFunc = module->getFunction("draw");
    
    id2bb[0] = llvm::BasicBlock::Create(module->getContext(), "0", drawFunc);
}

void update_codegen(llvm::Module* module, llvm::IRBuilder<>* builder) {
    std::unordered_map<int, llvm::BasicBlock*> id2bb;
    std::unordered_map<int, llvm::Value*> id2value;

    auto&& updateFunc = module->getFunction("update");
    
    id2bb[0] = llvm::BasicBlock::Create(module->getContext(), "0", updateFunc);
}

void run(llvm::Module* module) {
    llvm::ExecutionEngine *ee =
        llvm::EngineBuilder(std::unique_ptr<llvm::Module>(module)).create();

    ee->InstallLazyFunctionCreator([&](const std::string &fnName) -> void * {
    if (fnName == "dr_init_window") {
        return reinterpret_cast<void *>(dr_init_window);
    }
    if (fnName == "dr_put_pixel") {
        return reinterpret_cast<void *>(dr_put_pixel);
    }
    if (fnName == "dr_flush") {
        return reinterpret_cast<void *>(dr_flush);
    }
    if (fnName == "dr_rand") {
        return reinterpret_cast<void *>(dr_rand);
    }
    return nullptr;
    });

    ee->finalizeObject();
    std::vector<llvm::GenericValue> noargs;
    auto&& mainFunc = module->getFunction("main");
    ee->runFunction(mainFunc, noargs);
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
    run(module);

    return 0;
}
