# Gramática (sintaxis C++)

Esta gramática refleja **lo que el parser acepta hoy**, tras migrar la sintaxis
para que sea fiel a C++. Está mapeada 1:1 contra `parser.cpp`.

Cambios de estilo respecto de la versión anterior (basada en palabras clave):
- **Sin `var`**: las variables se declaran como en C++ -> `int x, y;`.
- **Funciones con llaves**: `Tipo nombre(params) { ... }` (sin `fun`/`endfun`).
- **Condiciones entre paréntesis y bloques con llaves**: `if (c) { }`, `while (c) { }`.
- **`do { } while (c);`** al estilo C++.
- **`switch (e) { case N: ...; break; default: ...; }`** con dos puntos.
- **`;` obligatorio** al final de cada sentencia y declaración.
- `return CE;` (con o sin paréntesis en la expresión).

```ebnf
Program     ::= ( StructDec | VarDec | FunDec )*

StructDec   ::= 'struct' id '{' VarDec* '}' ';'?

VarDec      ::= Type id [ '=' CE ] { ',' id [ '=' CE ] }* ';'

Type        ::= 'auto'
             | int | float | string | bool | char | void
             | list | matrix
             | id | 'struct' id
             | Type ('*'|'**')                        (* punteros: int*, int** *)

FunDec      ::= [ 'template' '<' id '>' ] Type id '(' Params ')' '{' Body '}'

Params      ::= e | Type id { ',' Type id }*

Body        ::= ( VarDec | Stm )*        (* declaraciones al inicio del bloque *)

Stm         ::= lvalue '=' CE ';'
             | '*' F '=' CE ';'                        (* *p = CE, **pp = CE *)
             | id '(' Args ')' ';'                     (* llamada como sentencia *)
             | 'print' '(' CE ')' ';'
             | 'return' [ CE ] ';'
             | 'if' '(' CE ')' '{' Body '}' [ 'else' ( '{' Body '}' | Stm ) ]
             | 'while' '(' CE ')' '{' Body '}'
             | 'do' '{' Body '}' 'while' '(' CE ')' ';'
             | 'switch' '(' CE ')' '{' ( 'case' num ':' Stm* )* [ 'default' ':' Stm* ] '}'
             | 'break' ';'

lvalue      ::= id | id '[' CE ']' | id '[' CE ']' '[' CE ']' | id '.' id

CE          ::= LogicalAnd { '||' LogicalAnd }*
LogicalAnd  ::= RelExp { '&&' RelExp }*
RelExp      ::= BE { ( '<' | '>' | '<=' | '>=' | '==' | '!=' ) BE }*
BE          ::= E { ( '+' | '-' ) E }*
E           ::= T { ( '*' | '/' ) T }*
T           ::= F                                      (* la potencia ya no es '**' *)

F           ::= num | float_lit | string_lit | 'true' | 'false'
             | '!' F | '(' CE ')'
             | 'pow' '(' CE ',' CE ')'                 (* exponenciacion: pow(base, exp) *)
             | id | id '(' Args ')'
             | id '[' CE ']' | id '[' CE ']' '[' CE ']' | id '.' id
             | NewExp
             | '&' F                                   (* direccion de: &x *)
             | '*' F | '**' F                          (* desreferencia: *p, **pp *)

NewExp      ::= 'new' id '[' CE ']'
             | 'new' id '[' CE ']' '[' CE ']'
             | 'new' id '[' CE ']' '[' CE ']' '{' Args '}'
             | 'new' id '{' Args '}'

Args        ::= e | CE { ',' CE }*
```

## Notas de implementación
- **Distinción declaracion/sentencia**: al inicio de una sentencia, el parser
  mira hacia adelante (lookahead) -- si ve un tipo seguido (tras `*`/`**`) de un
  identificador (`int x`, `Vec3 v`, `int* p`), es una **declaracion**; si ve
  `id =`, `id(`, `id[`, `id.`, es una **sentencia**. Para ello el parser
  tokeniza toda la entrada por adelantado.
- **`**`**: ahora es **exclusivamente** puntero/desreferencia doble (`int**`,
  `**pp`). La **exponenciación se escribe `pow(base, exp)`**. Esto evita el
  choque con C++, donde `a ** b` significaría `a * (*b)` (multiplicar por la
  desreferencia). `pow(...)` reutiliza internamente el mismo operador de
  potencia, así que conserva sus optimizaciones (reducción de fuerza para
  exponentes 2 y 4, y potencia por Divide & Conquer O(log n)).
- **Comentarios** estilo C++: `// línea` y `/* bloque */`.
- **Memoria dinámica**: `new` genera `malloc` en tiempo de ejecución. En
  `new id[CE]` el tamaño `CE` se evalúa en runtime (arreglos de tamaño
  variable). Reservan en heap: listas, matrices y structs. Ver
  `inputs/input28.txt`.
- **`print(...)`** se mantiene como builtin (equivalente conceptual de `cout`);
  migrar a `cout << ... ;` seria el siguiente paso de fidelidad lexica.
- **Declaraciones al inicio del bloque**: el modelo actual ejecuta las
  declaraciones (con sus inicializadores) antes que las sentencias del mismo
  bloque; por eso las variables se declaran al comienzo (estilo C valido). Una
  declaracion a mitad de bloque cuyo inicializador dependa de una sentencia
  previa es la unica construccion no soportada con exactitud.
- **Todos los tests** de `inputs/` y `inputs/` están en esta sintaxis C++ (se
  convirtieron desde la sintaxis anterior y se re-verificaron uno por uno).

## Ejemplo (sintaxis actual)
```cpp
int factorial(int n) {
    int ans;
    if (n <= 1) {
        ans = 1;
    } else {
        ans = n * factorial(n - 1);
    }
    return ans;
}

int main() {
    int i, acc;
    acc = 0;
    i = 1;
    while (i <= 5) {
        acc = acc + pow(i, 2);
        i = i + 1;
    }
    print(acc);          // 55
    print(factorial(6)); // 720
    return 0;
}
```
