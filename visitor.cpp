// =============================================================================
// visitor.cpp — Implementación de TypeCheckerVisitor y GenCodeVisitor
// =============================================================================

#include "visitor.h"
#include "ast.h"
#include <algorithm>
#include <functional>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <unordered_map>
#include <unordered_set>

// -----------------------------------------------------------------------------
// loc — formatea " [línea L, col C]" para mensajes de error semántico.
// Devuelve cadena vacía si el nodo no tiene ubicación conocida (line == 0).
// -----------------------------------------------------------------------------
static std::string loc(int line, int col) {
  if (line <= 0) return "";
  return " [línea " + std::to_string(line) + ", col " + std::to_string(col) + "]";
}

// =============================================================================
// Despacho del patrón Visitor (accept en cada nodo del AST)
// =============================================================================

int BinaryExp::accept(Visitor *v)    { return v->visit(this); }
int NumberExp::accept(Visitor *v)    { return v->visit(this); }
int IdExp::accept(Visitor *v)        { return v->visit(this); }
int Program::accept(Visitor *v)      { return v->visit(this); }
int PrintStm::accept(Visitor *v)     { return v->visit(this); }
int AssignStm::accept(Visitor *v)    { return v->visit(this); }
int ExpListSize::accept(Visitor *v)  { return v->visit(this); }
int ExpListVals::accept(Visitor *v)  { return v->visit(this); }
int ExpMatrixSize::accept(Visitor *v){ return v->visit(this); }
int ExpMatrixVals::accept(Visitor *v){ return v->visit(this); }
int IfStm::accept(Visitor *v)        { return v->visit(this); }
int WhileStm::accept(Visitor *v)     { return v->visit(this); }
int Body::accept(Visitor *v)         { return v->visit(this); }
int VarDec::accept(Visitor *v)       { return v->visit(this); }
int FcallExp::accept(Visitor *v)     { return v->visit(this); }
int FunDec::accept(Visitor *v)       { return v->visit(this); }
int ReturnStm::accept(Visitor *v)    { return v->visit(this); }
int DoWhileStm::accept(Visitor *v)   { return v->visit(this); }
int BreakStm::accept(Visitor *v)     { return v->visit(this); }
int SwitchStm::accept(Visitor *v)    { return v->visit(this); }
int UnaryExp::accept(Visitor *v)     { return v->visit(this); }
int IndexExp::accept(Visitor *v)     { return v->visit(this); }
int MatrixExp::accept(Visitor *v)    { return v->visit(this); }
int FieldExp::accept(Visitor *v)     { return v->visit(this); }
int StructDec::accept(Visitor *v)    { return v->visit(this); }
int AddressExp::accept(Visitor *v)    { return v->visit(this); }
int DereferenceExp::accept(Visitor *v)    { return v->visit(this); }




// =============================================================================
// TypeCheckerVisitor — Análisis semántico
// =============================================================================

int TypeCheckerVisitor::TypeChecker(Program *program) {
  // Inicializamos variables globales
  funcionActual = "<global>";
  entorno.add_level();
  tiposVar.add_level();

  for (auto vd : program->vdlist)
    vd->accept(this);

  for (auto sd : program->sdlist)
    sd->accept(this);

  for (auto fd : program->fdlist)
    funAridad[fd->nombre] = int(fd->Pnombres.size());

  for (auto fd : program->fdlist)
    fd->accept(this);

  return 0;
}

int TypeCheckerVisitor::visit(FunDec *fd) {
  funcionActual = fd->nombre;
  locales = 0;
  int parametros = int(fd->Pnombres.size());

  entorno.add_level();
  tiposVar.add_level();

  for (size_t i = 0; i < fd->Pnombres.size(); ++i) {
    entorno.add_var(fd->Pnombres[i], 0);
    tiposVar.add_var(fd->Pnombres[i], fd->Ptipos[i]);
  }

  fd->cuerpo->accept(this);

  tiposVar.remove_level();
  entorno.remove_level();

  funcontador[fd->nombre] = parametros + locales;
  return 0;
}

int TypeCheckerVisitor::visit(Body *body) {
  entorno.add_level();
  tiposVar.add_level();

  for (auto dec : body->declarations)
    dec->accept(this);
  for (auto stm : body->StmList)
    stm->accept(this);

  tiposVar.remove_level();
  entorno.remove_level();
  return 0;
}

int TypeCheckerVisitor::visit(VarDec *vd) {
  auto it_var = vd->vars.begin();
  auto it_init = vd->inits.begin();
  
  for (; it_var != vd->vars.end(); ++it_var, ++it_init) {
    std::string nombre = *it_var;
    Exp *init_exp = *it_init;
    
    if (entorno.check(nombre)) {
      std::cerr << "[TypeChecker] Advertencia: la variable '" << nombre
                << "' ya fue declarada en este scope"
                << " (en función '" << funcionActual << "').\n";
    }
    
    Type* varType = nullptr;

    // Si el tipo declarado es "auto", deducirlo de la expresión de inicialización
    if (vd->type == "auto") {
      if (!init_exp) {
        throw std::runtime_error("Error semántico" + loc(vd->line, vd->col) +
                                 ": la variable '" + nombre +
                                 "' declarada como auto requiere inicialización.");
      }
      varType = deduceType(init_exp); // devuelve Type*
    } else {
      varType = parseType(vd->type); // convierte el string a Type*
    }

    
    vd->realTypes.push_back(varType->toString());
    /*int size = 0;
    if (varType == "int") {
      size = 8;
    } else if (varType == "float") {
      size = 8;
    } else if (structFields.count(varType)) {
      size = structFields[varType] * 8; // cada campo ocupa 8 bytes
    } else {
      throw std::runtime_error("[TypeChecker] Tipo desconocido: " + varType);
    }*/
    int size = 0;
    if (auto prim = dynamic_cast<PrimitiveType*>(varType)) {
      std::string tn = prim->toString();
      // Todas las variables escalares ocupan un slot de 8 bytes. Aunque un float
      // "lógico" sea de 4 bytes, el compilador opera y guarda en doble precisión
      // (movsd, 8 bytes). Si a un float le diéramos 4 bytes, el movsd escribiría
      // 8 y pisaría la variable contigua (ese era el bug 11.000002 de input20).
      if (tn == "int" || tn == "float" || tn == "char" || tn == "bool") size = 8;
      else if (structFields.count(tn)) size = structFields[tn] * 8; // struct por valor
      // string, list, matrix, tipo genérico T y demás: ocupan un slot de 8
      // bytes (son punteros / handles). No es un error desconocido.
      else size = 8;
    } else if (auto ptr = dynamic_cast<PointerType*>(varType)) {
      size = 8; // puntero
    } else if (structFields.count(varType->toString())) {
      size = structFields[varType->toString()] * 8;
    } else {
      size = 8; // fallback seguro
    }



    entorno.add_var(nombre, 0);
    tiposVar.add_var(nombre, varType->toString());
    sizesVar[nombre] = size;
    
    if (init_exp) {
      init_exp->accept(this);
    }
    
    if (funcionActual != "<global>") {
      locales++;
    }
  }
  return 0;
}

// Inferencia de tipos usada por el análisis semántico. Mira la tabla de
// símbolos (tiposVar) para resolver identificadores. Refleja la misma lógica
// que la versión de GenCodeVisitor, pero con el entorno del TypeChecker.
Type* TypeCheckerVisitor::deduceType(Exp *e) {
  if (dynamic_cast<NumberExp*>(e)) return new PrimitiveType("int");
  if (dynamic_cast<FloatExp*>(e))  return new PrimitiveType("float");
  if (dynamic_cast<StringExp*>(e)) return new PrimitiveType("string");
  if (auto id = dynamic_cast<IdExp*>(e)) {
    if (tiposVar.check(id->value)) return parseType(tiposVar.lookup(id->value));
    return new PrimitiveType("int"); // Fallback
  }
  if (auto bin = dynamic_cast<BinaryExp*>(e)) {
    Type* t1 = deduceType(bin->left);
    Type* t2 = deduceType(bin->right);
    if (t1->toString() == "string" || t2->toString() == "string") return new PrimitiveType("string");
    if (t1->toString() == "float"  || t2->toString() == "float")  return new PrimitiveType("float");
    return new PrimitiveType("int");
  }
  if (auto der = dynamic_cast<DereferenceExp*>(e)) {
    Type* inner = deduceType(der->e);
    if (auto pt = dynamic_cast<PointerType*>(inner)) return pt->base;
    return new PrimitiveType("int");
  }
  if (auto addr = dynamic_cast<AddressExp*>(e)) {
    return new PointerType(deduceType(addr->e));
  }
  if (dynamic_cast<ExpListSize*>(e) || dynamic_cast<ExpListVals*>(e)) return new PrimitiveType("list");
  if (dynamic_cast<ExpMatrixSize*>(e) || dynamic_cast<ExpMatrixVals*>(e)) return new PrimitiveType("matrix");
  return new PrimitiveType("int");
}

Type* GenCodeVisitor::deduceType(Exp *e) {
  if (dynamic_cast<NumberExp*>(e)) return new PrimitiveType("int");
  if (dynamic_cast<FloatExp*>(e)) return new PrimitiveType("float");
  if (dynamic_cast<StringExp*>(e)) return new PrimitiveType("string");
  if (auto id = dynamic_cast<IdExp*>(e)) {
    if (variableTypes.count(id->value)) return variableTypes[id->value];
    return new PrimitiveType("int"); // Fallback
  }
  if (auto bin = dynamic_cast<BinaryExp*>(e)) {
    Type* t1 = deduceType(bin->left);
    Type* t2 = deduceType(bin->right);
    if (t1->toString() == "string" || t2->toString() == "string") return new PrimitiveType( "string");
    if (t1->toString() == "float" || t2->toString() == "float") return new PrimitiveType("float");
    return new PrimitiveType("int");
  }
  if (dynamic_cast<ExpListSize*>(e) || dynamic_cast<ExpListVals*>(e)) return new PrimitiveType("list");
  if (dynamic_cast<ExpMatrixSize*>(e) || dynamic_cast<ExpMatrixVals*>(e)) return new PrimitiveType("matrix");
  if (auto fld = dynamic_cast<FieldExp*>(e)) {
    // Tipo de obj.campo: buscar el struct de 'obj' y el tipo textual del campo.
    if (variableTypes.count(fld->object)) {
      std::string structName = variableTypes[fld->object]->toString();
      if (structFieldTypes.count(structName) &&
          structFieldTypes[structName].count(fld->field))
        return parseType(structFieldTypes[structName][fld->field]);
    }
    return new PrimitiveType("int");
  }
  if (auto fc = dynamic_cast<FcallExp*>(e)) {
    // Tipo de una llamada = tipo de retorno declarado de la función.
    if (funcReturnTypes.count(fc->nombre))
      return parseType(funcReturnTypes[fc->nombre]);
    return new PrimitiveType("int");
  }
  return new PrimitiveType("int");
}

