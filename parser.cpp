// =============================================================================
// parser.cpp — Implementación del Parser (analizador sintáctico descendente)
// =============================================================================

#include "parser.h"
#include "ast.h"
#include "scanner.h"
#include "token.h"
#include <iostream>
#include <stdexcept>
#include <string>

// =============================================================================
// Constructor
// =============================================================================

Parser::Parser(Scanner *sc) : scanner(sc), previous(nullptr), pos(0) {
  // Tokenizamos toda la entrada por adelantado para poder mirar hacia
  // adelante (lookahead), necesario para distinguir declaraciones de
  // sentencias en sintaxis C++ (p. ej. 'int x;' vs 'x = 5;').
  while (true) {
    Token *t = scanner->nextToken();
    if (t->type == Token::ERR) {
      throw std::runtime_error("Error léxico [línea " +
                               std::to_string(t->line) + ", col " +
                               std::to_string(t->col) +
                               "]: carácter no reconocido '" + t->text + "'");
    }
    tokens.push_back(t);
    if (t->type == Token::END) break;
  }
  current = tokens[0];
  previous = nullptr;
}

// =============================================================================
// Primitivas de consumo de tokens
// =============================================================================

bool Parser::isAtEnd() { return current->type == Token::END; }

bool Parser::check(Token::Type ttype) {
  if (isAtEnd())
    return false;
  return current->type == ttype;
}

// Tipo del token a 'k' posiciones desde el actual (0 = actual). END si se pasa.
Token::Type Parser::peekType(int k) {
  size_t idx = pos + k;
  if (idx >= tokens.size()) return Token::END;
  return tokens[idx]->type;
}

bool Parser::advance() {
  if (!isAtEnd()) {
    previous = current;
    pos++;
    current = tokens[pos];
    return true;
  }
  return false;
}

bool Parser::match(Token::Type ttype) {
  if (check(ttype)) {
    advance();
    return true;
  }
  return false;
}

// =============================================================================
// Reporte de errores
// =============================================================================

// error — construye un mensaje indicando qué se esperaba vs. qué se encontró.
void Parser::error(const std::string &expected) {
  std::string found;
  if (isAtEnd()) {
    found = "fin de entrada";
  } else {
    found = Token::typeName(current->type);
    if (!current->text.empty())
      found += " '" + current->text + "'";
  }
  throw std::runtime_error("Error sintáctico [línea " +
                           std::to_string(current->line) + ", col " +
                           std::to_string(current->col) + "]: se esperaba " +
                           expected + ", pero se encontró " + found);
}

// expect — consume el token si coincide; si no, lanza error descriptivo.
void Parser::expect(Token::Type ttype) {
  if (!match(ttype))
    error(Token::typeName(ttype));
}

// =============================================================================
// Reglas gramaticales
// =============================================================================

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Helpers de tipos (sintaxis C++)
// -----------------------------------------------------------------------------
// Lee un tipo: [struct] id ('*'|'**')*  |  auto
std::string Parser::parseType() {
  std::string t;
  if (match(Token::AUTO)) {
    t = "auto";
  } else if (match(Token::STRUCT)) {
    if (!match(Token::ID)) error("nombre de estructura después de 'struct'");
    t = previous->text;
  } else if (match(Token::ID)) {
    t = previous->text;
  } else {
    error("un tipo");
  }
  while (check(Token::MUL) || check(Token::POW)) {
    if (match(Token::POW)) t += "**"; else { match(Token::MUL); t += "*"; }
  }
  return t;
}

// ¿El token actual inicia una declaración (un tipo)?  Distingue 'int x' de
// 'x = ...' mirando adelante: un ID seguido (tras '*'/'**') de otro ID.
bool Parser::isTypeStart() {
  if (check(Token::AUTO) || check(Token::STRUCT)) return true;
  if (check(Token::ID)) {
    int k = 1;
    while (peekType(k) == Token::MUL || peekType(k) == Token::POW) k++;
    return peekType(k) == Token::ID; // 'Tipo nombre'
  }
  return false;
}

