// =============================================================================
// json_output.cpp — Serialización del stream de tokens y del AST a JSON
// =============================================================================

#include "json_output.h"
#include "ast.h"
#include "scanner.h"
#include "token.h"
#include <sstream>

// -----------------------------------------------------------------------------
// jsonEscape — escapa caracteres especiales para JSON
// -----------------------------------------------------------------------------
std::string jsonEscape(const std::string &s) {
  std::string out;
  out.reserve(s.size() + 8);
  for (char c : s) {
    switch (c) {
    case '"':  out += "\\\""; break;
    case '\\': out += "\\\\"; break;
    case '\n': out += "\\n";  break;
    case '\r': out += "\\r";  break;
    case '\t': out += "\\t";  break;
    default:
      if (static_cast<unsigned char>(c) < 0x20) {
        char buf[8];
        snprintf(buf, sizeof(buf), "\\u%04x", c);
        out += buf;
      } else {
        out += c;
      }
    }
  }
  return out;
}

// -----------------------------------------------------------------------------
// tokenTypeCode — nombre corto del tipo de token (para el panel de tokens)
// -----------------------------------------------------------------------------
static std::string tokenTypeCode(Token::Type t) {
  switch (t) {
  case Token::PLUS: return "PLUS";           case Token::MINUS: return "MINUS";
  case Token::MUL: return "MUL";             case Token::DIV: return "DIV";
  case Token::POW: return "POW";             case Token::LPAREN: return "LPAREN";
  case Token::RPAREN: return "RPAREN";       case Token::LBRACKET: return "LBRACKET";
  case Token::RBRACKET: return "RBRACKET";   case Token::LBRACE: return "LBRACE";
  case Token::RBRACE: return "RBRACE";       case Token::SEMICOL: return "SEMICOL";
  case Token::COLON: return "COLON";         case Token::COMA: return "COMA";
  case Token::DOT: return "DOT";             case Token::LE: return "LT";
  case Token::GT: return "GT";               case Token::LEQ: return "LEQ";
  case Token::GEQ: return "GEQ";             case Token::EQ: return "EQ";
  case Token::NE: return "NE";               case Token::AND: return "AND";
  case Token::AMP: return "AMP";             case Token::OR: return "OR";
  case Token::NOT: return "NOT";             case Token::ASSIGN: return "ASSIGN";
  case Token::NUM: return "NUM";             case Token::FLOAT_LIT: return "FLOAT_LIT";
  case Token::TRUE: return "TRUE";           case Token::FALSE: return "FALSE";
  case Token::STRING_LIT: return "STRING_LIT";
  case Token::ID: return "ID";               case Token::SQRT: return "SQRT";
  case Token::PRINT: return "PRINT";         case Token::TEMPLATE: return "TEMPLATE";
  case Token::AUTO: return "AUTO";           case Token::IF: return "IF";
  case Token::THEN: return "THEN";           case Token::ELSE: return "ELSE";
  case Token::ENDIF: return "ENDIF";         case Token::WHILE: return "WHILE";
  case Token::DOWHILE: return "DOWHILE";     case Token::DO: return "DO";
  case Token::ENDWHILE: return "ENDWHILE";   case Token::ENDDO: return "ENDDO";
  case Token::BREAK: return "BREAK";         case Token::SWITCH: return "SWITCH";
  case Token::CASE: return "CASE";           case Token::DEFAULT: return "DEFAULT";
  case Token::NEW: return "NEW";             case Token::ENDSWITCH: return "ENDSWITCH";
  case Token::VAR: return "VAR";             case Token::STRUCT: return "STRUCT";
  case Token::FUN: return "FUN";             case Token::ENDFUN: return "ENDFUN";
  case Token::RETURN: return "RETURN";       case Token::ERR: return "ERR";
  case Token::END: return "END";
  }
  return "DESCONOCIDO";
}

// -----------------------------------------------------------------------------
// tokensToJson — tokeniza toda la entrada y produce el arreglo JSON
// -----------------------------------------------------------------------------
std::string tokensToJson(const std::string &input, std::string &lexError) {
  lexError.clear();
  Scanner sc(input.c_str());
  std::ostringstream os;
  os << "[";
  bool primero = true;
  while (true) {
    Token *t = sc.nextToken();
    if (t->type == Token::ERR) {
      lexError = "Error léxico [línea " + std::to_string(t->line) + ", col " +
                 std::to_string(t->col) + "]: carácter no reconocido '" +
                 t->text + "'";
      delete t;
      break;
    }
    if (t->type == Token::END) {
      delete t;
      break;
    }
    if (!primero) os << ",";
    primero = false;
    os << "{\"type\":\"" << tokenTypeCode(t->type) << "\",\"text\":\""
       << jsonEscape(t->text) << "\",\"line\":" << t->line
       << ",\"col\":" << t->col << "}";
    delete t;
  }
  os << "]";
  return os.str();
}

