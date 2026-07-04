#ifndef JSON_OUTPUT_H
#define JSON_OUTPUT_H

// =============================================================================
// json_output.h — Serialización a JSON para la aplicación web
// =============================================================================
// Convierte el stream de tokens y el AST a JSON. Cada nodo del AST se emite
// con una forma genérica pensada para dibujar el árbol en la interfaz:
//
//   { "kind": "BinaryExp", "label": "+", "line": 3, "col": 9,
//     "children": [ ... ] }
//
// No modifica ninguna estructura existente: recorre el AST con dynamic_cast
// (igual que deduceType en visitor.cpp), por lo que no toca el patrón Visitor.
// =============================================================================

#include <string>

class Program;

// Escapa una cadena para incrustarla en JSON (comillas, saltos de línea, etc.)
std::string jsonEscape(const std::string &s);

// Tokeniza 'input' completo y devuelve un arreglo JSON de tokens:
//   [{"type":"ID","text":"x","line":1,"col":5}, ...]
// Si encuentra un error léxico, corta ahí y deja el mensaje en 'lexError'
// (queda vacío si no hubo error).
std::string tokensToJson(const std::string &input, std::string &lexError);

// Serializa el AST completo (Program) al formato genérico de nodos.
std::string astToJson(Program *p);

#endif // JSON_OUTPUT_H