// Program → (StructDec | VarDec | FunDec)*   (sintaxis C++)
// -----------------------------------------------------------------------------
Program *Parser::parseProgram() {
  Program *p = new Program();

  while (!isAtEnd()) {
    // struct id { ... }  → definición de estructura
    if (check(Token::STRUCT) && peekType(1) == Token::ID &&
        peekType(2) == Token::LBRACE) {
      p->sdlist.push_back(parseStructDec());
      match(Token::SEMICOL); // ';' opcional tras la definición
      continue;
    }
    // template<...> ... → función genérica
    if (check(Token::TEMPLATE)) {
      p->fdlist.push_back(parseFunDec());
      continue;
    }
    // Distinguir función (Tipo nombre '(') de variable global (Tipo nombre ...)
    if (isTypeStart()) {
      // lookahead: saltar tipo (+ '*'/'**') y nombre; ¿sigue '('?
      int k = 0;
      if (peekType(k) == Token::STRUCT) k++;
      k++; // id del tipo (o auto)
      while (peekType(k) == Token::MUL || peekType(k) == Token::POW) k++;
      k++; // nombre
      if (peekType(k) == Token::LPAREN)
        p->fdlist.push_back(parseFunDec());
      else
        p->vdlist.push_back(parseVarDec()); // global; parseVarDec consume ';'
      continue;
    }
    error("una declaración de estructura, variable o función");
  }

  // A cerr para no contaminar stdout (el modo --json emite JSON por stdout)
  std::cerr << "Parser exitoso" << std::endl;
  return p;
}

// StructDec → 'struct' id '{' (VarDec)* '}'      (campos estilo C++: int x, y;)
StructDec *Parser::parseStructDec() {
  StructDec *sd = new StructDec();
  sd->line = current->line;
  sd->col = current->col;
  expect(Token::STRUCT);
  if (!match(Token::ID))
    error("nombre de estructura después de 'struct'");
  sd->name = previous->text;
  expect(Token::LBRACE);
  while (!check(Token::RBRACE) && !isAtEnd()) {
    sd->fields.push_back(parseVarDec()); // cada campo termina en ';'
  }
  expect(Token::RBRACE);
  return sd;
}

// -----------------------------------------------------------------------------
// VarDec → Type id [ '=' CE ] { ',' id [ '=' CE ] }* ';'     (sintaxis C++)
//   Ej.: int x, y = 3;   int* p;   Vec3 v;   auto z = 5.5;
// -----------------------------------------------------------------------------
VarDec *Parser::parseVarDec() {
  VarDec *vd = new VarDec();
  vd->line = current->line;
  vd->col = current->col;
  vd->type = parseType();

  if (!match(Token::ID))
    error("nombre de variable después del tipo '" + vd->type + "'");
  vd->vars.push_back(previous->text);
  if (match(Token::ASSIGN)) {
    vd->inits.push_back(parseCE());
  } else {
    if (vd->type == "auto") error("La variable 'auto' requiere inicialización");
    vd->inits.push_back(nullptr);
  }

  while (match(Token::COMA)) {
    if (!match(Token::ID))
      error("nombre de variable después de ','");
    vd->vars.push_back(previous->text);
    if (match(Token::ASSIGN)) {
      vd->inits.push_back(parseCE());
    } else {
      if (vd->type == "auto") error("La variable 'auto' requiere inicialización");
      vd->inits.push_back(nullptr);
    }
  }

  expect(Token::SEMICOL); // C++: la declaración termina en ';'
  return vd;
}

