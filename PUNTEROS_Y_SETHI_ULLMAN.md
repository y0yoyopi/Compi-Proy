# Punteros (notación C++) y Sethi-Ullman aplicado

## 1. Punteros — 100% funcionales

Se completó el front-end (scanner + parser) que faltaba; el back-end (AST,
type-check, codegen) ya existía. Ahora el lenguaje soporta punteros con
**notación estilo C++**.

### Sintaxis soportada
| Construcción | Ejemplo | Notas |
|---|---|---|
| Declaración de puntero | `var int* p;` `var int** pp;` | `*` y `**` tras el tipo |
| Dirección de (address-of) | `p = &x;` | también `&pt.x`, `&arr[i]` |
| Desreferencia (lectura) | `y = *p;` `z = **pp;` | |
| Desreferencia (escritura) | `*p = 99;` `**pp = 5;` | asignación por puntero |
| Parámetro puntero | `fun int f(int* r) ...` | paso por referencia real |
| Retorno de puntero | `fun int* mayor(...) ...` | |
| Llamada como sentencia | `swap(&x, &y);` | (se añadió `ExprStm`) |

### Cambios de front-end
- **Scanner:** `&` solo (no `&&`) ahora es el token `AMP` (address-of).
- **Parser:**
  - Tipos: consume `*`/`**` tras el tipo → `int*`, `int**` (el scanner lee `**`
    como el token `POW`, así que se trata como doble nivel).
  - `parseF`: prefijos `&F` (AddressExp), `*F` y `**F` (DereferenceExp).
  - `parseStm`: `*p = expr` y `**pp = expr` como sentencia; y **llamada a
    función como sentencia** (`ExprStm`).
- **TypeChecker:** `visit(IdExp)` ahora propaga el tipo declarado a `astType`
  (imprescindible: sin esto `*p` fallaba el chequeo "no es puntero").
- **Codegen:**
  - `&pt.x` corregido: el struct vive en heap, así que la dirección es
    `punteroStruct + offsetCampo` (antes calculaba mal un offset de pila).
  - `&arr[i]` corregido: `base + índice*8`.
  - `*p = valor` (nuevo `LValKind::Deref` + `storeDeref`).

### Casos probados (todos correctos)
- **input23** — básico: `&`, `*`, `*p=` → `10/99/99`
- **input24** — swap por punteros + puntero-a-puntero `**pp` → `3/7/555/555`
- **input25** — parámetros puntero, aliasing, reasignación, `*&a`, `&pt.x` → `15/115/777/15/15/50`
- **input26** — puntero + función que acumula en bucle + expresiones pesadas → `5050/5033/80`
- **input27** — retorno de puntero, deref en expresión, comparación `p==&y` → `45/50/80/1`

## 2. Sethi-Ullman — ahora sí se aplica

Antes: el codegen usaba las etiquetas SU solo para **ordenar**, pero hacía
`pushq`/`popq` + doble ajuste de pila en **cada** operación binaria (máquina de
pila pura). El "fast-path" de hoja estaba muerto (comparaba `label == 0`, pero
las hojas tienen label 1).

Ahora `visit(BinaryExp)` usa las etiquetas para **evitar la pila**:

- Si un operando es **hoja** (constante o variable), se carga directo a un
  registro con un solo `mov` (inmediato o memoria) — **cero push/pop**.
- Si un lado es hoja y el otro compuesto, se evalúa primero el compuesto
  (Sethi-Ullman: el más pesado primero), respetando el orden para operadores no
  conmutativos (`-`, `/`).
- Solo cuando **ambos** lados son compuestos se recurre a la pila, y ahí se
  mantiene la alineación a 16 bytes para no romper llamadas anidadas.

### Efecto medible (input3, condición `pasos < 5`)
Antes:
```
popq %rax ; ... ; pushq %rax ; subq $8,%rsp ; movq $5,%rax ; addq $8,%rsp ; movq %rax,%rcx ; popq %rax ; cmpq ...
```
Ahora:
```
movq -16(%rbp), %rax
movq $5, %rcx
cmpq %rcx, %rax
```
El `push/pop` queda solo en subexpresiones compuestas-compuestas, que es
exactamente lo que Sethi-Ullman predice.

## 3. Estado
Los 27 inputs (22 originales + 5 de punteros) dan el resultado esperado; sin
regresiones respecto de la ronda anterior.
