#ifndef PARSER_H
#define PARSER_H

// =============================================================================
// parser.h — Definición del Parser (analizador sintáctico)
// =============================================================================
// Implementa un parser descendente recursivo (LL) que consume tokens del
// Scanner y construye el Árbol de Sintaxis Abstracta (AST).
//
// Gramática soportada (simplificada):
//   Program   → VarDec* FunDec*
//   FunDec    → 'fun' ID ID '(' Params ')' Body 'endfun'
//   Body      → VarDec* Stm (';' Stm)*
//   VarDec    → 'var' ID ID (',' ID)*
//   Stm       → AssignStm | PrintStm | ReturnStm | IfStm | WhileStm
//   Exp       → CE | BE | E | T | F
// =============================================================================

#include "ast.h"
#include "scanner.h"
#include <vector>

class Parser {
private:
  Scanner *scanner; // Fuente de tokens
  Token *current;   // Token actual (lookahead)
  Token *previous;  // Token anterior (ya consumido)

  std::vector<Token*> tokens; // Todos los tokens (para lookahead arbitrario)
  size_t pos;                 // Posición actual en 'tokens'

  // ---- Primitivas de consumo ----
  bool match(Token::Type ttype); // Consume el token si coincide
  bool check(Token::Type ttype); // Verifica sin consumir
  bool advance();                // Avanza al siguiente token
  bool isAtEnd();                // ¿Llegamos al END?
  Token::Type peekType(int k);   // Tipo del token a k posiciones (lookahead)
  bool isTypeStart();            // ¿El token actual inicia un Tipo/declaración?
  std::string parseType();       // Lee un tipo C++: [struct] id ('*'|'**')*

  // ---- Reporte de errores ----
  // Lanza una excepción con mensaje contextual indicando qué se esperaba
  // y cuál token se encontró.
  void error(const std::string &expected);

  // Versión que exige que el token actual sea 'ttype'; si no, lanza error.
  void expect(Token::Type ttype);

public:
  Parser(Scanner *scanner);

  // ---- Reglas de la gramática ----
  Program *parseProgram();
  StructDec *parseStructDec();
  FunDec *parseFunDec();
  Body *parseBody();
  VarDec *parseVarDec();
  Stm *parseStm();        // Envuelve parseStmImpl y estampa línea/columna
  Stm *parseStmImpl();
  Exp *parseCE();         // Comparison Expression (OR): LogicalOr
  Exp *parseLogicalAnd(); // Logical AND
  Exp *parseRelExp();     // Relational expressions (<, >, <=, >=, ==, !=)
  Exp *parseBE();         // Binary Expression: E (('+' | '-') E)*
  Exp *parseE();          // Expression: T (('*' | '/') T)*
  Exp *parseT();          // Term: F ('**' F)?
  Exp *parseF();          // Envuelve parseFImpl y estampa línea/columna
  Exp *parseFImpl();      // Factor: NUM | ID | '(' CE ')' | FcallExp | '!' F
};

#endif // PARSER_H