// -----------------------------------------------------------------------------
// FunDec → [template<id>] Type id '(' Params ')' '{' Body '}'   (sintaxis C++)
// -----------------------------------------------------------------------------
FunDec *Parser::parseFunDec() {
  FunDec *fd = new FunDec();
  fd->line = current->line;
  fd->col = current->col;

  if (match(Token::TEMPLATE)) {
    expect(Token::LE); // '<'
    if (!match(Token::ID))
      error("nombre de parámetro de template (ej. T)");
    fd->templateParam = previous->text;
    expect(Token::GT); // '>'
    fd->isTemplate = true;
  }

  fd->tipo = parseType(); // tipo de retorno (admite punteros: int*, ...)

  if (!match(Token::ID))
    error("nombre de función después del tipo '" + fd->tipo + "'");
  fd->nombre = previous->text;

  expect(Token::LPAREN);
  while (!check(Token::RPAREN) && !isAtEnd()) {
    std::string ptype = parseType();
    if (!match(Token::ID))
      error("nombre de parámetro después del tipo '" + ptype + "'");
    fd->Ptipos.push_back(ptype);
    fd->Pnombres.push_back(previous->text);
    if (check(Token::RPAREN)) break;
    if (!match(Token::COMA))
      error("',' o ')' en la lista de parámetros de '" + fd->nombre + "'");
  }
  expect(Token::RPAREN);

  expect(Token::LBRACE);
  fd->cuerpo = parseBody();
  expect(Token::RBRACE);
  return fd;
}

// -----------------------------------------------------------------------------
// Body → ( VarDec | Stm )*      hasta '}'      (sintaxis C++)
//   Las declaraciones se enrutan a 'declarations' y las sentencias a 'StmList'.
// -----------------------------------------------------------------------------
Body *Parser::parseBody() {
  Body *b = new Body();
  while (!check(Token::RBRACE) && !isAtEnd()) {
    if (match(Token::SEMICOL)) continue;      // sentencia vacía ';' (C++)
    if (isTypeStart()) {
      b->declarations.push_back(parseVarDec()); // consume ';'
    } else {
      b->StmList.push_back(parseStm());         // cada sentencia consume su ';'
    }
  }
  return b;
}

// -----------------------------------------------------------------------------
// Stm (sintaxis C++). Cada sentencia simple termina en ';'.
// parseStm envuelve a parseStmImpl para estampar línea/columna en el nodo.
// -----------------------------------------------------------------------------
Stm *Parser::parseStm() {
  int ln = current->line, cl = current->col;
  Stm *s = parseStmImpl();
  if (s && s->line == 0) {
    s->line = ln;
    s->col = cl;
  }
  return s;
}