// =============================================================================
// Serialización del AST (forma genérica: kind / label / line / col / children)
// =============================================================================

static std::string expToJson(Exp *e);
static std::string stmToJson(Stm *s);
static std::string bodyToJson(Body *b);
static std::string varDecToJson(VarDec *vd);

// node — arma un objeto JSON de nodo; 'children' ya viene como arreglo JSON.
static std::string node(const std::string &kind, const std::string &label,
                        int line, int col, const std::string &children = "[]") {
  return "{\"kind\":\"" + kind + "\",\"label\":\"" + jsonEscape(label) +
         "\",\"line\":" + std::to_string(line) + ",\"col\":" +
         std::to_string(col) + ",\"children\":" + children + "}";
}

// opName — símbolo legible de un operador binario
static std::string opName(BinaryOp op) {
  switch (op) {
  case PLUS_OP: return "+";   case MINUS_OP: return "-";
  case MUL_OP: return "*";    case DIV_OP: return "/";
  case POW_OP: return "**";   case LE_OP: return "<";
  case GT_OP: return ">";     case LEQ_OP: return "<=";
  case GEQ_OP: return ">=";   case EQ_OP: return "==";
  case NE_OP: return "!=";    case AND_OP: return "&&";
  case OR_OP: return "||";
  }
  return "?";
}

// arr — junta una lista de nodos ya serializados en un arreglo JSON
static std::string arr(const std::vector<std::string> &items) {
  std::string out = "[";
  for (size_t i = 0; i < items.size(); ++i) {
    if (i) out += ",";
    out += items[i];
  }
  out += "]";
  return out;
}

static std::string expToJson(Exp *e) {
  if (!e) return "null";
  int ln = e->line, cl = e->col;

  if (auto n = dynamic_cast<NumberExp *>(e))
    return node("NumberExp", std::to_string(n->value), ln, cl);
  if (auto f = dynamic_cast<FloatExp *>(e)) {
    std::ostringstream v; v << f->value;
    return node("FloatExp", v.str(), ln, cl);
  }
  if (auto s = dynamic_cast<StringExp *>(e))
    return node("StringExp", "\"" + s->value + "\"", ln, cl);
  if (auto id = dynamic_cast<IdExp *>(e))
    return node("IdExp", id->value, ln, cl);
  if (auto b = dynamic_cast<BinaryExp *>(e))
    return node("BinaryExp", opName(b->op), ln, cl,
                arr({expToJson(b->left), expToJson(b->right)}));
  if (auto u = dynamic_cast<UnaryExp *>(e))
    return node("UnaryExp", "!", ln, cl, arr({expToJson(u->operand)}));
  if (auto a = dynamic_cast<AddressExp *>(e))
    return node("AddressExp", "&", ln, cl, arr({expToJson(a->e)}));
  if (auto d = dynamic_cast<DereferenceExp *>(e))
    return node("DereferenceExp", "*", ln, cl, arr({expToJson(d->e)}));
  if (auto fc = dynamic_cast<FcallExp *>(e)) {
    std::vector<std::string> hijos;
    for (auto arg : fc->argumentos) hijos.push_back(expToJson(arg));
    return node("FcallExp", fc->nombre + "(...)", ln, cl, arr(hijos));
  }
  if (auto ix = dynamic_cast<IndexExp *>(e))
    return node("IndexExp", ix->name + "[ ]", ln, cl, arr({expToJson(ix->index)}));
  if (auto mx = dynamic_cast<MatrixExp *>(e))
    return node("MatrixExp", mx->name + "[ ][ ]", ln, cl,
                arr({expToJson(mx->row), expToJson(mx->col)}));
  if (auto fe = dynamic_cast<FieldExp *>(e))
    return node("FieldExp", fe->object + "." + fe->field, ln, cl);
  if (auto ls = dynamic_cast<ExpListSize *>(e))
    return node("NewArray", "new " + ls->type + "[ ]", ln, cl,
                arr({expToJson(ls->size)}));
  if (auto lv = dynamic_cast<ExpListVals *>(e)) {
    std::vector<std::string> hijos;
    for (auto v : lv->values) hijos.push_back(expToJson(v));
    return node("NewStruct", "new " + lv->type + "{ }", ln, cl, arr(hijos));
  }
  if (auto ms = dynamic_cast<ExpMatrixSize *>(e))
    return node("NewMatrix", "new " + ms->type + "[ ][ ]", ln, cl,
                arr({expToJson(ms->rows), expToJson(ms->cols)}));
  if (auto mv = dynamic_cast<ExpMatrixVals *>(e)) {
    std::vector<std::string> hijos = {expToJson(mv->rows), expToJson(mv->cols)};
    for (auto v : mv->values) hijos.push_back(expToJson(v));
    return node("NewMatrixVals", "new " + mv->type + "[ ][ ]{ }", ln, cl,
                arr(hijos));
  }
  return node("Exp", "?", ln, cl);
}

