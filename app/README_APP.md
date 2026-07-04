# App web del compilador optimizado — cómo ejecutarla

Requiere **Linux o WSL** (el ensamblador generado usa la ABI System V de
Linux x86-64; en Windows nativo gcc no puede ensamblarlo).

```bash
# 1. Dependencias (una sola vez)
sudo apt install g++ gcc python3 python3-pip
pip install flask

# 2. Levantar el servidor (desde esta carpeta app/)
python3 server.py

# 3. Abrir en el navegador
http://localhost:5001
```

Usa el puerto **5001** para poder correr en paralelo con la app del otro
compilador (que usa el 5000). El servidor compila automáticamente el
compilador (`../compilador`) si el binario no existe o si alguna fuente cambió.

## Componentes (bonus del enunciado)

| Componente | Dónde |
|---|---|
| Editor de código | panel izquierdo (CodeMirror, resaltado, soporta `//` y `/* */`, Ctrl+Enter compila) |
| Visualización del AST | pestaña **AST** (árbol colapsable; clic en un nodo salta a su línea) |
| Generación de ensamblador x86 | pestaña **Ensamblador x86** |
| Ejecución del programa | botón **Compilar y ejecutar** (gcc + ejecución con timeout de 10 s) |
| Visualización de resultados | pestaña **Salida** (stdout + código de salida) |

Extra: pestaña **Tokens** y los 12 benchmarks AMP precargados como ejemplos.
Nota de esta variante: la exponenciación se escribe `pow(base, exp)` (no `**`).

## API

- `GET /api/examples` — benchmarks AMP1–AMP12
- `POST /api/compile` — body `{"code": "..."}`; responde el JSON del
  compilador (`success`, `phase`, `error`, `tokens`, `ast`, `asm`) más
  `run` (`output`, `exitCode`, `error`).

Los errores incluyen `[línea N, col C]` y la fase (`lexico`, `sintactico`,
`semantico`); la interfaz marca la línea en el editor.