int TypeCheckerVisitor::visit(StructDec *sd) {
  if (structFields.count(sd->name))
    throw std::runtime_error("Error semántico" + loc(sd->line, sd->col) +
                             ": estructura duplicada: '" + sd->name + "'");

  int totalFields = 0;
  std::unordered_map<std::string, bool> names;
  std::unordered_map<std::string, int>  offsets;
  std::unordered_map<std::string, std::string> ftypes;
  for (auto field : sd->fields) {
    for (auto &name : field->vars) {
      if (names.count(name))
        throw std::runtime_error("Error semántico" + loc(field->line, field->col) +
                                 ": campo duplicado '" + name +
                                 "' en estructura '" + sd->name + "'");
      names[name]   = true;
      offsets[name] = totalFields * 8;
      ftypes[name]  = field->type; // tipo del campo (int/string/float/...)
      totalFields++;
    }
  }

  structFields[sd->name]       = totalFields;
  structFieldOffsets[sd->name] = offsets;
  structFieldTypes[sd->name]   = ftypes;
  return 0;
}

int TypeCheckerVisitor::visit(IdExp *exp) {
  if (!entorno.check(exp->value))
    throw std::runtime_error("Error semántico" + loc(exp->line, exp->col) +
                             ": variable no declarada: '" + exp->value +
                             "' usada en la función '" + funcionActual + "'");
  // Propaga el tipo declarado de la variable al nodo. Es imprescindible para
  // punteros: sin esto, p->astType quedaría en "int" y *p fallaría el chequeo
  // "no es puntero".
  if (tiposVar.check(exp->value))
    exp->astType = tiposVar.lookup(exp->value);
  return 0;
}

