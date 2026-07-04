#ifndef TOKEN_H
#define TOKEN_H

// =============================================================================
// token.h — Definición de la clase Token y sus tipos
// =============================================================================
// Representa la unidad léxica mínima producida por el Scanner.
// Cada Token tiene un tipo (Type) y el texto literal del lexema.
// =============================================================================

#include <ostream>
#include <string>

class Token {
public:
  // -------------------------------------------------------------------------
  // Tipos de token reconocidos por el lenguaje
  // -------------------------------------------------------------------------
  enum Type {
    // Operadores aritméticos
    PLUS,  // +
    MINUS, // -
    MUL,   // *
    DIV,   // /
    POW,   // **

    // Delimitadores
    LPAREN,   // (
    RPAREN,   // )
    LBRACKET, // [
    RBRACKET, // ]
    LBRACE,   // {
    RBRACE,   // }
    SEMICOL,  // ;
    COLON,    // :  (para case N: al estilo C++)
    COMA,     // ,
    DOT,      // .

    // Operadores relacionales
    LE,  // <
    GT,  // >
    LEQ, // <=
    GEQ, // >=
    EQ,  // ==
    NE,  // !=

    // Operadores lógicos
    AND, // &&
    AMP, // &  (dirección de / address-of)
    OR,  // ||
    NOT, // !

    // Operadores de asignación
    ASSIGN, // =

    // Literales
    NUM,        // Número entero
    FLOAT_LIT,  // Número de punto flotante
    TRUE,       // true
    FALSE,      // false
    STRING_LIT, // "..."  cadena de caracteres

    // Identificadores y palabras reservadas
    ID,       // Identificador de usuario
    SQRT,     // sqrt
    PRINT,    // print
    TEMPLATE, // template
    AUTO,     // auto

    // Control de flujo
    IF,        // if
    THEN,      // then
    ELSE,      // else
    ENDIF,     // endif
    WHILE,     // while
    DOWHILE,   // dowhile
    DO,        // do
    ENDWHILE,  // endwhile
    ENDDO,     // enddo
    BREAK,     // break
    SWITCH,    // switch
    CASE,      // case
    DEFAULT,   // default
    NEW,       // new
    ENDSWITCH, // endswitch

    // Declaraciones
    VAR,    // var
    STRUCT, // struct

    // Funciones
    FUN,    // fun
    ENDFUN, // endfun
    RETURN, // return

    // Especiales
    ERR, // Carácter no reconocido (error léxico)
    END  // Fin de la entrada
  };

  // -------------------------------------------------------------------------
  // Atributos públicos
  // -------------------------------------------------------------------------
  Type type;        // Tipo del token
  std::string text; // Texto literal del lexema
  int line = 0;     // Línea donde inicia el lexema (1-based)
  int col = 0;      // Columna donde inicia el lexema (1-based)

  // -------------------------------------------------------------------------
  // Constructores
  // -------------------------------------------------------------------------
  Token(Type type);
  Token(Type type, char c);
  Token(Type type, const std::string &source, int first, int last);

  // -------------------------------------------------------------------------
  // Nombre legible del tipo (útil para mensajes de error)
  // -------------------------------------------------------------------------
  static std::string typeName(Type t);

  // -------------------------------------------------------------------------
  // Operadores de salida
  // -------------------------------------------------------------------------
  friend std::ostream &operator<<(std::ostream &outs, const Token &tok);
  friend std::ostream &operator<<(std::ostream &outs, const Token *tok);
};

#endif // TOKEN_H