Stm *Parser::parseStmImpl() {
  // ---- Asignación por desreferencia: *p = CE;  **pp = CE; ----
  if (match(Token::POW)) {
    Exp *ptr = parseF();
    Exp *target = new DereferenceExp(new DereferenceExp(ptr));
    expect(Token::ASSIGN);
    Exp *rhs = parseCE();
    expect(Token::SEMICOL);
    return new AssignStm(target, rhs);
  }
  if (match(Token::MUL)) {
    Exp *ptr = parseF();
    Exp *target = new DereferenceExp(ptr);
    expect(Token::ASSIGN);
    Exp *rhs = parseCE();
    expect(Token::SEMICOL);
    return new AssignStm(target, rhs);
  }

  // ---- Print: print(CE); ----
  if (match(Token::PRINT)) {
    expect(Token::LPAREN);
    Exp *e = parseCE();
    expect(Token::RPAREN);
    expect(Token::SEMICOL);
    return new PrintStm(e);
  }

  // ---- Return: return CE;  |  return; ----
  if (match(Token::RETURN)) {
    ReturnStm *r = new ReturnStm();
    if (check(Token::SEMICOL)) {   // return;  (void)
      r->e = new NumberExp(0);
    } else {                        // return CE;  (CE puede empezar con '(')
      r->e = parseCE();
    }
    expect(Token::SEMICOL);
    return r;
  }

  // ---- If: if (CE) { Body } [ else { Body } | else if ... ] ----
  if (match(Token::IF)) {
    expect(Token::LPAREN);
    Exp *cond = parseCE();
    expect(Token::RPAREN);
    expect(Token::LBRACE);
    Body *tb = parseBody();
    expect(Token::RBRACE);
    Body *fb = nullptr;
    if (match(Token::ELSE)) {
      if (check(Token::IF)) {              // else if ...
        fb = new Body();
        fb->StmList.push_back(parseStm());
      } else {
        expect(Token::LBRACE);
        fb = parseBody();
        expect(Token::RBRACE);
      }
    }
    return new IfStm(cond, tb, fb);
  }

  // ---- While: while (CE) { Body } ----
  if (match(Token::WHILE)) {
    expect(Token::LPAREN);
    Exp *cond = parseCE();
    expect(Token::RPAREN);
    expect(Token::LBRACE);
    Body *b = parseBody();
    expect(Token::RBRACE);
    return new WhileStm(cond, b);
  }

  // ---- Do-While: do { Body } while (CE); ----
  if (match(Token::DO)) {
    expect(Token::LBRACE);
    Body *b = parseBody();
    expect(Token::RBRACE);
    if (!match(Token::WHILE) && !match(Token::DOWHILE))
      error("'while' después del cuerpo de 'do'");
    expect(Token::LPAREN);
    Exp *cond = parseCE();
    expect(Token::RPAREN);
    expect(Token::SEMICOL);
    return new DoWhileStm(b, cond);
  }

  // ---- Break: break; ----
  if (match(Token::BREAK)) {
    expect(Token::SEMICOL);
    return new BreakStm();
  }

  // ---- Switch: switch (CE) { case num: Stm* ... default: Stm* } ----
  if (match(Token::SWITCH)) {
    expect(Token::LPAREN);
    Exp *expr = parseCE();
    expect(Token::RPAREN);
    expect(Token::LBRACE);
    SwitchStm *sw = new SwitchStm(expr);
    while (match(Token::CASE)) {
      if (!match(Token::NUM))
        error("número después de 'case'");
      int value = std::stoi(previous->text);
      expect(Token::COLON);
      CaseStm *c = new CaseStm(value);
      while (!check(Token::CASE) && !check(Token::DEFAULT) &&
             !check(Token::RBRACE) && !isAtEnd()) {
        c->body.push_back(parseStm());
      }
      sw->cases.push_back(c);
    }
    if (match(Token::DEFAULT)) {
      expect(Token::COLON);
      while (!check(Token::RBRACE) && !isAtEnd()) {
        sw->default_body.push_back(parseStm());
      }
    }
    expect(Token::RBRACE);
    return sw;
  }

  // ---- Comienza con ID: llamada, o asignación a lvalue ----
  if (match(Token::ID)) {
    std::string variable = previous->text;
    int idLine = previous->line, idCol = previous->col;

    // Llamada a función como sentencia: foo(args);
    if (match(Token::LPAREN)) {
      FcallExp *call = new FcallExp();
      call->line = idLine;
      call->col = idCol;
      call->nombre = variable;
      if (!check(Token::RPAREN)) {
        call->argumentos.push_back(parseCE());
        while (match(Token::COMA)) call->argumentos.push_back(parseCE());
      }
      expect(Token::RPAREN);
      expect(Token::SEMICOL);
      return new ExprStm(call);
    }

    // lvalue: id | id[CE] | id[CE][CE] | id.id
    Exp *var = nullptr;
    if (match(Token::LBRACKET)) {
      Exp *idx = parseCE();
      expect(Token::RBRACKET);
      if (match(Token::LBRACKET)) {
        Exp *col = parseCE();
        expect(Token::RBRACKET);
        var = new MatrixExp(variable, idx, col);
      } else {
        var = new IndexExp(variable, idx);
      }
    } else if (match(Token::DOT)) {
      if (!match(Token::ID))
        error("nombre de campo después de '.'");
      var = new FieldExp(variable, previous->text);
    } else {
      var = new IdExp(variable);
    }
    var->line = idLine;
    var->col = idCol;
    expect(Token::ASSIGN);
    Exp *rhs = parseCE();
    expect(Token::SEMICOL);
    return new AssignStm(var, rhs);
  }

  error("inicio de sentencia (identificador, 'print', 'return', 'if', "
        "'while', 'do', 'break', 'switch' o '*')");
  return nullptr;
}

