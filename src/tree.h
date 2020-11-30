 #ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"

enum NodeType
{
    NODE_PROG,
    NODE_MAIN,
    NODE_STMT, 
    NODE_EXPR,
    NODE_TYPE,
    NODE_CONST,
    NODE_VAR,
    NODE_OP 
};

enum StmtType
{
    STMT_SKIP,
    STMT_DECL,
    STMT_IF,
    STMT_ELSE,
    STMT_WHILE,
    STMT_FOR,
    STMT_SCANF,
    STMT_PRINTF,
    STMT_ASSIGN_MINUS,
    STMT_ASSIGN_PLUS,
    STMT_ASSIGN_MOD,
    STMT_ASSIGN_DIVIDE,
    STMT_ASSIGN_MULTI,
    STMT_ASSIGN,
    STMT_FUN_DEC,
    STMT_FUN_DEF,
    STMT_FUN_CALL,
    STMT_RETURN,
    STMT_DOMAIN,
};

enum OperatorType
{
    OP_EQU, 
    OP_PLUS,
    OP_MINUS,
    OP_MULTI,
    OP_DIVIDE,
    OP_MOD,
    OP_AND,
    OP_OR,
    OP_NOT,
    OP_PLUSPLUS,
    OP_MINUSMINUS,
    OP_NEQU,
    OP_GREATER,
    OP_LESS,
    OP_GEQU,
    OP_LEQU,
    OP_LOGIC_AND,
    OP_LOGIC_OR,
    OP_LOGIC_NOT
};

enum Vartype
{
    VAR_INT,
    VAR_VOID,
    VAR_BOOL,
    VAR_CHAR,
    VAR_STRING

};

struct DomainTreeNode
{
public:
    int area;
    int level;
    DomainTreeNode *child=nullptr;
    DomainTreeNode *sibling=nullptr;
    DomainTreeNode *father=nullptr;
    void addChild(DomainTreeNode*);
    void addSibling(DomainTreeNode*sibling,DomainTreeNode*father);
    void printDomain(DomainTreeNode *);
    DomainTreeNode();
    
};
struct TreeNode 
{
public:
    int nodeID;  // 用于作业的序号输出
    int lineno;
    DomainTreeNode scope; //映射到作用域的树结点
    NodeType nodeType;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo(TreeNode*);
    void printChildrenId(TreeNode*);

    void printAST(TreeNode*); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    void printSpecialInfo();

    void genNodeId(); //从根节点开始逐个赋id

public:
    OperatorType optype;  // 如果是表达式
    Type *type;  // 变量、类型、表达式结点，有类型。
    StmtType stype;
    int int_val;
    char ch_val;
    bool b_val;
    double d_val;
    string str_val;
    string var_name;
public:
    static string nodeType2String (NodeType type);
    static string opType2String (OperatorType type);
    static string sType2String (StmtType type);
public: 
    TreeNode(int lno, NodeType type);

};

TreeNode *expNode(TreeNode*, TreeNode*, TreeNode*);
TreeNode *forNode(int, TreeNode*, TreeNode*, TreeNode*, TreeNode*);

#endif