#pragma once

#include <iostream>
#include <map>
#include <string>
#include <typeinfo>
#include <vector>
#include <unordered_map>
#include <cstdint>
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

namespace glang {

struct CodeGenCtx {
    CodeGenCtx();
    std::unique_ptr<llvm::LLVMContext> m_context = nullptr;
    std::unique_ptr<llvm::Module> m_module = nullptr;
    std::unique_ptr<llvm::IRBuilder<>> m_builder = nullptr;
};

enum class BinOp {
    /* arithm */
    Plus,
    Minus,
    Div,
    Mod,
    Mult,

    /* logic */
    And,
    Or,
    Equal,
    NotEqual,
    Greater,
    Less,
    GreaterOrEqual,
    LessOrEqual,

    Assign,
};

enum class UnOp {
    /* logical */
    Not,

    /* IO */
    Output,
    Input,
};

struct INode {
    virtual llvm::Value* codegen(CodeGenCtx& ctx) = 0;
    virtual ~INode() {}
};

class I32N : public INode {
public:
    I32N(std::int32_t val) : m_val{val} {}
    std::int32_t get() const { return m_val; }
    llvm::Value* codegen(CodeGenCtx& ctx) override;
private: 
    std::int32_t m_val;
};

class BinOpN : public INode {
public:
    BinOpN(std::shared_ptr<INode> lhs, BinOp op, std::shared_ptr<INode> rhs) : m_lhs{lhs}, m_rhs{rhs}, m_op{op} {}
    llvm::Value* codegen(CodeGenCtx& ctx) override;
private:
    std::shared_ptr<INode> m_lhs, m_rhs;
    BinOp m_op;
};

class UnOpN : public INode {
public:
    UnOpN(UnOp op, std::shared_ptr<INode> val) : m_val{val}, m_op{op} {}
    llvm::Value* codegen(CodeGenCtx& ctx) override;
private:
    std::shared_ptr<INode> m_val;
    UnOp m_op;
};

struct DeclN : public INode {
    virtual llvm::Value* codegen(CodeGenCtx& ctx) override = 0;
};

class DeclVarN : public DeclN {
public:
    llvm::Value* codegen(CodeGenCtx& ctx) override;
    void store(CodeGenCtx& ctx, llvm::Value* val);
private:
    llvm::Value* m_alloca = nullptr;
};

class ScopeN : public INode {
public:
    ScopeN() = default;
    ScopeN(std::shared_ptr<ScopeN> parent) : m_parent{parent} {}

    void insertChild(std::shared_ptr<INode> child) { m_childs.push_back(child); }
    std::shared_ptr<ScopeN> getParent() const { return m_parent; }
    std::shared_ptr<DeclN> getDeclIfVisible(const std::string& name) const;
    void insertDecl(const std::string& name, std::shared_ptr<DeclN> decl) { m_symTable[name] = decl; }
    llvm::Value* codegen(CodeGenCtx& ctx) override;
private:
    std::vector<std::shared_ptr<INode>> m_childs;
    std::shared_ptr<ScopeN> m_parent = nullptr;
    std::unordered_map<std::string, std::shared_ptr<DeclN>> m_symTable;
};

class IfN : public INode {
public:
    IfN(std::shared_ptr<ScopeN> block, std::shared_ptr<INode> condition) : m_block{block}, m_condition{condition} {}
    llvm::Value* codegen(CodeGenCtx& ctx) override;
private:
    std::shared_ptr<ScopeN> m_block;
    std::shared_ptr<INode> m_condition;
};

class WhileN : public INode {
public:
    WhileN(std::shared_ptr<ScopeN> block, std::shared_ptr<INode> condition) : m_block{block}, m_condition{condition} {}
    llvm::Value* codegen(CodeGenCtx& ctx) override;
private:
    std::shared_ptr<ScopeN> m_block;
    std::shared_ptr<INode> m_condition;
};

class FuncDeclN : public DeclN {
public:
    FuncDeclN(const std::string& name, const std::vector<std::string>& argNames = {}) : m_argNames{argNames}, m_name{name} {}
    llvm::Value* codegen(CodeGenCtx& ctx) override;
    const std::vector<std::string>& getArgNames() const { return m_argNames; }
    const std::string& getName() const { return m_name; }
private:
    std::vector<std::string> m_argNames;
    std::string m_name;
};

class FuncN : public INode {
public:
    FuncN(std::shared_ptr<ScopeN> scope, std::shared_ptr<FuncDeclN> header) : m_scope{scope}, m_header{header} {}
    llvm::Value* codegen(CodeGenCtx& ctx) override;
private:
    std::shared_ptr<ScopeN> m_scope;
    std::shared_ptr<FuncDeclN> m_header;
};

} // namespace glang