static std::string varDecToJson(VarDec *vd) {
  if (!vd) return "null";
  std::string label = vd->type + " ";
  bool primero = true;
  for (auto &v : vd->vars) {
    if (!primero) label += ", ";
    primero = false;
    label += v;
  }
  std::vector<std::string> hijos;
  for (auto init : vd->inits)
    if (init) hijos.push_back(expToJson(init));
  return node("VarDec", label, vd->line, vd->col, arr(hijos));
}

static std::string stmToJson(Stm *s) {
  if (!s) return "null";
  int ln = s->line, cl = s->col;

  if (auto a = dynamic_cast<AssignStm *>(s))
    return node("AssignStm", "=", ln, cl,
                arr({expToJson(a->target), expToJson(a->e)}));
  if (auto p = dynamic_cast<PrintStm *>(s))
    return node("PrintStm", "print", ln, cl, arr({expToJson(p->e)}));
  if (auto r = dynamic_cast<ReturnStm *>(s))
    return node("ReturnStm", "return", ln, cl, arr({expToJson(r->e)}));
  if (auto i = dynamic_cast<IfStm *>(s)) {
    std::vector<std::string> hijos = {expToJson(i->condition),
                                      bodyToJson(i->then)};
    if (i->els) hijos.push_back(bodyToJson(i->els));
    return node("IfStm", i->els ? "if / else" : "if", ln, cl, arr(hijos));
  }
  if (auto w = dynamic_cast<WhileStm *>(s))
    return node("WhileStm", "while", ln, cl,
                arr({expToJson(w->condition), bodyToJson(w->b)}));
  if (auto d = dynamic_cast<DoWhileStm *>(s))
    return node("DoWhileStm", "do / while", ln, cl,
                arr({bodyToJson(d->b), expToJson(d->condition)}));
  if (dynamic_cast<BreakStm *>(s))
    return node("BreakStm", "break", ln, cl);
  if (auto sw = dynamic_cast<SwitchStm *>(s)) {
    std::vector<std::string> hijos = {expToJson(sw->e)};
    for (auto c : sw->cases) {
      std::vector<std::string> cuerpo;
      for (auto st : c->body) cuerpo.push_back(stmToJson(st));
      hijos.push_back(node("CaseStm", "case " + std::to_string(c->value), 0, 0,
                           arr(cuerpo)));
    }
    if (!sw->default_body.empty()) {
      std::vector<std::string> cuerpo;
      for (auto st : sw->default_body) cuerpo.push_back(stmToJson(st));
      hijos.push_back(node("DefaultStm", "default", 0, 0, arr(cuerpo)));
    }
    return node("SwitchStm", "switch", ln, cl, arr(hijos));
  }
  if (auto ex = dynamic_cast<ExprStm *>(s))
    return node("ExprStm", "expr;", ln, cl, arr({expToJson(ex->e)}));
  return node("Stm", "?", ln, cl);
}

static std::string bodyToJson(Body *b) {
  if (!b) return "null";
  std::vector<std::string> hijos;
  for (auto d : b->declarations) hijos.push_back(varDecToJson(d));
  for (auto s : b->StmList) hijos.push_back(stmToJson(s));
  return node("Body", "cuerpo", 0, 0, arr(hijos));
}

std::string astToJson(Program *p) {
  if (!p) return "null";
  std::vector<std::string> hijos;

  for (auto sd : p->sdlist) {
    std::vector<std::string> campos;
    for (auto f : sd->fields) campos.push_back(varDecToJson(f));
    hijos.push_back(node("StructDec", "struct " + sd->name, sd->line, sd->col,
                         arr(campos)));
  }
  for (auto vd : p->vdlist) hijos.push_back(varDecToJson(vd));
  for (auto fd : p->fdlist) {
    std::string firma = fd->tipo + " " + fd->nombre + "(";
    for (size_t i = 0; i < fd->Pnombres.size(); ++i) {
      if (i) firma += ", ";
      firma += fd->Ptipos[i] + " " + fd->Pnombres[i];
    }
    firma += ")";
    if (fd->isTemplate) firma = "template<" + fd->templateParam + "> " + firma;
    hijos.push_back(node("FunDec", firma, fd->line, fd->col,
                         arr({bodyToJson(fd->cuerpo)})));
  }
  return node("Program", "Programa", 0, 0, arr(hijos));
}
