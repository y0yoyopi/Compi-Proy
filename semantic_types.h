#ifndef SEMANTIC_TYPES_H
#define SEMANTIC_TYPES_H

// =============================================================================
// semantic_types.h — Sistema de tipos del análisis semántico
// =============================================================================
// Este módulo centraliza la representación de TIPOS del lenguaje. Antes estas
// clases vivían incrustadas dentro de visitor.h; ahora tienen su propio header
// para que:
//   · El TypeCheckerVisitor y el GenCodeVisitor compartan una única fuente de
//     verdad sobre qué es un tipo.
//   · Sea trivial añadir tipos nuevos (punteros a punteros, arreglos, structs)
//     sin tocar la lógica de los visitantes.
//
// Jerarquía:
//
//   Type (abstracta)
//     ├── PrimitiveType   — int, float, bool, char, string
//     └── PointerType     — T*  (envuelve un Type base)
//
// Nota de diseño: parseType() es `inline` a propósito. Al estar definida en un
// header incluido por varios .cpp, sin `inline` el enlazador vería la misma
// función definida en cada unidad de traducción y fallaría con
// "multiple definition". `inline` le dice al enlazador "fusiona las copias".
// =============================================================================

#include <string>

// ---- Tipo base abstracto ----
class Type {
public:
  virtual ~Type() = default;
  virtual std::string toString() const = 0;
};

// ---- Tipo primitivo: int, float, bool, char, string ----
class PrimitiveType : public Type {
public:
  std::string name;
  PrimitiveType(const std::string &n) : name(n) {}
  std::string toString() const override { return name; }
};

// ---- Tipo puntero: envuelve un tipo base. base->toString() + "*" ----
// Es recursivo: int** = PointerType(PointerType(PrimitiveType("int"))).
// Con esto una "matriz" deja de ser un tipo especial y pasa a ser,
// literalmente, un puntero a puntero (int**), igual que en C++.
class PointerType : public Type {
public:
  Type *base;
  PointerType(Type *b) : base(b) {}
  std::string toString() const override { return base->toString() + "*"; }
};

// ---- Convierte la representación textual de un tipo en un objeto Type ----
// Ejemplos:
//   "int"    -> PrimitiveType("int")
//   "int*"   -> PointerType(PrimitiveType("int"))
//   "int**"  -> PointerType(PointerType(PrimitiveType("int")))
inline Type *parseType(const std::string &s) {
  if (s == "int")    return new PrimitiveType("int");
  if (s == "float")  return new PrimitiveType("float");
  if (s == "bool")   return new PrimitiveType("bool");
  if (s == "char")   return new PrimitiveType("char");
  if (s == "string") return new PrimitiveType("string");

  // Cualquier tipo terminado en '*' es un puntero al tipo sin la estrella.
  if (!s.empty() && s.back() == '*') {
    std::string base = s.substr(0, s.size() - 1);
    return new PointerType(parseType(base));
  }

  // Tipos definidos por el usuario (structs) o desconocidos: se tratan como
  // un primitivo con su propio nombre para no perder la información.
  return new PrimitiveType(s.empty() ? "int" : s);
}

// ---- Utilidades de consulta (helpers) ----
// Devuelve true si el tipo textual es un puntero (termina en '*').
inline bool isPointerTypeStr(const std::string &s) {
  return !s.empty() && s.back() == '*';
}

// Quita un nivel de indirección: "int*" -> "int", "int**" -> "int*".
inline std::string derefTypeStr(const std::string &s) {
  if (isPointerTypeStr(s)) return s.substr(0, s.size() - 1);
  return s; // ya no es puntero
}

// Añade un nivel de indirección: "int" -> "int*".
inline std::string addrTypeStr(const std::string &s) { return s + "*"; }

#endif // SEMANTIC_TYPES_H
