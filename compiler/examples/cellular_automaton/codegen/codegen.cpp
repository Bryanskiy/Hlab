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

    funcType = llvm::FunctionType::get(
        builder->getInt32Ty(), 
        {
            builder->getInt32Ty(), 
            builder->getInt32Ty(), 
            builder->getInt32Ty()
        }, 
        false
    );
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
    auto&& current_surf = module->getGlobalVariable("current_surf");
    id2value[15] = builder->CreateGEP(
        current_surf->getValueType(),
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
    id2value[21] = builder->CreateNSWAdd(id2value[20], llvm::ConstantInt::get(builder->getInt32Ty(), 1));
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
    builder->SetInsertPoint(id2bb[23]);
    id2value[24] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[25] = builder->CreateNSWAdd(id2value[24], llvm::ConstantInt::get(builder->getInt32Ty(), 1));
    builder->CreateStore(id2value[25], id2value[1]);
    builder->CreateBr(id2bb[3]);

    // 26:                                               ; preds = %3
    // ret void
    builder->SetInsertPoint(id2bb[26]);
    builder->CreateRetVoid();
}

void update_codegen(llvm::Module* module, llvm::IRBuilder<>* builder) {
    std::unordered_map<int, llvm::BasicBlock*> id2bb;
    std::unordered_map<int, llvm::Value*> id2value;

    auto&& updateFunc = module->getFunction("update");
    
    id2bb[0] = llvm::BasicBlock::Create(module->getContext(), "0", updateFunc);
    id2bb[7] = llvm::BasicBlock::Create(module->getContext(), "7", updateFunc);
    id2bb[10] = llvm::BasicBlock::Create(module->getContext(), "10", updateFunc);
    id2bb[11] = llvm::BasicBlock::Create(module->getContext(), "11", updateFunc);
    id2bb[14] = llvm::BasicBlock::Create(module->getContext(), "14", updateFunc);
    id2bb[24] = llvm::BasicBlock::Create(module->getContext(), "24", updateFunc);
    id2bb[25] = llvm::BasicBlock::Create(module->getContext(), "25", updateFunc);
    id2bb[28] = llvm::BasicBlock::Create(module->getContext(), "28", updateFunc);
    id2bb[36] = llvm::BasicBlock::Create(module->getContext(), "36", updateFunc);
    id2bb[38] = llvm::BasicBlock::Create(module->getContext(), "38", updateFunc);
    id2bb[40] = llvm::BasicBlock::Create(module->getContext(), "40", updateFunc);
    id2bb[48] = llvm::BasicBlock::Create(module->getContext(), "48", updateFunc);
    id2bb[51] = llvm::BasicBlock::Create(module->getContext(), "51", updateFunc);
    id2bb[52] = llvm::BasicBlock::Create(module->getContext(), "52", updateFunc);
    id2bb[55] = llvm::BasicBlock::Create(module->getContext(), "55", updateFunc);
    // %1 = alloca i32, align 4
    // %2 = alloca i32, align 4
    // %3 = alloca i32, align 4
    // %4 = alloca i32, align 4
    // %5 = alloca i32, align 4
    // %6 = alloca i32, align 4
    // store i32 0, i32* %1, align 4
    // br label %7
    builder->SetInsertPoint(id2bb[0]);
    for(int i = 1; i <= 6; ++i) {
        id2value[i] = builder->CreateAlloca(builder->getInt32Ty());
    }
    builder->CreateStore(llvm::ConstantInt::get(builder->getInt32Ty(), 0), id2value[1]);
    builder->CreateBr(id2bb[7]);

    // 7:                                                ; preds = %52, %0
    // %8 = load i32, i32* %1, align 4
    // %9 = icmp slt i32 %8, 600
    // br i1 %9, label %10, label %55
    builder->SetInsertPoint(id2bb[7]);
    id2value[8] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[9] = builder->CreateICmpSLT(id2value[8], llvm::ConstantInt::get(builder->getInt32Ty(), 600));
    builder->CreateCondBr(id2value[9], id2bb[10], id2bb[55]);

    // 10:                                               ; preds = %7
    // store i32 0, i32* %2, align 4
    // br label %11
    builder->SetInsertPoint(id2bb[10]);
    builder->CreateStore(llvm::ConstantInt::get(builder->getInt32Ty(), 0), id2value[2]);
    builder->CreateBr(id2bb[11]);

    // 11:                                               ; preds = %48, %10
    // %12 = load i32, i32* %2, align 4
    // %13 = icmp slt i32 %12, 400
    // br i1 %13, label %14, label %51
    builder->SetInsertPoint(id2bb[11]);
    id2value[12] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);
    id2value[13] = builder->CreateICmpSLT(id2value[12], llvm::ConstantInt::get(builder->getInt32Ty(), 400));
    builder->CreateCondBr(id2value[13], id2bb[14], id2bb[51]);

    // 14:                                               ; preds = %11
    // %15 = load i32, i32* %1, align 4
    // %16 = sext i32 %15 to i64
    // %17 = getelementptr inbounds [600 x [400 x i32]], [600 x [400 x i32]]* @current_surf, i64 0, i64 %16
    // %18 = load i32, i32* %2, align 4
    // %19 = sext i32 %18 to i64
    // %20 = getelementptr inbounds [400 x i32], [400 x i32]* %17, i64 0, i64 %19
    // %21 = load i32, i32* %20, align 4
    // store i32 %21, i32* %3, align 4
    // %22 = load i32, i32* %3, align 4
    // %23 = icmp eq i32 %22, 0
    // br i1 %23, label %24, label %25
    builder->SetInsertPoint(id2bb[14]);
    id2value[15] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[16] = builder->CreateSExt(id2value[15], builder->getInt64Ty());
    auto&& current_surf = module->getGlobalVariable("current_surf");
    id2value[17] = builder->CreateGEP(
        current_surf->getValueType(),
        current_surf,
        {        
            llvm::ConstantInt::get(builder->getInt64Ty(), 0),
            id2value[16]
        }
    );
    id2value[18] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);
    id2value[19] = builder->CreateSExt(id2value[18], builder->getInt64Ty());
    id2value[20] = builder->CreateGEP(
        llvm::ArrayType::get(builder->getInt32Ty(), 400),
        id2value[17],
        {
            llvm::ConstantInt::get(builder->getInt64Ty(), 0),
            id2value[19] 
        }
    );
    id2value[21] = builder->CreateLoad(builder->getInt32Ty(), id2value[20]);
    builder->CreateStore(id2value[21], id2value[3]);
    id2value[22] = builder->CreateLoad(builder->getInt32Ty(), id2value[3]);
    id2value[23] = builder->CreateICmpEQ(id2value[22], llvm::ConstantInt::get(builder->getInt32Ty(), 0));
    builder->CreateCondBr(id2value[23], id2bb[24], id2bb[25]);

    // 24:                                               ; preds = %14
    // br label %28
    builder->SetInsertPoint(id2bb[24]);
    builder->CreateBr(id2bb[28]);

    // 25:                                               ; preds = %14
    // %26 = load i32, i32* %3, align 4
    // %27 = sub nsw i32 %26, 1
    // br label %28
    builder->SetInsertPoint(id2bb[25]);
    id2value[26] = builder->CreateLoad(builder->getInt32Ty(), id2value[3]);
    id2value[27] = builder->CreateNSWSub(id2value[26], llvm::ConstantInt::get(builder->getInt32Ty(), 1));
    builder->CreateBr(id2bb[28]); 

    // 28:                                               ; preds = %25, %24
    // %29 = phi i32 [ 15, %24 ], [ %27, %25 ]
    // store i32 %29, i32* %4, align 4
    // %30 = load i32, i32* %1, align 4
    // %31 = load i32, i32* %2, align 4
    // %32 = load i32, i32* %4, align 4
    // %33 = call i32 @neighbors_count(i32 noundef %30, i32 noundef %31, i32 noundef %32)
    // store i32 %33, i32* %5, align 4
    // %34 = load i32, i32* %5, align 4
    // %35 = icmp sge i32 %34, 1
    // br i1 %35, label %36, label %38
    builder->SetInsertPoint(id2bb[28]);
    auto&& phiNode = builder->CreatePHI(builder->getInt32Ty(), 2);
    phiNode->addIncoming(llvm::ConstantInt::get(builder->getInt32Ty(), 15), id2bb[24]);
    phiNode->addIncoming(id2value[27], id2bb[25]);
    id2value[29] = phiNode;
    builder->CreateStore(id2value[29], id2value[4]);
    id2value[30] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[31] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);
    id2value[32] = builder->CreateLoad(builder->getInt32Ty(), id2value[4]);
    auto&& neighborsCountFunc = module->getFunction("neighbors_count");
    id2value[33] = builder->CreateCall(
        neighborsCountFunc->getFunctionType(),
        neighborsCountFunc,
        {
            id2value[30],
            id2value[31],
            id2value[32],
        });
    builder->CreateStore(id2value[33], id2value[5]);
    id2value[34] = builder->CreateLoad(builder->getInt32Ty(), id2value[5]);
    id2value[35] = builder->CreateICmpSGE(id2value[34], llvm::ConstantInt::get(builder->getInt32Ty(), 1));
    builder->CreateCondBr(id2value[35], id2bb[36], id2bb[38]);
    // 36:                                               ; preds = %28
    // %37 = load i32, i32* %4, align 4
    // store i32 %37, i32* %6, align 4
    // br label %40
    builder->SetInsertPoint(id2bb[36]);
    id2value[37] = builder->CreateLoad(builder->getInt32Ty(), id2value[4]);
    builder->CreateStore(id2value[37], id2value[6]);
    builder->CreateBr(id2bb[40]);

    // 38:                                               ; preds = %28
    // %39 = load i32, i32* %3, align 4
    // store i32 %39, i32* %6, align 4
    // br label %40
    builder->SetInsertPoint(id2bb[38]);
    id2value[39] = builder->CreateLoad(builder->getInt32Ty(), id2value[3]);
    builder->CreateStore(id2value[39], id2value[6]);
    builder->CreateBr(id2bb[40]);

    // 40:                                               ; preds = %38, %36
    // %41 = load i32, i32* %6, align 4
    // %42 = load i32, i32* %1, align 4
    // %43 = sext i32 %42 to i64
    // %44 = getelementptr inbounds [600 x [400 x i32]], [600 x [400 x i32]]* @tmp_surf, i64 0, i64 %43
    // %45 = load i32, i32* %2, align 4
    // %46 = sext i32 %45 to i64
    // %47 = getelementptr inbounds [400 x i32], [400 x i32]* %44, i64 0, i64 %46
    // store i32 %41, i32* %47, align 4
    // br label %48
    builder->SetInsertPoint(id2bb[40]);
    id2value[41] = builder->CreateLoad(builder->getInt32Ty(), id2value[6]);
    id2value[42] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[43] = builder->CreateSExt(id2value[42], builder->getInt64Ty());
    auto&& tmp_surf = module->getGlobalVariable("tmp_surf");
    id2value[44] = builder->CreateGEP(
        tmp_surf->getValueType(),
        tmp_surf,
        {        
            llvm::ConstantInt::get(builder->getInt64Ty(), 0),
            id2value[43]
        }
    );
    id2value[45] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);
    id2value[46] = builder->CreateSExt(id2value[45], builder->getInt64Ty());
    id2value[47] = builder->CreateGEP(
        llvm::ArrayType::get(builder->getInt32Ty(), 400),
        id2value[44],
        {
            llvm::ConstantInt::get(builder->getInt64Ty(), 0),
            id2value[46] 
        }
    );
    builder->CreateStore(id2value[41], id2value[47]);
    builder->CreateBr(id2bb[48]);

    // 48:                                               ; preds = %40
    // %49 = load i32, i32* %2, align 4
    // %50 = add nsw i32 %49, 1
    // store i32 %50, i32* %2, align 4
    // br label %11, !llvm.loop !9
    builder->SetInsertPoint(id2bb[48]);
    id2value[49] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);       
    id2value[50] = builder->CreateNSWAdd(id2value[49], llvm::ConstantInt::get(builder->getInt32Ty(), 1));
    builder->CreateStore(id2value[50], id2value[2]);
    builder->CreateBr(id2bb[11]);
    
    // 51:                                               ; preds = %11
    // br label %52
    builder->SetInsertPoint(id2bb[51]);
    builder->CreateBr(id2bb[52]); 

    // 52:                                               ; preds = %51
    // %53 = load i32, i32* %1, align 4
    // %54 = add nsw i32 %53, 1
    // store i32 %54, i32* %1, align 4
    // br label %7, !llvm.loop !10
    builder->SetInsertPoint(id2bb[52]);
    id2value[53] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[54] = builder->CreateNSWAdd(id2value[53], llvm::ConstantInt::get(builder->getInt32Ty(), 1));
    builder->CreateStore(id2value[54], id2value[1]);
    builder->CreateBr(id2bb[7]); 

    // 55:                                               ; preds = %7
    // ret void
    builder->SetInsertPoint(id2bb[55]);
    builder->CreateRetVoid();
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
    id2bb[3] = llvm::BasicBlock::Create(module->getContext(), "3", drawFunc);
    id2bb[6] = llvm::BasicBlock::Create(module->getContext(), "6", drawFunc);    
    id2bb[7] = llvm::BasicBlock::Create(module->getContext(), "7", drawFunc);
    id2bb[10] = llvm::BasicBlock::Create(module->getContext(), "10", drawFunc);
    id2bb[20] = llvm::BasicBlock::Create(module->getContext(), "20", drawFunc);
    id2bb[23] = llvm::BasicBlock::Create(module->getContext(), "23", drawFunc);
    id2bb[24] = llvm::BasicBlock::Create(module->getContext(), "24", drawFunc);    
    id2bb[27] = llvm::BasicBlock::Create(module->getContext(), "27", drawFunc);
    // %1 = alloca i32, align 4
    // %2 = alloca i32, align 4
    // store i32 0, i32* %1, align 4
    // br label %3
    builder->SetInsertPoint(id2bb[0]);
    id2value[1] = builder->CreateAlloca(builder->getInt32Ty());
    id2value[2] = builder->CreateAlloca(builder->getInt32Ty());
    builder->CreateStore(llvm::ConstantInt::get(builder->getInt32Ty(), 0), id2value[1]);
    builder->CreateBr(id2bb[3]);

    // 3:                                                ; preds = %24, %0
    // %4 = load i32, i32* %1, align 4
    // %5 = icmp slt i32 %4, 600
    // br i1 %5, label %6, label %27
    builder->SetInsertPoint(id2bb[3]);
    id2value[4] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[5] = builder->CreateICmpSLT(id2value[4], llvm::ConstantInt::get(builder->getInt32Ty(), 600));
    builder->CreateCondBr(id2value[5], id2bb[6], id2bb[27]);

    // 6:                                                ; preds = %3
    // store i32 0, i32* %2, align 4
    // br label %7
    builder->SetInsertPoint(id2bb[6]);
    builder->CreateStore(llvm::ConstantInt::get(builder->getInt32Ty(), 0), id2value[2]);
    builder->CreateBr(id2bb[7]);

    // 7:                                                ; preds = %20, %6
    // %8 = load i32, i32* %2, align 4
    // %9 = icmp slt i32 %8, 400
    // br i1 %9, label %10, label %23
    builder->SetInsertPoint(id2bb[7]);
    id2value[8] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);
    id2value[9] = builder->CreateICmpSLT(id2value[8], llvm::ConstantInt::get(builder->getInt32Ty(), 400));
    builder->CreateCondBr(id2value[9], id2bb[10], id2bb[23]);

    // 10:                                               ; preds = %7
    // %11 = load i32, i32* %1, align 4
    // %12 = load i32, i32* %2, align 4
    // %13 = load i32, i32* %1, align 4
    // %14 = sext i32 %13 to i64
    // %15 = getelementptr inbounds [600 x [400 x i32]], [600 x [400 x i32]]* @current_surf, i64 0, i64 %14
    // %16 = load i32, i32* %2, align 4
    // %17 = sext i32 %16 to i64
    // %18 = getelementptr inbounds [400 x i32], [400 x i32]* %15, i64 0, i64 %17
    // %19 = load i32, i32* %18, align 4
    // call void @dr_put_pixel(i32 noundef %11, i32 noundef %12, i32 noundef %19)
    // br label %20
    builder->SetInsertPoint(id2bb[10]);
    id2value[11] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[12] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);      
    id2value[13] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[14] = builder->CreateSExt(id2value[13], builder->getInt64Ty());
    auto&& current_surf = module->getGlobalVariable("current_surf");
    id2value[15] = builder->CreateGEP(
        current_surf->getValueType(),
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
    id2value[19] = builder->CreateLoad(builder->getInt32Ty(), id2value[18]);
    auto&& drPutPixelFunc = module->getFunction("dr_put_pixel");
    builder->CreateCall(
        drPutPixelFunc->getFunctionType(),
        drPutPixelFunc,
        {
            id2value[11],
            id2value[12],
            id2value[19],
        });
    builder->CreateBr(id2bb[20]);

    // 20:                                               ; preds = %10
    // %21 = load i32, i32* %2, align 4
    // %22 = add nsw i32 %21, 1
    // store i32 %22, i32* %2, align 4
    // br label %7, !llvm.loop !15
    builder->SetInsertPoint(id2bb[20]);
    id2value[21] = builder->CreateLoad(builder->getInt32Ty(), id2value[2]);
    id2value[22] = builder->CreateNSWAdd(id2value[21], llvm::ConstantInt::get(builder->getInt32Ty(), 1));
    builder->CreateStore(id2value[22], id2value[2]);
    builder->CreateBr(id2bb[7]);

    // 23:                                               ; preds = %7
    // br label %24
    builder->SetInsertPoint(id2bb[23]);
    builder->CreateBr(id2bb[24]);

    // 24:                                               ; preds = %23
    // %25 = load i32, i32* %1, align 4
    // %26 = add nsw i32 %25, 1
    // store i32 %26, i32* %1, align 4
    // br label %3, !llvm.loop !16
    builder->SetInsertPoint(id2bb[24]);
    id2value[25] = builder->CreateLoad(builder->getInt32Ty(), id2value[1]);
    id2value[26] = builder->CreateNSWAdd(id2value[25], llvm::ConstantInt::get(builder->getInt32Ty(), 1));
    builder->CreateStore(id2value[26], id2value[1]);
    builder->CreateBr(id2bb[3]);

    // 27:                                               ; preds = %3
    // call void (...) @dr_flush()
    // ret void
    builder->SetInsertPoint(id2bb[27]);
    auto&& drFlushFunc = module->getFunction("dr_flush");
    builder->CreateCall(drFlushFunc->getFunctionType(), drFlushFunc);
    builder->CreateRetVoid();
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
    update_codegen(module, &builder);
    draw_codegen(module, &builder);

    dump_codegen(module);
    // run(module);

    return 0;
}