// =============================================================================
// Reglas de expresiones (precedencia ascendente)
// =============================================================================

// LogicalOr → LogicalAnd ('||' LogicalAnd)*
Exp *Parser::parseCE() {
  Exp *l = parseLogicalAnd();
  while (match(Token::OR)) {
    Exp *r = parseLogicalAnd();
    l = new BinaryExp(l, r, OR_OP);
  }
  return l;
}

// LogicalAnd → RelExp ('&&' RelExp)*
Exp *Parser::parseLogicalAnd() {
  Exp *l = parseRelExp();
  while (match(Token::AND)) {
    Exp *r = parseRelExp();
    l = new BinaryExp(l, r, AND_OP);
  }
  return l;
}

// RelExp → BE (('<'|'>'|'<='|'>='|'=='|'!=') BE)*
Exp *Parser::parseRelExp() {
  Exp *l = parseBE();
  while (true) {
    if (match(Token::LE)) {
      Exp *r = parseBE();
      l = new BinaryExp(l, r, LE_OP);
    } else if (match(Token::GT)) {
      Exp *r = parseBE();
      l = new BinaryExp(l, r, GT_OP);
    } else if (match(Token::LEQ)) {
      Exp *r = parseBE();
      l = new BinaryExp(l, r, LEQ_OP);
    } else if (match(Token::GEQ)) {
      Exp *r = parseBE();
      l = new BinaryExp(l, r, GEQ_OP);
    } else if (match(Token::EQ)) {
      Exp *r = parseBE();
      l = new BinaryExp(l, r, EQ_OP);
    } else if (match(Token::NE)) {
      Exp *r = parseBE();
      l = new BinaryExp(l, r, NE_OP);
    } else {
      break;
    }
  }
  return l;
}

// BE → E (('+' | '-') E)*
Exp *Parser::parseBE() {
  Exp *l = parseE();
  while (match(Token::PLUS) || match(Token::MINUS)) {
    BinaryOp op = (previous->type == Token::PLUS) ? PLUS_OP : MINUS_OP;
    Exp *r = parseE();
    l = new BinaryExp(l, r, op);
  }
  return l;
}

// E → T (('*' | '/') T)*
Exp *Parser::parseE() {
  Exp *l = parseT();
  while (match(Token::MUL) || match(Token::DIV)) {
    BinaryOp op = (previous->type == Token::MUL) ? MUL_OP : DIV_OP;
    Exp *r = parseT();
    l = new BinaryExp(l, r, op);
  }
  return l;
}

// T → F ('**' F)?
Exp *Parser::parseT() {
  // La exponenciación ya no usa '**' (que ahora es solo doble puntero/deref).
  // Ahora se escribe pow(base, exp) — se maneja en parseF.
  return parseF();
}

// F → NUM | 'true' | 'false' | '!' F | '(' CE ')' | ID ('(' Args ')')?
// parseF envuelve a parseFImpl para estampar línea/columna en el nodo.
Exp *Parser::parseF() {
  int ln = current->line, cl = current->col;
  Exp *e = parseFImpl();
  if (e && e->line == 0) {
    e->line = ln;
    e->col = cl;
  }
  return e;
}

