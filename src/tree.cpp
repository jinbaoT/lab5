#include "tree.h"
static int TreeNodeID = 0;
static int DomainID=0;

void TreeNode::addChild(TreeNode *child)
{
    if (this->child == nullptr)
        this->child = child;
    else{
        this->child->addSibling(child);
    }
}

void TreeNode::addSibling(TreeNode *sibling)
{
    if (this->sibling == nullptr)
        this->sibling = sibling;
    else
    {
        TreeNode *tmp = this->sibling;
        while (tmp->sibling != nullptr)
            tmp = tmp->sibling;
        tmp->sibling = sibling;
    }
}

TreeNode::TreeNode(int lineno, NodeType type)
{
    this->lineno = lineno;
    this->nodeType = type;
    genNodeId();
}

void TreeNode::genNodeId()
{
    this->nodeID = TreeNodeID;
    TreeNodeID += 1;
}

void TreeNode::printNodeInfo(TreeNode *t)
{
    string print_type = "";
    string detail = "";
    string childNodeID = "Children: ";
    if (t->nodeType == NODE_STMT)
    {
        detail = sType2String(t->stype);
    }
    else if (t->nodeType == NODE_EXPR)
    {
        detail = "OP: " + opType2String(t->optype);
    }
    else if (t->nodeType == NODE_TYPE){
        detail = t->type->getTypeInfo();
    }
    else if (t->nodeType == NODE_VAR){
        detail = "var name: " + t->var_name;
    }
    else if(t->nodeType == NODE_CONST){
        string t_type_str = t->type->getTypeInfo();
        if(t_type_str=="int"){
            detail = to_string(t->int_val);
        }
        else if (t_type_str == "string")
        {
            detail = str_val;
        }
        else if (t_type_str == "bool")
        {
            detail = to_string(t->b_val);
        }
        else if (t_type_str == "double")
        {
            detail = to_string(t->d_val);
        }
        else if(t_type_str == "char"){
            detail = to_string(t->ch_val);
        }
       detail = t_type_str+": "+detail;
    }

    print_type = nodeType2String(t->nodeType);

    cout << "lno@" << t->lineno << "  "
         << "@" << t->nodeID << "  " << print_type << "  " << detail << "  children:[";
    printChildrenId(t);
    cout<<"]  "<<endl;
    //cout << "]  " <<"SCOPE:" << t->scope->area <<endl;
    // string t = "";
    // cout << "  " << setw(10) << t << endl;
}

void TreeNode::printChildrenId(TreeNode *t)
{
    if (t->child != nullptr)
    {
        cout << "@" << t->child->nodeID << " ";
        TreeNode *tmp = t->child->sibling;
        while (tmp!= nullptr)
        {
            cout << "@" << tmp->nodeID << " ";
            tmp = tmp->sibling;
        }
    }
}
// 先根递归遍历
void TreeNode::printAST(TreeNode *t)
{
    if(!t)
        return;
    printNodeInfo(t);
    for (TreeNode *t2 = t->child; t2; t2 = t2->sibling)
        printAST(t2);
}

TreeNode * expNode(TreeNode *op, TreeNode *operand1, TreeNode *operand2)
{
    TreeNode *opt = op;
    opt->addChild(operand1);
    opt->addChild(operand2);
    return opt;
}

