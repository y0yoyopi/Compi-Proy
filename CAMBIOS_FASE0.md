# Fase 0 — Estabilización del compilador y `semantic_types.h`

Este documento explica **qué se cambió y por qué**, para poder sustentarlo
oralmente. Todos los cambios se hicieron sobre el avance de punteros
(`Sem14_Code2`), que originalmente **no compilaba**.

## Punto de partida

- El branch base (`Sem14_Code1`) compila y funciona, pero **no** tiene punteros,
  floats ni strings como nodos del AST.
- El branch de punteros (`Sem14_Code2`) sí arrancó punteros/floats/strings y un
  sistema de tipos incipiente, pero **no compilaba** ("nochequeado").

## Cambios realizados

### 1. `semantic_types.h` (nuevo módulo)
El sistema de tipos (`Type`, `PrimitiveType`, `PointerType`, `parseType`) vivía
incrustado dentro de `visitor.h`. Se extrajo a su propio header para que el
`TypeCheckerVisitor` y el `GenCodeVisitor` compartan una única fuente de verdad.

- `parseType` se marcó `inline`. **Razón:** al estar definida en un header
  incluido por varios `.cpp`, sin `inline` el enlazador ve la misma función
  duplicada en cada unidad de traducción y falla con *multiple definition*.
- Idea de diseño clave: una **matriz deja de ser un tipo especial** y pasa a ser
  un `int**` (puntero a puntero), igual que en C++. `PointerType` es recursivo,
  así que `int**` = `PointerType(PointerType(PrimitiveType("int")))`.
- Se añadieron helpers: `isPointerTypeStr`, `derefTypeStr`, `addrTypeStr`.

### 2. Forward declarations faltantes en `visitor.h`
Faltaban `Exp`, `AssignStm`, `AddressExp`, `DereferenceExp`. Sin ellas, el
compilador interpretaba esos punteros como `int*` y fallaba con
*"'visit(int*)' cannot be overloaded with 'visit(int*)'"*.

### 3. Visitantes que quedaron abstractos sin querer
`ConstantVisitor` y `LabelVisitor` no implementaban `visit(AddressExp*)` ni
`visit(DereferenceExp*)`, que son virtuales puros en la clase base `Visitor`.
Eso los volvía clases abstractas: `ConstantVisitor opt1;` en `main.cpp` no
compilaba. Se añadieron:
- `ConstantVisitor`: desciende al hijo por si contiene constantes plegables.
- `LabelVisitor`: hereda el peso Sethi-Ullman del hijo.

### 4. Métodos declarados y nunca definidos (errores de enlazador)
- `StringExp::accept` — faltaba (por eso el vtable de `StringExp` no existía).
- `AddressExp::~AddressExp` y `DereferenceExp::~DereferenceExp` — destructores
  declarados en `ast.h` sin definición en `ast.cpp`.
- `TypeCheckerVisitor::deduceType(Exp*)` — declarado y usado en
  `visit(VarDec)`, pero solo estaba implementada la versión de `GenCodeVisitor`.
  Se implementó reflejando la misma lógica pero usando el entorno del
  TypeChecker (`tiposVar`), y añadiendo el caso de `*p` (quita un nivel de
  puntero) y `&x` (añade un nivel).

### 5. Regresión: "Tipo desconocido"
El nuevo `TypeCheckerVisitor::visit(VarDec)` lanzaba
`[TypeChecker] Tipo desconocido: X` para `string`, `list`, `matrix`, structs
(p. ej. `Point`) y el genérico `T`. El motivo: esos tipos se envuelven como
`PrimitiveType`, así que caían en un `else throw` antes de llegar a la rama que
detecta structs. Se corrigió el cálculo de tamaño: se mantiene idéntico el
comportamiento de `int/float/char/bool/struct` y se reemplaza el `throw` por un
**slot de 8 bytes** (que es lo que ocupan punteros y los handles de
list/matrix/string, y lo que necesita el genérico `T` durante el chequeo).

## Resultado (medido sobre los 22 inputs)

| Etapa                          | Antes  | Después |
|--------------------------------|--------|---------|
| El compilador compila          | ❌ no  | ✅ sí   |
| Inputs que generan `.s`        | 0/22   | 22/22   |
| Inputs que ensamblan con gcc   | 0/22   | 22/22   |
| Inputs que corren sin segfault | 0/22   | 12/22   |

**Importante:** "corre sin segfault" no es lo mismo que "resultado correcto".
Ejemplo: `input4` corre pero imprime basura por un bug de codegen del operador
`**` anidado dentro de `if/else`.

## Lo que queda pendiente (Fases 1–3)
Los 10 inputs que aún fallan en ejecución son precisamente las features de
fondo, cuya generación de código quedó incompleta en el rewrite:
- **structs** (`input7`) — segfault
- **list** (`input9`, `input16`) — segfault
- **matrix plana** (`input10`, `input15`) — segfault (se reemplazará por `int**`)
- **templates + strings** (`input19`–`input22`) — segfault
- **bug de `**` anidado** (`input4`) — resultado incorrecto

## Cómo compilar
```bash
g++ -std=c++14 -o compilador ast.cpp main.cpp parser.cpp scanner.cpp token.cpp visitor.cpp
./compilador inputs/input1.txt        # genera inputs/input1.s
gcc -no-pie -o prog inputs/input1.s   # ensambla
./prog                                 # ejecuta
```