Exp *Parser::parseFImpl() {
  // Operador unario NOT
  if (match(Token::NOT)) {
    Exp *operand = parseF();
    return new UnaryExp(operand);
  }

  // Dirección de (address-of), notación C++: &x
  if (match(Token::AMP)) {
    Exp *operand = parseF();
    return new AddressExp(operand);
  }

  // Desreferencia, notación C++: *p  (el '*' binario de multiplicación se
  // consume en parseE entre factores; aquí, en posición de factor, es deref).
  // '**' llega como POW → doble desreferencia.
  if (match(Token::POW)) {
    Exp *operand = parseF();
    return new DereferenceExp(new DereferenceExp(operand));
  }
  if (match(Token::MUL)) {
    Exp *operand = parseF();
    return new DereferenceExp(operand);
  }

  // Literal de cadena (String)
  if (match(Token::STRING_LIT)) {
    return new StringExp(previous->text);
  }

  // Número literal
  if (match(Token::NUM))
    return new NumberExp(std::stoi(previous->text));
    
  // Punto Flotante
  if (match(Token::FLOAT_LIT))
    return new FloatExp(std::stod(previous->text));

  // Booleanos como enteros
  if (match(Token::TRUE))
    return new NumberExp(1);
  if (match(Token::FALSE))
    return new NumberExp(0);

  // Expresión entre paréntesis
  if (match(Token::LPAREN)) {
    Exp *e = parseCE();
    expect(Token::RPAREN);
    return e;
  }

  if (match(Token::NEW)) {
    match(Token::ID);
    std::string type = previous->text;
    // a.1) id = new ID[CE]
    if (match(Token::LBRACKET)) {
      Exp *first = parseCE();
      expect(Token::RBRACKET);
      if (match(Token::LBRACKET)) {
        Exp *second = parseCE();
        expect(Token::RBRACKET);
        if (match(Token::LBRACE)) {
          ExpMatrixVals *e = new ExpMatrixVals(type, first, second);
          if (!check(Token::RBRACE)) {
            e->values.push_back(parseCE());
            while (match(Token::COMA))
              e->values.push_back(parseCE());
          }
          expect(Token::RBRACE);
          return e;
        }
        return new ExpMatrixSize(type, first, second);
      }
      return new ExpListSize(type, first);
    }
    // a.2) id = new ID{CE (, CE)*}
    else if (match(Token::LBRACE)) {
      ExpListVals *e = new ExpListVals(type);
      if (!check(Token::RBRACE)) {
        e->values.push_back(parseCE());
        while (match(Token::COMA))
          e->values.push_back(parseCE());
      }

      expect(Token::RBRACE);
      return e;
    }
  }

  // Identificador o llamada a función
  if (match(Token::ID)) {
    std::string nom = previous->text;
    // Exponenciación como función: pow(base, exp) → BinaryExp(POW_OP)
    // (conserva las optimizaciones de potencia: reducción de fuerza, D&C).
    if (nom == "pow" && check(Token::LPAREN)) {
      advance(); // '('
      Exp *base = parseCE();
      expect(Token::COMA);
      Exp *expo = parseCE();
      expect(Token::RPAREN);
      return new BinaryExp(base, expo, POW_OP);
    }
    if (check(Token::LPAREN)) {
      // Llamada a función: ID '(' (CE (',' CE)*)? ')'
      advance(); // consume '('
      FcallExp *fcall = new FcallExp();
      fcall->nombre = nom;
      if (!check(Token::RPAREN)) {
        fcall->argumentos.push_back(parseCE());
        while (match(Token::COMA))
          fcall->argumentos.push_back(parseCE());
      }
      expect(Token::RPAREN);
      return fcall;
    }
    // ID[CE]
    else if (match(Token::LBRACKET)) {
      Exp *t = parseCE();
      expect(Token::RBRACKET);
      if (match(Token::LBRACKET)) {
        Exp *col = parseCE();
        expect(Token::RBRACKET);
        return new MatrixExp(nom, t, col);
      }
      return new IndexExp(nom, t);
    }
    else if (match(Token::DOT)) {
      if (!match(Token::ID))
        error("nombre de campo despues de '.'");
      return new FieldExp(nom, previous->text);
    }
    return new IdExp(nom);
  }

  error("expresión: número, identificador, 'true', 'false' o '('");
  return nullptr; // inalcanzable
}