TreeNode *forNode(int lno,TreeNode *exp1, TreeNode *exp2, TreeNode *exp3, TreeNode *stmt){
    TreeNode *node = new TreeNode(lno, NODE_STMT);
    node->stype = STMT_FOR;
    TreeNode* node2 = new TreeNode(lno, NODE_STMT);
    node2->stype = STMT_DOMAIN;
    node2->addChild(exp1);
    node2->addChild(exp2);
    node2->addChild(exp3);
    node2->addChild(stmt);
    node->addChild(node2);
    return node;
}
void DomainTreeNode::addChild(DomainTreeNode*child)
{
    if (this->child == nullptr)
    {   this->child = child;
        this->child->father=this;
    }
    else{
        this->child->addSibling(child,father);
    }
}
void DomainTreeNode::addSibling(DomainTreeNode*sibling,DomainTreeNode*father)
{
    if (this->sibling == nullptr)
    {    this->sibling = sibling;
        this->sibling->father=father;
    }
    else
    {
        DomainTreeNode *tmp = this->sibling;
        while (tmp->sibling != nullptr)
            tmp = tmp->sibling;
        tmp->sibling = sibling;
        tmp->sibling->father=father;
    }
}
void DomainTreeNode::printDomain(DomainTreeNode *t)
{
    if(!t)return;
    cout<<"Domain:"<<t->area<<endl;
    for (DomainTreeNode *i=t->child;i;i=i->sibling)
    printDomain(i);
}
DomainTreeNode::DomainTreeNode()
{
    this->area=DomainID;
    DomainID++;
}
// You can output more info...
void TreeNode::printSpecialInfo()
{
    switch (this->nodeType)
    {
    case NODE_CONST:
        break;
    case NODE_VAR:
        break;
    case NODE_EXPR:
        break;
    case NODE_STMT:
        break;
    case NODE_TYPE:
        break;
    default:
        break;
    }
}

string TreeNode::sType2String(StmtType type)
{
    string displayStype;
    switch (type)
    {
    case STMT_SKIP:
        return "STMT SKIP";
    case STMT_DECL:
        return "STMT DECL";
    case STMT_IF:
        return "STMT IF";
    case STMT_ELSE:
        return "STMT ELSE";
    case STMT_WHILE:
        return "STMT WHILE";
    case STMT_FOR:
        return "STMT FOR";
    case STMT_ASSIGN:
        return "=";
    case STMT_ASSIGN_MINUS:
        return "-=";
    case STMT_ASSIGN_PLUS:
        return "+=";
    case STMT_ASSIGN_MULTI:
        return "*=";
    case STMT_ASSIGN_MOD:
        return "%=";
    case STMT_ASSIGN_DIVIDE:
        return "/=";
    case STMT_FUN_DEC:
        return "STMT FUN DECL";
    case STMT_FUN_DEF:
        return "STMT FUN DEF";
    case STMT_FUN_CALL:
        return "STMT FUN CALL";
    case STMT_RETURN:
        return "STMT RETURN";
    case STMT_SCANF:
        return "scanf";
    case STMT_PRINTF:
        return "printf";
    case STMT_DOMAIN:
        return "STMT DOMAIN";
    default:
        return "???";
        break;
    }
    return displayStype;
}

string TreeNode::nodeType2String(NodeType type)
{
    switch (type)
    {
    case NODE_STMT:
        return "NODE STMT";
    case NODE_EXPR:
        return "NODE EXPR";
    case NODE_PROG:
        return "NODE PROG";
    case NODE_TYPE:
        return "NODE TYPE";
    case NODE_VAR:
        return "NODE VAR";
    case NODE_CONST:
        return "NODE CONST";
    case NODE_OP:
        return "NODE OP";
    case NODE_MAIN:
        return "main";
    default:
        return "???";
        break;
    }
}

string TreeNode::opType2String(OperatorType type)
{
    switch (type)
    {
    case OP_EQU:
        return "==";
        break;
    case OP_PLUS:
        return "+";
    case OP_MINUS:
        return "-";
    case OP_MULTI:
        return "*";
    case OP_DIVIDE:
        return "/";
    case OP_MOD:
        return "%";
    case OP_AND:
        return "&";
    case OP_OR:
        return "|";
    case OP_NOT:
        return "~";
    case OP_PLUSPLUS:
        return "++";
    case OP_MINUSMINUS:
        return "--";
    case OP_NEQU: 
        return "!=";
    case OP_GREATER:
        return ">";
    case OP_LESS:
        return "<";
    case OP_GEQU:
        return ">=";
    case OP_LEQU:
        return "<=";
    case OP_LOGIC_NOT:
        return "!";
    case OP_LOGIC_AND:
        return "&&";
    case OP_LOGIC_OR:
        return "||";
    default:
        return "???";
        break;
    }
}