int TypeCheckerVisitor::visit(ExprStm *stm) {
  stm->e->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(AssignStm *stm) {
  stm->target->accept(this);
  stm->e->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(ExpListSize *stm) {
  stm->size->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(ExpListVals *stm) {
  if (structFields.count(stm->type)) {
    int esperados = structFields[stm->type];
    int recibidos = int(stm->values.size());
    if (recibidos != 0 && recibidos != esperados)
      throw std::runtime_error("Error semántico" + loc(stm->line, stm->col) +
                               ": la estructura '" + stm->type +
                               "' espera " + std::to_string(esperados) +
                               " valor(es), pero se pasaron " +
                               std::to_string(recibidos));
  }
  for (auto value : stm->values)
    value->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(ExpMatrixSize *stm) {
  stm->rows->accept(this);
  stm->cols->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(ExpMatrixVals *stm) {
  stm->rows->accept(this);
  stm->cols->accept(this);
  for (auto value : stm->values)
    value->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(FcallExp *fcall) {
  // Funciones builtin de strings: strlen y concat (no requieren declaración)
  static const std::unordered_set<std::string> builtins = {"strlen", "concat"};
  if (builtins.count(fcall->nombre)) {
    for (auto arg : fcall->argumentos) arg->accept(this);
    return 0;
  }

  if (funAridad.find(fcall->nombre) == funAridad.end())
    throw std::runtime_error("Error semántico" + loc(fcall->line, fcall->col) +
                             ": función no definida: '" + fcall->nombre +
                             "' llamada en '" + funcionActual + "'");

  int esperados = funAridad[fcall->nombre];
  int recibidos = int(fcall->argumentos.size());
  if (recibidos != esperados)
    throw std::runtime_error("Error semántico" + loc(fcall->line, fcall->col) +
                             ": la función '" + fcall->nombre +
                             "' espera " + std::to_string(esperados) +
                             " argumento(s), pero se pasaron " +
                             std::to_string(recibidos));

  for (auto arg : fcall->argumentos)
    arg->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(IfStm *stm) {
  stm->condition->accept(this);

  int base = locales;

  locales = 0;
  stm->then->accept(this);
  int maxLocales = locales;

  if (stm->els) {
    locales = 0;
    stm->els->accept(this);
    maxLocales = std::max(maxLocales, locales);
  }

  locales = base + maxLocales;
  return 0;
}

int TypeCheckerVisitor::visit(WhileStm *stm) {
  stm->condition->accept(this);
  stm->b->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(PrintStm *stm) {
  stm->e->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(ReturnStm *r) {
  r->e->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(BinaryExp *exp) {
  exp->left->accept(this);
  exp->right->accept(this);
  
  Type* t1 = deduceType(exp->left);
  Type* t2 = deduceType(exp->right);
  
  if (t1->toString() == "string" || t2->toString() == "string") {
    exp->astType = "string";
  } else if (t1->toString() == "float" || t2->toString() == "float") {
    exp->astType = "float";
  } else {
    exp->astType = "int";
  }
  
  return 0;
}

int TypeCheckerVisitor::visit(UnaryExp *exp) {
  exp->operand->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(IndexExp *exp) {
  if (!entorno.check(exp->name))
    throw std::runtime_error("Error semántico" + loc(exp->line, exp->col) +
                             ": variable no declarada: '" + exp->name +
                             "' usada en la función '" + funcionActual + "'");
  exp->index->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(MatrixExp *exp) {
  if (!entorno.check(exp->name))
    // Nota: exp->Exp::col porque MatrixExp tiene su propio miembro 'col'
    // (la expresión del índice de columna) que oculta al de la clase base.
    throw std::runtime_error("Error semántico" + loc(exp->line, exp->Exp::col) +
                             ": variable no declarada: '" + exp->name +
                             "' usada en la función '" + funcionActual + "'");
  exp->row->accept(this);
  exp->col->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(FieldExp *exp) {
  std::string type;
  if (!tiposVar.lookup(exp->object, type))
    throw std::runtime_error("Error semántico" + loc(exp->line, exp->col) +
                             ": variable no declarada: '" + exp->object +
                             "' usada en la función '" + funcionActual + "'");
  if (!structFieldOffsets.count(type))
    throw std::runtime_error("Error semántico" + loc(exp->line, exp->col) +
                             ": la variable '" + exp->object +
                             "' no es una estructura");
  if (!structFieldOffsets[type].count(exp->field))
    throw std::runtime_error("Error semántico" + loc(exp->line, exp->col) +
                             ": la estructura '" + type +
                             "' no tiene campo '" + exp->field + "'");
  return 0;
}

int TypeCheckerVisitor::visit(NumberExp *) { return 0; }
int TypeCheckerVisitor::visit(Program *)     { return 0; }

int TypeCheckerVisitor::visit(DoWhileStm *stm) {
  stm->condition->accept(this);
  stm->b->accept(this);
  return 0;
}

int TypeCheckerVisitor::visit(BreakStm *) { return 0; }

int TypeCheckerVisitor::visit(SwitchStm *stm) {
  stm->e->accept(this);
  for (auto c : stm->cases)
    for (auto s : c->body)
      s->accept(this);
  for (auto s : stm->default_body)
    s->accept(this);
  return 0;
}

// StringExp: solo es un literal; no hay variables que verificar
int TypeCheckerVisitor::visit(StringExp *) { return 0; }
int TypeCheckerVisitor::visit(FloatExp *) { return 0; }

int TypeCheckerVisitor::visit(AddressExp *e) {
  e->e->accept(this); // chequea la expresión interna
  if (
    !dynamic_cast<IdExp*>(e->e) &&
    !dynamic_cast<IndexExp*>(e->e) &&
    !dynamic_cast<MatrixExp*>(e->e) &&
    !dynamic_cast<FieldExp*>(e->e)
    ){
    throw std::runtime_error("Error semántico" + loc(e->line, e->col) +
                             ": no se puede tomar la dirección de un rvalue.");
  }

  e->astType = e->e->astType + "*"; // puntero al tipo interno
  return 0;
}

int TypeCheckerVisitor::visit(DereferenceExp *e) {
  e->e->accept(this);
  if (e->e->astType.back() != '*') {
    throw std::runtime_error("Error semántico" + loc(e->line, e->col) +
                             ": intento de desreferenciar algo que no es puntero.");
  }
  e->astType = e->e->astType.substr(0, e->e->astType.size() - 1);
  return 0;
}







int ConstantVisitor::visit(StringExp *) { return 0; }
int ConstantVisitor::visit(FloatExp *) { return 0; }
// Nodos de punteros: el plegado de constantes no cambia una dirección ni una
// desreferencia, pero sí debe descender al hijo por si contiene constantes.
int ConstantVisitor::visit(AddressExp *exp) {
  if (exp && exp->e) exp->e->accept(this);
  return 0;
}
int ConstantVisitor::visit(DereferenceExp *exp) {
  if (exp && exp->e) exp->e->accept(this);
  return 0;
}

// =============================================================================
// LabelVisitor — Algoritmo de Sethi-Ullman (cálculo de registros necesarios)
// =============================================================================

// -----------------------------------------------------------------------------
// captureLVal — visita exp en "modo captura" y devuelve el LVal resultante.
//
// Antes: bool captureMode + 11 campos sueltos en la clase.
// Ahora: un puntero lvalTarget apunta al LVal que se está llenando; los
//        visit() que actúan como lvalue detectan lvalTarget != nullptr y
//        solo rellenan el struct en lugar de emitir código.
// -----------------------------------------------------------------------------
LVal GenCodeVisitor::captureLVal(Exp *exp) {
  LVal lv;
  lvalTarget = &lv;
  exp->accept(this);
  lvalTarget = nullptr;
  return lv;
}

// -----------------------------------------------------------------------------
// storeTarget — switch sobre lv.kind en lugar del mapa de punteros a función.
// -----------------------------------------------------------------------------
int GenCodeVisitor::storeTarget(const LVal &lv) {
  switch (lv.kind) {
  case LValKind::Id:     return storeId(lv);
  case LValKind::Index:  return storeIndex(lv);
  case LValKind::Matrix: return storeMatrix(lv);
  case LValKind::Field:  return storeField(lv);
  case LValKind::Deref:  return storeDeref(lv);
  default:
    throw std::runtime_error("Asignacion a una expresion que no es lvalue");
  }
}

// *p = valor. El valor RHS ya está en %rax; lv.index es la expresión del
// puntero. Guardamos el valor, evaluamos la dirección y escribimos en ella.
int GenCodeVisitor::storeDeref(const LVal &lv) {
  out << "  pushq %rax\n";      // guarda el valor RHS
  lv.index->accept(this);        // %rax = dirección (evalúa el puntero)
  out << "  movq %rax, %rcx\n";  // %rcx = dirección
  out << "  popq %rax\n";        // %rax = valor RHS
  // Slots uniformes de 8 bytes (int, float-bits y punteros): un solo movq.
  out << "  movq %rax, (%rcx)\n";
  return 0;
}

// -----------------------------------------------------------------------------
// generar — punto de entrada de la generación
// -----------------------------------------------------------------------------
int GenCodeVisitor::generar(Program *program) {
  tipos.TypeChecker(program);
  funcontador       = tipos.funcontador;
  structFields      = tipos.structFields;
  structFieldOffsets= tipos.structFieldOffsets;
  structFieldTypes  = tipos.structFieldTypes;
  for (auto fd : program->fdlist) {
    funParamNames[fd->nombre] = fd->Pnombres;
    funParamTypes[fd->nombre] = fd->Ptipos;
    funcReturnTypes[fd->nombre] = fd->tipo; // tipo de retorno, para print(f(...))
    // Registrar funciones template
    if (fd->isTemplate)
      templateFunctions[fd->nombre] = fd;
  }
  // Pre-escanear strings para el string pool (constant pooling)
  collectStrings(program);
  program->accept(this);
  return 0;
}

/*Type* GenCodeVisitor::deduceType(Exp *e) {
  if (dynamic_cast<NumberExp*>(e)) return new PrimitiveType("int");
  if (dynamic_cast<FloatExp*>(e)) return new PrimitiveType("float");
  if (dynamic_cast<StringExp*>(e)) return new PrimitiveType("string");
  if (auto id = dynamic_cast<IdExp*>(e)) {
    if (variableTypes.count(id->value)) return variableTypes[id->value];
    return new PrimitiveType("int"); // Fallback
  }
  if (auto bin = dynamic_cast<BinaryExp*>(e)) {
    Type* t1 = deduceType(bin->left);
    Type* t2 = deduceType(bin->right);
    if (t1->toString() == "string" || t2->toString() == "string") return new PrimitiveType( "string");
    if (t1->toString() == "float" || t2->toString() == "float") return new PrimitiveType("float");
    return new PrimitiveType("int");
  }
  if (dynamic_cast<ExpListSize*>(e) || dynamic_cast<ExpListVals*>(e)) return new PrimitiveType("list");
  if (dynamic_cast<ExpMatrixSize*>(e) || dynamic_cast<ExpMatrixVals*>(e)) return new PrimitiveType("matrix");
  return new PrimitiveType("int");
}*/

// -----------------------------------------------------------------------------
// collectStrings: pre-escaneo de StringExp en todo el programa
// Optimización: constant pooling (un solo label por valor único)
// -----------------------------------------------------------------------------
void GenCodeVisitor::collectStringsFromExp(Exp *e) {
  if (!e) return;
  if (auto se = dynamic_cast<StringExp *>(e)) {
    if (!stringPool.count(se->value)) {
      stringPool[se->value] = "__str_" + std::to_string(strLabelCnt++);
    }
  } else if (auto be = dynamic_cast<BinaryExp *>(e)) {
    collectStringsFromExp(be->left);
    collectStringsFromExp(be->right);
  } else if (auto ue = dynamic_cast<UnaryExp *>(e)) {
    collectStringsFromExp(ue->operand);
  } else if (auto fc = dynamic_cast<FcallExp *>(e)) {
    if (fc->nombre == "concat") needsConcat = true;
    for (auto arg : fc->argumentos) collectStringsFromExp(arg);
  }
}
void GenCodeVisitor::collectStringsFromStm(Stm *s) {
  if (!s) return;
  if (auto as = dynamic_cast<AssignStm *>(s))  { collectStringsFromExp(as->e); }
  else if (auto ps = dynamic_cast<PrintStm *>(s))  { collectStringsFromExp(ps->e); }
  else if (auto rs = dynamic_cast<ReturnStm *>(s)) { collectStringsFromExp(rs->e); }
  else if (auto vd = dynamic_cast<VarDec *>(s)) {
    for (auto init : vd->inits) collectStringsFromExp(init);
  }
  else if (auto is = dynamic_cast<IfStm *>(s)) {
    collectStringsFromExp(is->condition);
    collectStringsFromBody(is->then);
    if (is->els) collectStringsFromBody(is->els);
  } else if (auto ws = dynamic_cast<WhileStm *>(s)) {
    collectStringsFromExp(ws->condition);
    collectStringsFromBody(ws->b);
  } else if (auto dw = dynamic_cast<DoWhileStm *>(s)) {
    collectStringsFromBody(dw->b);
    collectStringsFromExp(dw->condition);
  } else if (auto sw = dynamic_cast<SwitchStm *>(s)) {
    collectStringsFromExp(sw->e);
    for (auto c : sw->cases)
      for (auto stm : c->body) collectStringsFromStm(stm);
    for (auto stm : sw->default_body) collectStringsFromStm(stm);
  }
}
void GenCodeVisitor::collectStringsFromBody(Body *b) {
  if (!b) return;
  for (auto vd : b->declarations) {
    for (auto init : vd->inits) collectStringsFromExp(init);
  }
  for (auto stm : b->StmList) collectStringsFromStm(stm);
}
void GenCodeVisitor::collectStrings(Program *program) {
  for (auto vd : program->vdlist) {
    for (auto init : vd->inits) collectStringsFromExp(init);
  }
  for (auto fd : program->fdlist)
    collectStringsFromBody(fd->cuerpo);
}

// Detecta si una expresión produce un string (para elegir formato de print)
bool GenCodeVisitor::isStringType(Exp *e) {
  if (dynamic_cast<StringExp *>(e)) return true;
  if (auto id = dynamic_cast<IdExp *>(e)) {
    return variableTypes.count(id->value) && variableTypes[id->value]->toString() == "string";
  }
  if (auto fc = dynamic_cast<FcallExp *>(e)) {
    if (fc->nombre == "concat") return true;
    if (funParamTypes.count(fc->nombre)) {
        // En una implementación real se vería el tipo de retorno de la función.
        // Aquí simplificamos si es necesario.
    }
  }
  return false;
}

// -----------------------------------------------------------------------------
// visit(Program)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(Program *program) {
  out << ".data\n";
  out << "print_fmt: .string \"%ld \\n\"\n";
  out << "print_str_fmt: .string \"%s\\n\"\n";
  out << "print_float_fmt: .string \"%f \\n\"\n";
  out << "itoa_fmt: .string \"%ld\"\n";
  out << "ftoa_fmt: .string \"%f\"\n";
  for (const auto &pair : stringPool) {
    // pair.first ya puede contener las comillas si se escaneó con ellas
    std::string val = pair.first;
    // Removemos las comillas inicial y final si existen
    if (val.size() >= 2 && val.front() == '"' && val.back() == '"') {
      val = val.substr(1, val.size() - 2);
    }
    out << pair.second << ": .string \"" << val << "\"\n";
  }

  for (auto dec : program->vdlist)
    dec->accept(this);

  for (std::unordered_map<std::string, bool>::const_iterator it =
           memoriaGlobal.begin();
       it != memoriaGlobal.end(); ++it)
    out << it->first << ": .quad 0\n";
  for (auto fd : program->fdlist) {
    for (size_t i = 0; i < fd->Ptipos.size(); ++i) {
      if (fd->Ptipos[i] == "matrix")
        out << "__cols_" << fd->nombre << "_" << fd->Pnombres[i]
            << ": .quad 0\n";
    }
  }

  out << "\n.text\n";

  // Emisión de función builtin concat y conversores numéricos
  out << "\n.globl __runtime_concat\n";
  out << "__runtime_concat:\n";
  out << "  pushq %rbp\n";
    out << "  movq %rsp, %rbp\n";
    out << "  pushq %rdi\n"; // save arg1 (str1)
    out << "  pushq %rsi\n"; // save arg2 (str2)
    // rdi = str1. call strlen
    out << "  call strlen@PLT\n";
    out << "  movq %rax, %r12\n"; // r12 = len(str1)
    // rdi = str2. call strlen
    out << "  movq -16(%rbp), %rdi\n";
    out << "  call strlen@PLT\n";
    out << "  addq %rax, %r12\n"; // r12 = len(str1) + len(str2)
    out << "  addq $1, %r12\n";   // +1 for null terminator
    // malloc(len)
    out << "  movq %r12, %rdi\n";
    out << "  call malloc@PLT\n";
    out << "  movq %rax, %r13\n"; // r13 = new string
    // strcpy(new_str, str1)
    out << "  movq %r13, %rdi\n";
    out << "  movq -8(%rbp), %rsi\n";
    out << "  call strcpy@PLT\n";
    // strcat(new_str, str2)
    out << "  movq %r13, %rdi\n";
    out << "  movq -16(%rbp), %rsi\n";
    out << "  call strcat@PLT\n";
    out << "  movq %r13, %rax\n"; // return new string
    out << "  leave\n";
    out << "  ret\n\n";
    
    out << "\n.globl __itoa\n";
    out << "__itoa:\n";
    out << "  pushq %rbp\n";
    out << "  movq %rsp, %rbp\n";
    out << "  subq $16, %rsp\n";
    out << "  movq %rdi, -8(%rbp)\n"; // save arg
    // malloc(32)
    out << "  movq $32, %rdi\n";
    out << "  call malloc@PLT\n";
    out << "  movq %rax, %r13\n"; // r13 = allocated buffer
    // snprintf(r13, 32, "%ld", val)
    out << "  movq %r13, %rdi\n";
    out << "  movq $32, %rsi\n";
    out << "  leaq itoa_fmt(%rip), %rdx\n"; // %ld format string without newline
    out << "  movq -8(%rbp), %rcx\n";
    out << "  movq $0, %rax\n";
    out << "  call snprintf@PLT\n";
    out << "  movq %r13, %rax\n";
    out << "  leave\n";
    out << "  ret\n\n";
    
    out << "\n.globl __ftoa\n";
    out << "__ftoa:\n";
    out << "  pushq %rbp\n";
    out << "  movq %rsp, %rbp\n";
    out << "  subq $16, %rsp\n";
    out << "  movsd %xmm0, -8(%rbp)\n"; // save arg
    // malloc(32)
    out << "  movq $32, %rdi\n";
    out << "  call malloc@PLT\n";
    out << "  movq %rax, %r13\n"; // r13 = allocated buffer
    // snprintf(r13, 32, "%f", val)
    out << "  movq %r13, %rdi\n";
    out << "  movq $32, %rsi\n";
    out << "  leaq ftoa_fmt(%rip), %rdx\n"; // %f format string without newline
    out << "  movsd -8(%rbp), %xmm0\n";
    out << "  movq $1, %rax\n"; // 1 vector register
    out << "  call snprintf@PLT\n";
    out << "  movq %r13, %rax\n";
    out << "  leave\n";
    out << "  ret\n\n";

  // Build map: function name -> FunDec*
  std::unordered_map<std::string, FunDec*> funMap;
  for (auto fd : program->fdlist)
    funMap[fd->nombre] = fd;

  // Helpers to scan expressions and statements for called function names
  std::function<void(Exp*, std::vector<std::string>&)> scanExp;
  std::function<void(Stm*, std::vector<std::string>&)> scanStm;
  std::function<void(Body*, std::vector<std::string>&)> scanBody;

  scanExp = [&](Exp* e, std::vector<std::string>& calls) {
    if (!e) return;
    if (auto be = dynamic_cast<BinaryExp*>(e)) {
      scanExp(be->left, calls); scanExp(be->right, calls);
    } else if (auto fe = dynamic_cast<FcallExp*>(e)) {
      calls.push_back(fe->nombre);
      for (auto arg : fe->argumentos) scanExp(arg, calls);
    } else if (auto ue = dynamic_cast<UnaryExp*>(e)) {
      scanExp(ue->operand, calls);
    } else if (auto ie = dynamic_cast<IndexExp*>(e)) {
      scanExp(ie->index, calls);
    } else if (auto me = dynamic_cast<MatrixExp*>(e)) {
      scanExp(me->row, calls); scanExp(me->col, calls);
    }
  };
  scanStm = [&](Stm* s, std::vector<std::string>& calls) {
    if (!s) return;
    if (auto as = dynamic_cast<AssignStm*>(s)) {
      scanExp(as->e, calls);
    } else if (auto ps = dynamic_cast<PrintStm*>(s)) {
      scanExp(ps->e, calls);
    } else if (auto rs = dynamic_cast<ReturnStm*>(s)) {
      scanExp(rs->e, calls);
    } else if (auto is2 = dynamic_cast<IfStm*>(s)) {
      scanExp(is2->condition, calls);
      scanBody(is2->then, calls);
      if (is2->els) scanBody(is2->els, calls);
    } else if (auto ws = dynamic_cast<WhileStm*>(s)) {
      scanExp(ws->condition, calls);
      scanBody(ws->b, calls);
    } else if (auto dw = dynamic_cast<DoWhileStm*>(s)) {
      scanBody(dw->b, calls);
      scanExp(dw->condition, calls);
    } else if (auto sw = dynamic_cast<SwitchStm*>(s)) {
      scanExp(sw->e, calls);
      for (auto c : sw->cases)
        for (auto st : c->body) scanStm(st, calls);
      for (auto st : sw->default_body) scanStm(st, calls);
    }
  };
  scanBody = [&](Body* b, std::vector<std::string>& calls) {
    if (!b) return;
    for (auto stm : b->StmList) scanStm(stm, calls);
  };

  // DFS from main to get emission order
  std::vector<FunDec*> emitOrder;
  std::unordered_map<std::string, bool> visited;
  std::function<void(const std::string&)> dfs = [&](const std::string& name) {
    if (visited[name] || templateFunctions.count(name)) return;
    visited[name] = true;
    auto it2 = funMap.find(name);
    if (it2 == funMap.end()) return;
    FunDec* fd2 = it2->second;
    emitOrder.push_back(fd2);
    std::vector<std::string> callees;
    scanBody(fd2->cuerpo, callees);
    for (auto& callee : callees)
      dfs(callee);
  };

  if (funMap.count("main")) dfs("main");
  for (auto fd : program->fdlist)
    if (!visited[fd->nombre]) dfs(fd->nombre);

  for (auto fd2 : emitOrder)
    fd2->accept(this);

  // Emitir instancias de templates generadas durante el recorrido
  std::unordered_set<std::string> processedTemplates;
  while (processedTemplates.size() < emittedTemplates.size()) {
    std::string currentInstance = "";
    for (const auto &instanceName : emittedTemplates) {
      if (!processedTemplates.count(instanceName)) {
        currentInstance = instanceName;
        break;
      }
    }
    if (currentInstance == "") break;
    processedTemplates.insert(currentInstance);

    // "identity_int" -> buscar base "identity"
    std::string baseName = currentInstance.substr(0, currentInstance.find_last_of('_'));
    std::string typeName = currentInstance.substr(currentInstance.find_last_of('_') + 1); // "int" o "string"
    if (templateFunctions.count(baseName)) {
        FunDec *orig = templateFunctions[baseName];
        std::string oldName = orig->nombre;
        std::vector<std::string> oldPtipos = orig->Ptipos;

        // Reescribimos los tipos parametrizados (T) por el tipo concreto
        for (size_t i = 0; i < orig->Ptipos.size(); ++i) {
          if (orig->Ptipos[i] == orig->templateParam) {
            orig->Ptipos[i] = typeName;
          }
        }

        // Propagar el contador de variables locales/parámetros para instanciar el stack frame correctamente
        funcontador[currentInstance] = funcontador[baseName];

        orig->nombre = currentInstance; // temporalmente renombramos para emitir
        orig->accept(this);
        orig->nombre = oldName;
        orig->Ptipos = oldPtipos; // restauramos
    }
  }

  // Emit D&C potencia helper if any ** used call
  if (needsPotencia) {
    out << "\n.globl potencia\n";
    out << "potencia:\n";
    out << "  pushq %rbp\n";
    out << "  movq %rsp, %rbp\n";
    out << "  cmpq $0, %rsi\n";
    out << "  je potencia_n_zero\n";
    out << "  cmpq $1, %rsi\n";
    out << "  je potencia_n_one\n";
    out << "  pushq %rdi\n";
    out << "  movq %rsi, %rdx\n";
    out << "  andq $1, %rdx\n";
    out << "  pushq %rdx\n";
    out << "  movq %rdi, %rax\n";
    out << "  imulq %rdi, %rax\n";
    out << "  movq %rax, %rdi\n";
    out << "  sarq $1, %rsi\n";
    out << "  call potencia\n";
    out << "  popq %rdx\n";
    out << "  popq %rcx\n";
    out << "  cmpq $0, %rdx\n";
    out << "  je potencia_end\n";
    out << "  imulq %rcx, %rax\n";
    out << "  jmp potencia_end\n";
    out << "potencia_n_zero:\n";
    out << "  movq $1, %rax\n";
    out << "  jmp potencia_end\n";
    out << "potencia_n_one:\n";
    out << "  movq %rdi, %rax\n";
    out << "  jmp potencia_end\n";
    out << "potencia_end:\n";
    out << "  leave\n";
    out << "  ret\n";
  }

  out << "\n.section .note.GNU-stack,\"\",@progbits\n";
  return 0;
}

int GenCodeVisitor::visit(StructDec *) { return 0; }

// -----------------------------------------------------------------------------
// visit(VarDec) — registra variables en memoria (global o local)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(VarDec *stm) {
  auto it_var = stm->vars.begin();
  auto it_init = stm->inits.begin();
  auto it_real = stm->realTypes.begin();
  
  for (; it_var != stm->vars.end(); ++it_var, ++it_init, ++it_real) {
    std::string var = *it_var;
    Exp *init_exp = *it_init;
    
    std::string realType = *it_real;
    variableTypes[var] = parseType(realType);

    if (auto ptrType = dynamic_cast<PointerType*>(variableTypes[var])) {
      tipos.sizesVar[var] = 8; // puntero
    } else {
      tipos.sizesVar[var] = 8; // int/float/char/bool: slot uniforme de 8 bytes
    }

    int currentOffset = 0;
    
    if (!entornoFuncion) {
      memoriaGlobal[var]  = true;
      if (structFields.count(realType))
        structAllocated[var] = false;
    } else {
      currentOffset = offset;
      memoria[var]        = offset;
      if (structFields.count(realType))
        structAllocated[var] = false;
      int size = tipos.sizesVar[var]; //MODIFICAR SIZESVAR PARA QUE RECONOZCA PUNTERO
      offset -= size;
    }
    
    if (init_exp) {
      init_exp->accept(this);
      
      // Store the evaluated expression into the variable
      if (entornoFuncion) {
        if (dynamic_cast<PrimitiveType*>(variableTypes[var]) &&
        variableTypes[var]->toString() == "float") {
          out << "  movsd %xmm0, " << currentOffset << "(%rbp)\n";
        } else {
          // int, bool, char, punteros
          out << "  movq %rax, " << currentOffset << "(%rbp)\n";
        }
      } else {
        if (dynamic_cast<PrimitiveType*>(variableTypes[var]) &&
        variableTypes[var]->toString() == "float") {
          out << "  leaq " << var << "(%rip), %rax\n";
          out << "  movsd %xmm0, (%rax)\n";
        } else {
          out << "  movq %rax, " << var << "(%rip)\n";
        }
      }
    }
  }
  return 0;
}

// -----------------------------------------------------------------------------
// visit(NumberExp)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(NumberExp *exp) {
  if (lvalTarget) {
    lvalTarget->kind       = LValKind::Number;
    lvalTarget->numIsConst = true;
    lvalTarget->numVal     = exp->value;
    return 0;
  }
  out << "  movq $" << exp->value << ", %rax\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(IdExp)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(IdExp *exp) {
  if (lvalTarget) {
    lvalTarget->kind = LValKind::Id;
    lvalTarget->name = exp->value;
    return 0;
  }
  if (memoriaGlobal.count(exp->value))
    out << "  movq " << exp->value << "(%rip), %rax\n";
  else
    out << "  movq " << memoria[exp->value] << "(%rbp), %rax\n";
  // El valor en %xmm0 solo hace falta si la variable es float (para operaciones
  // y print de punto flotante). Para enteros/punteros ese movq era código
  // muerto: lo omitimos (peephole).
  if (variableTypes.count(exp->value) &&
      variableTypes[exp->value]->toString() == "float")
    out << "  movq %rax, %xmm0\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(IndexExp)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(IndexExp *exp) {
  if (lvalTarget) {
    lvalTarget->kind  = LValKind::Index;
    lvalTarget->name  = exp->name;
    lvalTarget->index = exp->index;
    return 0;
  }
  exp->index->accept(this);
  out << "  movq %rax, %rdi\n";
  if (memoriaGlobal.count(exp->name))
    out << "  movq " << exp->name << "(%rip), %rax\n";
  else
    out << "  movq " << memoria[exp->name] << "(%rbp), %rax\n";
  out << "  movq (%rax, %rdi, 8), %rax\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(MatrixExp)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(MatrixExp *exp) {
  if (lvalTarget) {
    lvalTarget->kind = LValKind::Matrix;
    lvalTarget->name = exp->name;
    lvalTarget->row  = exp->row;
    lvalTarget->col  = exp->col;
    return 0;
  }
  exp->row->accept(this);
  out << "  pushq %rax\n";
  exp->col->accept(this);
  out << "  movq %rax, %rdi\n";
  out << "  popq %rax\n";

  if (matrixColumns.count(exp->name))
    out << "  movq $" << matrixColumns[exp->name] << ", %rcx\n";
  else if (currentMatrixParamLabels.count(exp->name))
    out << "  movq " << currentMatrixParamLabels[exp->name] << "(%rip), %rcx\n";
  else
    out << "  movq $0, %rcx\n";

  out << "  imulq %rcx, %rax\n";
  out << "  addq %rdi, %rax\n";
  out << "  movq %rax, %rdi\n";

  if (memoriaGlobal.count(exp->name))
    out << "  movq " << exp->name << "(%rip), %rax\n";
  else
    out << "  movq " << memoria[exp->name] << "(%rbp), %rax\n";

  out << "  movq (%rax, %rdi, 8), %rax\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(FieldExp)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(FieldExp *exp) {
  if (lvalTarget) {
    lvalTarget->kind   = LValKind::Field;
    lvalTarget->object = exp->object;
    lvalTarget->field  = exp->field;
    return 0;
  }
  std::string type     = variableTypes[exp->object]->toString();
  int fieldIndex       = structFieldOffsets[type][exp->field] / 8;

  out << "  movq $" << fieldIndex << ", %rdi\n";
  if (memoriaGlobal.count(exp->object))
    out << "  movq " << exp->object << "(%rip), %rax\n";
  else
    out << "  movq " << memoria[exp->object] << "(%rbp), %rax\n";
  out << "  movq (%rax, %rdi, 8), %rax\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(ExpListSize)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(ExpListSize *stm) {
  if (lvalTarget) {
    lvalTarget->kind  = LValKind::ListSize;
    lvalTarget->type  = stm->type;
    lvalTarget->index = stm->size;
    return 0;
  }
  stm->size->accept(this);
  out << "  movq $8, %rcx\n";
  out << "  imulq %rcx, %rax\n";
  out << "  movq %rax, %rdi\n"
      << "  call malloc@PLT\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(ExpListVals)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(ExpListVals *stm) {
  if (lvalTarget) {
    lvalTarget->kind   = LValKind::ListVals;
    lvalTarget->type   = stm->type;
    lvalTarget->values = stm->values;
    return 0;
  }
  int n = stm->values.size();
  out << "  movq $" << n << ", %rax\n";
  out << "  movq $8, %rcx\n";
  out << "  imulq %rcx, %rax\n";
  out << "  movq %rax, %rdi\n";
  out << "  call malloc@PLT\n";
  out << "  pushq %rax\n";
  for (size_t i = 0; i < (size_t)n; ++i) {
    stm->values[i]->accept(this);
    out << "  movq %rax, %rcx\n";
    out << "  movq $" << i << ", %rdi\n";
    out << "  popq %rax\n";
    out << "  movq %rcx, (%rax, %rdi, 8)\n";
    if (i + 1 < (size_t)n)
      out << "  pushq %rax\n";
  }
  return 0;
}

// -----------------------------------------------------------------------------
// visit(ExpMatrixSize)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(ExpMatrixSize *stm) {
  if (lvalTarget) {
    lvalTarget->kind = LValKind::MatrixSize;
    lvalTarget->type = stm->type;
    lvalTarget->row  = stm->rows;
    lvalTarget->col  = stm->cols;
    return 0;
  }
  stm->cols->accept(this);
  out << "  pushq %rax\n";
  stm->rows->accept(this);
  out << "  popq %rcx\n";
  out << "  imulq %rcx, %rax\n";
  out << "  salq $3, %rax\n";
  out << "  movq %rax, %rdi\n";
  out << "  call malloc@PLT\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(ExpMatrixVals)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(ExpMatrixVals *stm) {
  if (lvalTarget) {
    lvalTarget->kind   = LValKind::MatrixVals;
    lvalTarget->type   = stm->type;
    lvalTarget->row    = stm->rows;
    lvalTarget->col    = stm->cols;
    lvalTarget->values = stm->values;
    return 0;
  }
  stm->cols->accept(this);
  out << "  pushq %rax\n";
  stm->rows->accept(this);
  out << "  popq %rcx\n";
  out << "  imulq %rcx, %rax\n";
  out << "  salq $3, %rax\n";
  out << "  movq %rax, %rdi\n";
  out << "  call malloc@PLT\n";
  out << "  pushq %rax\n";
  for (size_t i = 0; i < stm->values.size(); ++i) {
    out << "  pushq %rax\n";
    stm->values[i]->accept(this);
    out << "  movq %rax, %rcx\n";
    out << "  popq %rax\n";
    out << "  movq %rcx, " << (i * 8) << "(%rax)\n";
  }
  out << "  popq %rax\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(AssignStm)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(ExprStm *stm) {
  // Evalúa la expresión (p. ej. una llamada) y descarta el resultado en %rax.
  stm->e->accept(this);
  return 0;
}

int GenCodeVisitor::visit(AssignStm *stm) {
  LVal target = captureLVal(stm->target);

  // Solo capturar el RHS si es un nodo de inicialización especial.
  // Para cualquier otra expresión (BinaryExp, IdExp, FcallExp, etc.)
  // captureLVal emitiría código real porque esos visit() no tienen rama
  // lvalTarget — en ese caso se va directo al caso general al final.
  bool specialRhs = stm->e->isSpecialRhs();

  if (target.kind == LValKind::Id && specialRhs) {
    const std::string &targetName = target.name;
    LVal rhs = captureLVal(stm->e);

    if (rhs.kind == LValKind::ListVals) {
      if (structFields.count(rhs.type)) {
        // Struct literal con llaves
        int fields = structFields[rhs.type];
        out << "  movq $" << (fields * 8) << ", %rdi\n";
        out << "  call malloc@PLT\n";
        if (memoriaGlobal.count(targetName))
          out << "  movq %rax, " << targetName << "(%rip)\n";
        else
          out << "  movq %rax, " << memoria[targetName] << "(%rbp)\n";
        structAllocated[targetName] = true;

        for (size_t i = 0; i < rhs.values.size(); ++i) {
          rhs.values[i]->accept(this);
          out << "  pushq %rax\n";
          out << "  movq $" << i << ", %rax\n";
          out << "  movq %rax, %rdi\n";
          out << "  popq %rax\n";
          out << "  movq %rax, %rcx\n";
          if (memoriaGlobal.count(targetName))
            out << "  movq " << targetName << "(%rip), %rax\n";
          else
            out << "  movq " << memoria[targetName] << "(%rbp), %rax\n";
          out << "  movq %rcx, (%rax, %rdi, 8)\n";
        }
        return 0;
      }

      // Lista con valores literales
      int n = rhs.values.size();
      out << "  movq $" << n << ", %rax\n";
      out << "  movq $8, %rcx\n";
      out << "  imulq %rcx, %rax\n";
      out << "  movq %rax, %rdi\n";
      out << "  call malloc@PLT\n";
      if (memoriaGlobal.count(targetName))
        out << "  movq %rax, " << targetName << "(%rip)\n";
      else
        out << "  movq %rax, " << memoria[targetName] << "(%rbp)\n";

      for (size_t i = 0; i < rhs.values.size(); ++i) {
        rhs.values[i]->accept(this);
        out << "  pushq %rax\n";
        out << "  movq $" << i << ", %rax\n";
        out << "  movq %rax, %rdi\n";
        out << "  popq %rax\n";
        out << "  movq %rax, %rcx\n";
        if (memoriaGlobal.count(targetName))
          out << "  movq " << targetName << "(%rip), %rax\n";
        else
          out << "  movq " << memoria[targetName] << "(%rbp), %rax\n";
        out << "  movq %rcx, (%rax, %rdi, 8)\n";
      }
      return 0;
    }

    if (rhs.kind == LValKind::MatrixSize) {
      // Capturar columnas para acceso matricial posterior
      LVal colLV = captureLVal(rhs.col);
      if (colLV.numIsConst)
        matrixColumns[targetName] = colLV.numVal;

      rhs.col->accept(this);
      out << "  pushq %rax\n";
      rhs.row->accept(this);
      out << "  popq %rcx\n";
      out << "  imulq %rcx, %rax\n";
      out << "  salq $3, %rax\n";
      out << "  movq %rax, %rdi\n";
      out << "  call malloc@PLT\n";
      if (memoriaGlobal.count(targetName))
        out << "  movq %rax, " << targetName << "(%rip)\n";
      else
        out << "  movq %rax, " << memoria[targetName] << "(%rbp)\n";
      return 0;
    }

    if (rhs.kind == LValKind::MatrixVals) {
      LVal colLV = captureLVal(rhs.col);
      int cols = colLV.numIsConst ? colLV.numVal : 0;
      if (cols > 0)
        matrixColumns[targetName] = cols;

      rhs.col->accept(this);
      out << "  pushq %rax\n";
      rhs.row->accept(this);
      out << "  popq %rcx\n";
      out << "  imulq %rcx, %rax\n";
      out << "  salq $3, %rax\n";
      out << "  movq %rax, %rdi\n";
      out << "  call malloc@PLT\n";
      if (memoriaGlobal.count(targetName))
        out << "  movq %rax, " << targetName << "(%rip)\n";
      else
        out << "  movq %rax, " << memoria[targetName] << "(%rbp)\n";

      for (size_t i = 0; i < rhs.values.size(); ++i) {
        rhs.values[i]->accept(this);
        out << "  pushq %rax\n";
        if (cols > 0) {
          out << "  movq $" << (i / cols) << ", %rax\n";
          out << "  pushq %rax\n";
          out << "  movq $" << (i % cols) << ", %rax\n";
        } else {
          out << "  movq $0, %rax\n";
          out << "  pushq %rax\n";
          out << "  movq $" << i << ", %rax\n";
        }
        out << "  movq %rax, %rdi\n";
        out << "  popq %rax\n";
        if (matrixColumns.count(targetName))
          out << "  movq $" << matrixColumns[targetName] << ", %rcx\n";
        else if (currentMatrixParamLabels.count(targetName))
          out << "  movq " << currentMatrixParamLabels[targetName] << "(%rip), %rcx\n";
        else
          out << "  movq $0, %rcx\n";
        out << "  imulq %rcx, %rax\n";
        out << "  addq %rdi, %rax\n";
        out << "  movq %rax, %rdi\n";
        out << "  popq %rcx\n";
        if (memoriaGlobal.count(targetName))
          out << "  movq " << targetName << "(%rip), %rax\n";
        else
          out << "  movq " << memoria[targetName] << "(%rbp), %rax\n";
        out << "  movq %rcx, (%rax, %rdi, 8)\n";
      }
      return 0;
    }
  }  // fin if (target.kind == LValKind::Id && isSpecialRhs)

  // Caso general: evalúa RHS → %rax y almacena según el tipo de lvalue
  stm->e->accept(this);
  storeTarget(target);
  return 0;
}






int GenCodeVisitor::visit(AddressExp *e) {
  // &lvalue → dirección en %rax. NO evaluamos el valor (no queremos leerlo),
  // sino que calculamos su dirección según el tipo de lvalue.
  if (auto id = dynamic_cast<IdExp*>(e->e)) {
    // Variable simple: dirección de su slot
    if (memoriaGlobal.count(id->value))
      out << "  leaq " << id->value << "(%rip), %rax\n";
    else
      out << "  leaq " << memoria[id->value] << "(%rbp), %rax\n";
  } else if (auto field = dynamic_cast<FieldExp*>(e->e)) {
    // Campo de struct: el struct vive en heap y la variable guarda un puntero.
    // dirección = punteroStruct + offsetCampo
    std::string type = variableTypes[field->object]->toString();
    int fieldOffset = structFieldOffsets[type][field->field]; // en bytes
    if (memoriaGlobal.count(field->object))
      out << "  movq " << field->object << "(%rip), %rax\n";
    else
      out << "  movq " << memoria[field->object] << "(%rbp), %rax\n";
    if (fieldOffset != 0)
      out << "  addq $" << fieldOffset << ", %rax\n";
  } else if (auto idx = dynamic_cast<IndexExp*>(e->e)) {
    // Elemento de arreglo: dirección = base + índice*8
    idx->index->accept(this);           // %rax = índice
    out << "  imulq $8, %rax\n";
    out << "  pushq %rax\n";
    if (memoriaGlobal.count(idx->name))
      out << "  movq " << idx->name << "(%rip), %rcx\n";
    else
      out << "  movq " << memoria[idx->name] << "(%rbp), %rcx\n";
    out << "  popq %rax\n";
    out << "  addq %rcx, %rax\n";
  }

  e->astType = e->e->astType + "*"; // puntero al tipo interno
  return 0;
}


int GenCodeVisitor::visit(DereferenceExp *e) {
  // Modo lvalue: *p = ...  → guardamos la expresión del puntero para storeDeref
  if (lvalTarget) {
    lvalTarget->kind  = LValKind::Deref;
    lvalTarget->index = e->e; // la expresión que produce la dirección
    return 0;
  }
  // Genera código para obtener el puntero en %rax
  e->e->accept(this);

  // Ahora %rax contiene la dirección
  if (e->e->astType == "int*") {
    out << "  movq (%rax), %rax\n"; // cargar entero
    e->astType = "int";
  } else if (e->e->astType == "float*") {
    out << "  movsd (%rax), %xmm0\n"; // cargar float
    e->astType = "float";
  } else if (e->e->astType == "char*") {
    out << "  movb (%rax), %al\n"; // cargar char
    e->astType = "char";
  } else {
    out << "  movq (%rax), %rax\n"; // por defecto
    // Quitar el '*' final para obtener el tipo base
    if (!e->e->astType.empty() && e->e->astType.back() == '*') {
      e->astType = e->e->astType.substr(0, e->e->astType.size() - 1);
    }
  }
  return 0;
}



















// -----------------------------------------------------------------------------
// storeId
// -----------------------------------------------------------------------------
int GenCodeVisitor::storeId(const LVal &lv) {
  if (memoriaGlobal.count(lv.name))
    out << "  movq %rax, " << lv.name << "(%rip)\n";
  else
    out << "  movq %rax, " << memoria[lv.name] << "(%rbp)\n";
  return 0;
}

// -----------------------------------------------------------------------------
// storeIndex
// -----------------------------------------------------------------------------
int GenCodeVisitor::storeIndex(const LVal &lv) {
  out << "  pushq %rax\n";
  lv.index->accept(this);
  out << "  movq %rax, %rdi\n";
  out << "  popq %rax\n";
  out << "  movq %rax, %rcx\n";
  if (memoriaGlobal.count(lv.name))
    out << "  movq " << lv.name << "(%rip), %rax\n";
  else
    out << "  movq " << memoria[lv.name] << "(%rbp), %rax\n";
  out << "  movq %rcx, (%rax, %rdi, 8)\n";
  return 0;
}

// -----------------------------------------------------------------------------
// storeMatrix
// -----------------------------------------------------------------------------
int GenCodeVisitor::storeMatrix(const LVal &lv) {
  out << "  pushq %rax\n";
  lv.row->accept(this);
  out << "  pushq %rax\n";
  lv.col->accept(this);
  out << "  movq %rax, %rdi\n";
  out << "  popq %rax\n";

  if (matrixColumns.count(lv.name))
    out << "  movq $" << matrixColumns[lv.name] << ", %rcx\n";
  else if (currentMatrixParamLabels.count(lv.name))
    out << "  movq " << currentMatrixParamLabels[lv.name] << "(%rip), %rcx\n";
  else
    out << "  movq $0, %rcx\n";

  out << "  imulq %rcx, %rax\n";
  out << "  addq %rdi, %rax\n";
  out << "  movq %rax, %rdi\n";
  out << "  popq %rcx\n";

  if (memoriaGlobal.count(lv.name))
    out << "  movq " << lv.name << "(%rip), %rax\n";
  else
    out << "  movq " << memoria[lv.name] << "(%rbp), %rax\n";
  out << "  movq %rcx, (%rax, %rdi, 8)\n";
  return 0;
}

// -----------------------------------------------------------------------------
// storeField
// -----------------------------------------------------------------------------
int GenCodeVisitor::storeField(const LVal &lv) {
  std::string type = variableTypes[lv.object]->toString();
  int fieldIndex   = structFieldOffsets[type][lv.field] / 8;

  out << "  pushq %rax\n";
  out << "  movq $" << fieldIndex << ", %rax\n";
  out << "  movq %rax, %rdi\n";
  out << "  popq %rax\n";
  out << "  movq %rax, %rcx\n";

  if (structAllocated.count(lv.object) && !structAllocated[lv.object]) {
    int fields = structFields[type];
    out << "  pushq %rcx\n";
    out << "  pushq %rdi\n";
    out << "  movq $" << (fields * 8) << ", %rdi\n";
    out << "  call malloc@PLT\n";
    if (memoriaGlobal.count(lv.object))
      out << "  movq %rax, " << lv.object << "(%rip)\n";
    else
      out << "  movq %rax, " << memoria[lv.object] << "(%rbp)\n";
    out << "  popq %rdi\n";
    out << "  popq %rcx\n";
    structAllocated[lv.object] = true;
  }

  if (memoriaGlobal.count(lv.object))
    out << "  movq " << lv.object << "(%rip), %rax\n";
  else
    out << "  movq " << memoria[lv.object] << "(%rbp), %rax\n";
  out << "  movq %rcx, (%rax, %rdi, 8)\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(BinaryExp)
// -----------------------------------------------------------------------------
// Helper: emit the operator instruction given rax=left, rcx=right
static void emitOp(std::ostream &out, BinaryOp op) {
  switch (op) {
    case PLUS_OP:  out << "  addq %rcx, %rax\n";  break;
    case MINUS_OP: out << "  subq %rcx, %rax\n";  break;
    case MUL_OP:   out << "  imulq %rcx, %rax\n"; break;
    case DIV_OP:
      out << "  cqto\n";
      out << "  idivq %rcx\n";
      break;
    case LE_OP:
      out << "  cmpq %rcx, %rax\n";
      out << "  movq $0, %rax\n";
      out << "  setl %al\n";
      out << "  movzbq %al, %rax\n";
      break;
    case GT_OP:
      out << "  cmpq %rcx, %rax\n";
      out << "  movq $0, %rax\n";
      out << "  setg %al\n";
      out << "  movzbq %al, %rax\n";
      break;
    case LEQ_OP:
      out << "  cmpq %rcx, %rax\n";
      out << "  movq $0, %rax\n";
      out << "  setle %al\n";
      out << "  movzbq %al, %rax\n";
      break;
    case GEQ_OP:
      out << "  cmpq %rcx, %rax\n";
      out << "  movq $0, %rax\n";
      out << "  setge %al\n";
      out << "  movzbq %al, %rax\n";
      break;
    case EQ_OP:
      out << "  cmpq %rcx, %rax\n";
      out << "  movq $0, %rax\n";
      out << "  sete %al\n";
      out << "  movzbq %al, %rax\n";
      break;
    case NE_OP:
      out << "  cmpq %rcx, %rax\n";
      out << "  movq $0, %rax\n";
      out << "  setne %al\n";
      out << "  movzbq %al, %rax\n";
      break;
    case AND_OP: out << "  andq %rcx, %rax\n"; break;
    case OR_OP:  out << "  orq %rcx, %rax\n";  break;
    default: break;
  }
}

// Sethi-Ullman: si 'e' es un operando "hoja" (constante o variable entera),
// lo carga DIRECTO al registro pedido con un solo mov (inmediato o memoria),
// evitando el push/pop. Devuelve false si 'e' no es hoja (hay que evaluarlo).
bool GenCodeVisitor::operandInto(Exp *e, const std::string &reg) {
  if (auto n = dynamic_cast<NumberExp*>(e)) {
    out << "  movq $" << n->value << ", " << reg << "\n";
    return true;
  }
  if (auto id = dynamic_cast<IdExp*>(e)) {
    if (memoriaGlobal.count(id->value))
      out << "  movq " << id->value << "(%rip), " << reg << "\n";
    else
      out << "  movq " << memoria[id->value] << "(%rbp), " << reg << "\n";
    return true;
  }
  return false;
}

int GenCodeVisitor::visit(BinaryExp *exp) {
  if (exp->isConstant) {
    out << "  movq $" << exp->constantValue << ", %rax\n";
    return 0;
  }

  // ---- POW_OP: strength reduction and potencia call ----
  if (exp->op == POW_OP) {
    // Check for constant exponent (strength reduction)
    bool rightIsConst = exp->right->isConstant;
    int  rightVal     = exp->right->constantValue;

    if (rightIsConst && rightVal == 2) {
      // x**2 → imulq %rax, %rax
      exp->left->accept(this);
      out << "  imulq %rax, %rax\n";
      return 0;
    }
    if (rightIsConst && rightVal == 4) {
      // x**4 → (x**2)**2 cascade
      exp->left->accept(this);
      out << "  imulq %rax, %rax\n";
      out << "  imulq %rax, %rax\n";
      return 0;
    }

    // General case: call potencia(base=%rdi, exp=%rsi)
    needsPotencia = true;
    if (exp->left->label >= exp->right->label) {
      // Evaluate left first (equal or heavier), push, then right
      exp->left->accept(this);
      out << "  pushq %rax\n";
      exp->right->accept(this);
      out << "  movq %rax, %rcx\n";
      out << "  popq %rax\n";
      // rax=left(base), rcx=right(exp)
      out << "  movq %rax, %rdi\n";
      out << "  movq %rcx, %rsi\n";
      out << "  call potencia\n";
    } else {
      // right is heavier: evaluate right first, push, then left
      exp->right->accept(this);
      out << "  pushq %rax\n";
      exp->left->accept(this);
      out << "  movq %rax, %rcx\n";
      out << "  popq %rax\n";
      out << "  xchgq %rax, %rcx\n"; // rax=left(base), rcx=right(exp)
      out << "  movq %rax, %rdi\n";
      out << "  movq %rcx, %rsi\n";
      out << "  call potencia\n";
    }
    return 0;
  }

  std::string t1 = this->deduceType(exp->left)->toString();
  std::string t2 = this->deduceType(exp->right)->toString();
  
  if (t1 == "string" || t2 == "string") {
    needsConcat = true;
    
    // Evaluate Left
    exp->left->accept(this);
    if (t1 == "int") {
      out << "  movq %rax, %rdi\n";
      out << "  call __itoa\n";
    } else if (t1 == "float") {
      out << "  call __ftoa\n";
    }
    out << "  pushq %rax\n"; // Save left string ptr
    out << "  subq $8, %rsp\n"; // Align stack to 16 bytes
    
    // Evaluate Right
    exp->right->accept(this);
    if (t2 == "int") {
      out << "  movq %rax, %rdi\n";
      out << "  call __itoa\n";
    } else if (t2 == "float") {
      out << "  call __ftoa\n";
    }
    out << "  movq %rax, %rsi\n"; // Right string ptr in rsi
    out << "  addq $8, %rsp\n"; // Restore stack alignment
    out << "  popq %rdi\n";       // Left string ptr in rdi
    
    out << "  call __runtime_concat\n";
    return 0;
  }
  
  if (t1 == "float" || t2 == "float") {
    // Evaluate Left
    exp->left->accept(this);
    if (t1 == "int") {
      out << "  cvtsi2sdq %rax, %xmm0\n";
    }
    // Push xmm0
    out << "  subq $8, %rsp\n";
    out << "  movsd %xmm0, (%rsp)\n";
    out << "  subq $8, %rsp\n"; // Align stack
    
    // Evaluate Right
    exp->right->accept(this);
    out << "  addq $8, %rsp\n"; // Restore alignment
    if (t2 == "int") {
      out << "  cvtsi2sdq %rax, %xmm0\n";
    }
    // Pop left into xmm1, move right to xmm0, swap so left is in xmm0
    out << "  movsd %xmm0, %xmm1\n";
    out << "  movsd (%rsp), %xmm0\n";
    out << "  addq $8, %rsp\n";
    
    if (exp->op == PLUS_OP) out << "  addsd %xmm1, %xmm0\n";
    else if (exp->op == MINUS_OP) out << "  subsd %xmm1, %xmm0\n";
    else if (exp->op == MUL_OP) out << "  mulsd %xmm1, %xmm0\n";
    else if (exp->op == DIV_OP) out << "  divsd %xmm1, %xmm0\n";
    else if (exp->op == EQ_OP) {
      out << "  ucomisd %xmm1, %xmm0\n";
      out << "  movq $0, %rax\n";
      out << "  sete %al\n";
      out << "  movq %rax, %xmm0\n";
    }
    out << "  movq %xmm0, %rax\n";
    return 0;
  }

  // ---- Resto de operadores: Sethi-Ullman (enteros) ----
  // La etiqueta de cada subárbol (LabelVisitor) indica cuántos registros
  // necesita. Sethi-Ullman: evaluar primero el subárbol más pesado para
  // minimizar registros vivos, y NO tocar la pila cuando un operando es hoja
  // (constante o variable) — se carga directo a un registro con un solo mov.
  bool rSimple = (dynamic_cast<NumberExp*>(exp->right) || dynamic_cast<IdExp*>(exp->right));
  bool lSimple = (dynamic_cast<NumberExp*>(exp->left)  || dynamic_cast<IdExp*>(exp->left));

  if (rSimple) {
    // right es hoja → left en %rax, right en %rcx. Cero push/pop.
    if (!operandInto(exp->left, "%rax")) exp->left->accept(this);
    operandInto(exp->right, "%rcx");
    emitOp(out, exp->op);
  } else if (lSimple) {
    // left es hoja, right compuesto → SU: evaluar el pesado (right) primero.
    exp->right->accept(this);        // %rax = right
    out << "  movq %rax, %rcx\n";    // %rcx = right
    operandInto(exp->left, "%rax");  // %rax = left  (orden correcto: left OP right)
    emitOp(out, exp->op);
  } else if (exp->left->label >= exp->right->label) {
    // Ambos compuestos, left igual o más pesado: evaluar left primero (a pila).
    // El subq/addq $8 mantiene %rsp alineado a 16 por si el otro operando
    // contiene una llamada a función (corner case f(x)+g(y)).
    exp->left->accept(this);
    out << "  pushq %rax\n";
    out << "  subq $8, %rsp\n";
    exp->right->accept(this);
    out << "  addq $8, %rsp\n";
    out << "  movq %rax, %rcx\n";
    out << "  popq %rax\n";
    emitOp(out, exp->op);
  } else {
    // Ambos compuestos, right más pesado: evaluar right primero (Sethi-Ullman).
    exp->right->accept(this);
    out << "  pushq %rax\n";
    out << "  subq $8, %rsp\n";
    exp->left->accept(this);         // %rax = left
    out << "  addq $8, %rsp\n";
    out << "  popq %rcx\n";           // %rcx = right
    emitOp(out, exp->op);
  }
  return 0;
}

// -----------------------------------------------------------------------------
// visit(UnaryExp)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(UnaryExp *exp) {
  exp->operand->accept(this);
  int lbl = labelcont++;
  out << "  cmpq $0, %rax\n";
  out << "  je not_true_" << lbl << "\n";
  out << "  movq $0, %rax\n";
  out << "  jmp not_end_" << lbl << "\n";
  out << "not_true_" << lbl << ":\n";
  out << "  movq $1, %rax\n";
  out << "not_end_" << lbl << ":\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(PrintStm)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(PrintStm *stm) {
  stm->e->accept(this);
  
  std::string t = this->deduceType(stm->e)->toString();
  if (t == "float") {
    // printf with %f expects the float in %xmm0 and %al=1
    out << "  leaq print_float_fmt(%rip), %rdi\n";
    out << "  movq $1, %rax\n";
  } else if (t == "string") {
    out << "  movq %rax, %rsi\n";
    out << "  leaq print_str_fmt(%rip), %rdi\n";
    out << "  movq $0, %rax\n";
  } else {
    out << "  movq %rax, %rsi\n";
    out << "  leaq print_fmt(%rip), %rdi\n";
    out << "  movq $0, %rax\n";
  }
  out << "  call printf@PLT\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(Body)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(Body *b) {
  for (auto dec : b->declarations)
    dec->accept(this);
  for (auto stm : b->StmList)
    stm->accept(this);
  return 0;
}

// -----------------------------------------------------------------------------
// visit(IfStm)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(IfStm *stm) {
  if (stm->condition->isConstant) {
    if (stm->condition->constantValue) {
      stm->then->accept(this);
    }
    else {
      if (stm->els) {
        stm->els->accept(this);
        }
    }
  }
  else {
    int lbl = labelcont++;
    stm->condition->accept(this);
    out << "  cmpq $0, %rax\n";
    out << "  je else_" << lbl << "\n";
    stm->then->accept(this);
    out << "  jmp endif_" << lbl << "\n";
    out << "else_" << lbl << ":\n";
    if (stm->els)
      stm->els->accept(this);
    out << "endif_" << lbl << ":\n";
  }
  return 0;
}

// -----------------------------------------------------------------------------
// visit(WhileStm)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(WhileStm *stm) {
  int lbl = labelcont++;
  std::string oldBreak = currentBreakLabel;
  currentBreakLabel = "endwhile_" + std::to_string(lbl);

  out << "while_" << lbl << ":\n";
  stm->condition->accept(this);
  out << "  cmpq $0, %rax\n";
  out << "  je endwhile_" << lbl << "\n";
  stm->b->accept(this);
  out << "  jmp while_" << lbl << "\n";
  out << "endwhile_" << lbl << ":\n";

  currentBreakLabel = oldBreak;
  return 0;
}

// -----------------------------------------------------------------------------
// visit(DoWhileStm)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(DoWhileStm *stm) {
  int lbl = labelcont++;
  std::string oldBreak = currentBreakLabel;
  currentBreakLabel = "endwhile_" + std::to_string(lbl);

  out << "dowhile_" << lbl << ":\n";
  stm->b->accept(this);
  stm->condition->accept(this);
  out << "  cmpq $0, %rax\n";
  out << "  jne dowhile_" << lbl << "\n";
  out << "endwhile_" << lbl << ":\n";

  currentBreakLabel = oldBreak;
  return 0;
}

// -----------------------------------------------------------------------------
// visit(ReturnStm)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(ReturnStm *stm) {
  stm->e->accept(this);
  out << "  jmp .end_" << nombreFuncion << "\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(BreakStm)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(BreakStm *) {
  if (currentBreakLabel.empty()) {
    std::cerr << "Error: break fuera de while, do-while o switch\n";
    exit(1);
  }
  out << "  jmp " << currentBreakLabel << "\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(SwitchStm)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(SwitchStm *stm) {
  int lbl = labelcont++;
  stm->e->accept(this);
  out << "  movq %rax, %r10\n";

  for (auto c : stm->cases) {
    out << "  movq $" << c->value << ", %rax\n";
    out << "  cmpq %rax, %r10\n";
    out << "  je case_" << lbl << "_" << c->value << "\n";
  }

  if (!stm->default_body.empty())
    out << "  jmp default_" << lbl << "\n";
  else
    out << "  jmp endswitch_" << lbl << "\n";

  std::string oldBreak = currentBreakLabel;
  currentBreakLabel = "endswitch_" + std::to_string(lbl);

  for (auto c : stm->cases) {
    out << "case_" << lbl << "_" << c->value << ":\n";
    for (auto s : c->body)
      s->accept(this);
    out << "  jmp endswitch_" << lbl << "\n";
  }

  if (!stm->default_body.empty()) {
    out << "default_" << lbl << ":\n";
    for (auto s : stm->default_body)
      s->accept(this);
  }

  currentBreakLabel = oldBreak;
  out << "endswitch_" << lbl << ":\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(FunDec) — prólogo, cuerpo y epílogo
// -----------------------------------------------------------------------------
// Suma recursivamente los bytes de TODAS las variables declaradas en un cuerpo,
// incluyendo las que viven dentro de bloques anidados (if/while/do/switch).
// Se usa para reservar el frame de la función de una sola vez.
int GenCodeVisitor::frameBytesOfBody(Body *b) {
  if (!b) return 0;
  int total = 0;
  for (auto *vd : b->declarations)
    for (auto &nombre : vd->vars)
      total += tipos.sizesVar[nombre];
  for (auto *s : b->StmList) {
    if (auto ifs = dynamic_cast<IfStm *>(s)) {
      total += frameBytesOfBody(ifs->then);
      total += frameBytesOfBody(ifs->els);
    } else if (auto ws = dynamic_cast<WhileStm *>(s)) {
      total += frameBytesOfBody(ws->b);
    } else if (auto dws = dynamic_cast<DoWhileStm *>(s)) {
      total += frameBytesOfBody(dws->b);
    } else if (auto sw = dynamic_cast<SwitchStm *>(s)) {
      // Los case/default contienen Stm sueltos; si alguno declara variables
      // dentro de bloques anidados, se suman por sus propios if/while.
      for (auto *c : sw->cases)
        for (auto *cs : c->body) {
          if (auto ifs = dynamic_cast<IfStm *>(cs)) {
            total += frameBytesOfBody(ifs->then);
            total += frameBytesOfBody(ifs->els);
          } else if (auto ws = dynamic_cast<WhileStm *>(cs)) {
            total += frameBytesOfBody(ws->b);
          }
        }
    }
  }
  return total;
}

int GenCodeVisitor::visit(FunDec *f) {
  entornoFuncion = true;
  memoria.clear();
  auto oldVariableTypes = variableTypes; // Save global types
  structAllocated.clear();
  matrixColumns.clear();
  currentMatrixParamLabels.clear();
  offset = -8;

  nombreFuncion = f->nombre;

  const std::vector<std::string> argRegs = {"%rdi", "%rsi", "%rdx",
                                            "%rcx", "%r8",  "%r9"};

  out << "\n.globl " << f->nombre << "\n";
  out << f->nombre << ":\n";
  out << "  pushq %rbp\n";
  out << "  movq %rsp, %rbp\n";
  
  int nParams = int(f->Pnombres.size());

  // ---- Cálculo del tamaño del frame ----
  // IMPORTANTE: los offsets reales de cada variable local los asigna
  // visit(VarDec) más abajo. Aquí SOLO sumamos el espacio necesario
  // (locales + parámetros). Antes este bucle también avanzaba `offset`, y como
  // visit(VarDec) lo volvía a avanzar, las variables terminaban por DEBAJO del
  // frame reservado y cualquier `pushq` durante la evaluación de expresiones
  // las corrompía (ese era el bug de `base ** exponente` dando 27 en vez de 81).
  //
  // Además, sumamos recursivamente las declaraciones DENTRO de bloques anidados
  // (if/while/do/switch), porque también se colocan en el frame de la función
  // (p. ej. `var int n1, n2` dentro del else de fibonacci).
  int localSize = frameBytesOfBody(f->cuerpo);
  localSize += 8 * nParams; // cada parámetro spilled ocupa un slot de 8

  if (localSize % 16 != 0) localSize += 8;
  out << "  subq $" << localSize << ", %rsp\n";

  // ---- Colocación de parámetros (arriba del frame: -8, -16, ...) ----
  for (int i = 0; i < nParams; i++) {
    memoria[f->Pnombres[i]]       = offset;
    variableTypes[f->Pnombres[i]] = parseType(f->Ptipos[i]);
    if (auto ptrType = dynamic_cast<PointerType*>(variableTypes[f->Pnombres[i]])) {
      tipos.sizesVar[f->Pnombres[i]] = 8; // puntero
    } else {
      tipos.sizesVar[f->Pnombres[i]] = 8; // slot uniforme de 8 bytes
    }

    if (f->Ptipos[i] == "matrix")
      currentMatrixParamLabels[f->Pnombres[i]] =
          "__cols_" + f->nombre + "_" + f->Pnombres[i];
    out << "  movq " << argRegs[i] << ", " << offset << "(%rbp)\n";
    offset -= 8; // slot uniforme de 8 bytes por parámetro
  }

  // ---- Variables locales (continúan debajo de los parámetros) ----
  for (auto dec : f->cuerpo->declarations)
    dec->accept(this);

  for (auto stm : f->cuerpo->StmList)
    stm->accept(this);

  out << ".end_" << f->nombre << ":\n";
  // Un `void main` no ejecuta return, así que %rax quedaría con basura y el
  // proceso saldría con un exit code != 0. Como main debe devolver 0 por
  // convención, lo forzamos aquí.
  if (f->nombre == "main" && f->tipo == "void")
    out << "  movq $0, %rax\n";
  out << "  leave\n";
  out << "  ret\n";

  entornoFuncion = false;
  variableTypes = oldVariableTypes; // Restore global types
  return 0;
}

// -----------------------------------------------------------------------------
// visit(FcallExp) — llamada a función con argumentos en registros ABI SysV
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(FcallExp *exp) {
  if (exp->nombre == "strlen") {
    exp->argumentos[0]->accept(this);
    out << "  movq %rax, %rdi\n";
    out << "  call strlen@PLT\n";
    return 0;
  }
  if (exp->nombre == "concat") {
    needsConcat = true;
    exp->argumentos[0]->accept(this);
    out << "  pushq %rax\n";
    exp->argumentos[1]->accept(this);
    out << "  movq %rax, %rsi\n";
    out << "  popq %rdi\n";
    out << "  call __runtime_concat\n";
    return 0;
  }

  const std::vector<std::string> argRegs = {"%rdi", "%rsi", "%rdx",
                                            "%rcx", "%r8",  "%r9"};
  int nArgs = int(exp->argumentos.size());
  
  // Evaluar cada argumento y guardarlo en la pila para no sobrescribir registros (ej. %rdi)
  for (int i = 0; i < nArgs; i++) {
    exp->argumentos[i]->accept(this);
    out << "  pushq %rax\n";

    if (funParamTypes.count(exp->nombre) &&
        i < int(funParamTypes[exp->nombre].size()) &&
        funParamTypes[exp->nombre][i] == "matrix") {
      std::string targetLabel =
          "__cols_" + exp->nombre + "_" + funParamNames[exp->nombre][i];
      LVal argLV = captureLVal(exp->argumentos[i]);
      if (argLV.kind == LValKind::Id) {
        const std::string &argName = argLV.name;
        if (matrixColumns.count(argName)) {
          out << "  movq $" << matrixColumns[argName] << ", %r10\n";
          out << "  movq %r10, " << targetLabel << "(%rip)\n";
        } else if (currentMatrixParamLabels.count(argName)) {
          out << "  movq " << currentMatrixParamLabels[argName]
              << "(%rip), %r10\n";
          out << "  movq %r10, " << targetLabel << "(%rip)\n";
        }
      }
    }
  }

  // Ahora extraer desde la pila a los registros correspondientes (en orden inverso)
  for (int i = nArgs - 1; i >= 0; i--) {
    out << "  popq " << argRegs[i] << "\n";
  }
  
  std::string targetName = exp->nombre;
  // Resolución de llamada a template (si existe en templateFunctions)
  if (templateFunctions.count(targetName)) {
    // Para simplificar, si el primer arg es string, asumimos T=string. Si no, T=int.
    bool isString = false;
    if (nArgs > 0 && isStringType(exp->argumentos[0]))
      isString = true;
    targetName = targetName + (isString ? "_string" : "_int");
    emittedTemplates.insert(targetName);
  }

  out << "  call " << targetName << "\n";
  return 0;
}

// -----------------------------------------------------------------------------
// visit(StringExp)
// -----------------------------------------------------------------------------
int GenCodeVisitor::visit(StringExp *exp) {
  if (stringPool.count(exp->value)) {
    out << "  leaq " << stringPool[exp->value] << "(%rip), %rax\n";
  } else {
    out << "  movq $0, %rax\n"; // Fallback en caso de error
  }
  return 0;
}

int GenCodeVisitor::visit(FloatExp *exp) {
  // Constant floating point value. 
  // We can inject it into a .data section, but for simplicity we load its bits into rax.
  union { double d; uint64_t i; } u;
  u.d = exp->value;
  out << "  movabsq $" << u.i << ", %rax\n";
  out << "  movq %rax, %xmm0\n";
  return 0;
}

int ConstantVisitor::plegado(Program *program) {
    program->accept(this);
    return 0;
}

int ConstantVisitor::visit(Program *p) {
  for (auto i: p->fdlist) {
    i->accept(this);
  }
  return 0;
}

int ConstantVisitor::visit(FunDec *fd) {
  fd->cuerpo->accept(this);
  return 0;
}
int ConstantVisitor::visit(Body *body) {
  for (auto dec : body->declarations)
    dec->accept(this);
  for (auto i : body->StmList) {
    i->accept(this);
  }
  return 0;
}

int ConstantVisitor::visit(ExprStm *stm) {
  if (stm->e) stm->e->accept(this);
  return 0;
}

int ConstantVisitor::visit(AssignStm *stm) {
  stm->e->accept(this);
  return 0;
}


int ConstantVisitor::visit(PrintStm *stm) {
  stm->e->accept(this);
  return 0;
}
int ConstantVisitor::visit(IfStm *stm) {
  stm->condition->accept(this);
  stm->then->accept(this);
  if (stm->els) stm->els->accept(this);
  return 0;
}

int ConstantVisitor::visit(BinaryExp *exp) {
  exp->left->accept(this);
  exp->right->accept(this);
  if (exp->left->isConstant && exp->right->isConstant) {
    exp->isConstant = true;
    int L = exp->left->constantValue;
    int R = exp->right->constantValue;
    switch (exp->op) {
      case PLUS_OP:  exp->constantValue = L + R; break;
      case MINUS_OP: exp->constantValue = L - R; break;
      case MUL_OP:   exp->constantValue = L * R; break;
      case DIV_OP:   exp->constantValue = (R != 0) ? L / R : 0; break;
      case POW_OP: {
        // Compute L^R with integer exponentiation
        int result = 1;
        int base = L, e = R;
        while (e > 0) {
          if (e & 1) result *= base;
          base *= base;
          e >>= 1;
        }
        exp->constantValue = result;
        break;
      }
      case LE_OP:  exp->constantValue = L < R;  break;
      case GT_OP:  exp->constantValue = L > R;  break;
      case LEQ_OP: exp->constantValue = L <= R; break;
      case GEQ_OP: exp->constantValue = L >= R; break;
      case EQ_OP:  exp->constantValue = L == R; break;
      case NE_OP:  exp->constantValue = L != R; break;
      case AND_OP: exp->constantValue = L && R; break;
      case OR_OP:  exp->constantValue = L || R; break;
    }
  }
  return 0;
}

int ConstantVisitor::visit(NumberExp *exp) {
  exp->isConstant = true;
  exp->constantValue = exp->value;
  return 0;
}

int ConstantVisitor::visit(IdExp *exp) {
  return 0;
}

int ConstantVisitor::visit(UnaryExp *exp) {
  return 0;
}

int ConstantVisitor::visit(IndexExp *exp) {
  return 0;
}

int ConstantVisitor::visit(MatrixExp *exp) {
  return 0;
}

int ConstantVisitor::visit(FieldExp *exp) {
  return 0;
}

int ConstantVisitor::visit(StructDec *sd) {
  return 0;
}



int ConstantVisitor::visit(ExpListSize *stm) {
  return 0;
}

int ConstantVisitor::visit(ExpListVals *stm) {
  return 0;
}

int ConstantVisitor::visit(ExpMatrixSize *stm) {
  return 0;
}

int ConstantVisitor::visit(ExpMatrixVals *stm) {
  return 0;
}

int ConstantVisitor::visit(WhileStm *stm) {
  stm->condition->accept(this);
  stm->b->accept(this);
  return 0;
}

int ConstantVisitor::visit(DoWhileStm *stm) {
  stm->b->accept(this);
  stm->condition->accept(this);
  return 0;
}



int ConstantVisitor::visit(BreakStm *stm) {
  return 0;
}

int ConstantVisitor::visit(SwitchStm *stm) {
  return 0;
}


int ConstantVisitor::visit(VarDec *vd) {
  return 0;
}

int ConstantVisitor::visit(FcallExp *fc) {
  return 0;
}

int ConstantVisitor::visit(ReturnStm *r) {
  r->e->accept(this);
  return 0;
}

int LabelVisitor::etiquetado(Program *program) {
    program->accept(this);
    return 0;
}

int LabelVisitor::visit(Program *p) {
  for (auto i: p->fdlist) {
    i->accept(this);
  }
  return 0;
}

int LabelVisitor::visit(FunDec *fd) {
  fd->cuerpo->accept(this);
  return 0;
}
int LabelVisitor::visit(Body *body) {
  for (auto dec : body->declarations)
    dec->accept(this);
  for (auto i : body->StmList) {
    i->accept(this);
  }
  return 0;
}

int LabelVisitor::visit(ExprStm *stm) {
  if (stm->e) stm->e->accept(this);
  return 0;
}

int LabelVisitor::visit(AssignStm *stm) {
  stm->e->accept(this);
  return 0;
}


int LabelVisitor::visit(PrintStm *stm) {
  stm->e->accept(this);
  return 0;
}
int LabelVisitor::visit(IfStm *stm) {
  stm->condition->accept(this);
  stm->then->accept(this);
  if (stm->els) stm->els->accept(this);
  return 0;
}


int LabelVisitor::visit(NumberExp *exp) {
  exp->label = 1;
  return 0;
}

int LabelVisitor::visit(FloatExp *exp) {
  exp->label = 1;
  return 0;
}

int LabelVisitor::visit(BinaryExp *exp) {
  exp->left->accept(this);
  exp->right->accept(this);
  if (exp->left->label == exp->right->label) {
    exp->label = exp->left->label+ 1;
  }
  else {
    exp->label = std::max(exp->left->label,exp->right->label);
  }
  return 0;
}


int LabelVisitor::visit(IdExp *exp) {
  exp->label = 1;
  return 0;
}

int LabelVisitor::visit(UnaryExp *exp) {
  return 0;
}

int LabelVisitor::visit(IndexExp *exp) {
  exp->label = 1;
  return 0;
}

int LabelVisitor::visit(MatrixExp *exp) {
  return 0;
}

int LabelVisitor::visit(FieldExp *exp) {
  exp->label = 1;
  return 0;
}

int LabelVisitor::visit(StructDec *sd) {
  return 0;
}



int LabelVisitor::visit(ExpListSize *stm) {
  return 0;
}

int LabelVisitor::visit(ExpListVals *stm) {
  return 0;
}

int LabelVisitor::visit(ExpMatrixSize *stm) {
  return 0;
}

int LabelVisitor::visit(ExpMatrixVals *stm) {
  return 0;
}

int LabelVisitor::visit(WhileStm *stm) {
  stm->condition->accept(this);
  stm->b->accept(this);
  return 0;
}

int LabelVisitor::visit(DoWhileStm *stm) {
  stm->b->accept(this);
  stm->condition->accept(this);
  return 0;
}



int LabelVisitor::visit(BreakStm *stm) {
  return 0;
}

int LabelVisitor::visit(SwitchStm *stm) {
  return 0;
}


int LabelVisitor::visit(VarDec *vd) {
  return 0;
}

int LabelVisitor::visit(FcallExp *fc) {
  // Las llamadas a función cuentan como operandos terminales en una expresión
  fc->label = 1;
  return 0;
}

int LabelVisitor::visit(ReturnStm *r) {
  r->e->accept(this);
  return 0;
}

int LabelVisitor::visit(StringExp *exp) {
  // StringExp is a terminal node, needs 1 register
  exp->label = 1;
  return 0;
}

// Etiquetado Sethi-Ullman para nodos de punteros: heredan el peso del hijo.
int LabelVisitor::visit(AddressExp *exp) {
  if (exp && exp->e) {
    exp->e->accept(this);
    exp->label = exp->e->label;
  }
  return 0;
}
int LabelVisitor::visit(DereferenceExp *exp) {
  if (exp && exp->e) {
    exp->e->accept(this);
    exp->label = exp->e->label;
  }
  return 0;
}
