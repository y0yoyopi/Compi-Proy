# =============================================================================
# server.py — Backend local de la aplicación web del compilador (optimizado)
# =============================================================================
# Expone el compilador como una API HTTP local:
#
#   GET  /               → sirve la interfaz (static/index.html)
#   GET  /api/examples   → programas de ejemplo (benchmarks AMP1–AMP12)
#   POST /api/compile    → {code} → compila, ensambla, ejecuta y devuelve todo
#
# Requisitos: Linux o WSL con python3, flask, g++ y gcc.
#   pip install flask
#   python3 server.py        (luego abrir http://localhost:5000)
#
# El ensamblador generado usa la ABI System V (Linux x86-64), por lo que el
# backend debe correr en Linux/WSL, no en Windows nativo.
# =============================================================================

import json
import os
import subprocess
import tempfile

from flask import Flask, jsonify, request, send_from_directory

BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(BASE)                 # carpeta del compilador
COMPILER = os.path.join(ROOT, "compilador")  # binario del compilador
SOURCES = ["ast.cpp", "main.cpp", "parser.cpp", "scanner.cpp",
           "token.cpp", "visitor.cpp", "json_output.cpp"]

# Ejemplos precargados: los benchmarks de optimización AMP1–AMP12
EXAMPLE_IDS = list(range(1, 13))
EXAMPLE_NAMES = {
    1: "AMP1 — Combinado",
    2: "AMP2 — Constantes",
    3: "AMP3 — Variables",
    4: "AMP4 — Potencias (pow)",
    5: "AMP5 — Constant folding profundo",
    6: "AMP6 — Sethi-Ullman máximo",
    7: "AMP7 — Strength reduction",
    8: "AMP8 — Stress total",
    9: "AMP9 — Branches en bucle caliente",
    10: "AMP10 — Bucles anidados",
    11: "AMP11 — Punto flotante simulado",
    12: "AMP12 — Benchmark definitivo",
}

TIMEOUT_RUN = 10     # segundos máximos de ejecución (los AMP son benchmarks)
TIMEOUT_TOOL = 20    # segundos máximos para compilador/gcc

app = Flask(__name__, static_folder="static")


def construir_compilador():
    """Compila el compilador si el binario no existe o está desactualizado."""
    srcs = [os.path.join(ROOT, s) for s in SOURCES]
    if os.path.exists(COMPILER):
        bin_mtime = os.path.getmtime(COMPILER)
        if all(os.path.getmtime(s) <= bin_mtime for s in srcs):
            return None  # al día
    print("[server] Compilando el compilador...")
    r = subprocess.run(["g++", "-std=c++14", "-o", COMPILER] + srcs,
                       capture_output=True, text=True, timeout=120)
    if r.returncode != 0:
        return r.stderr
    return None


@app.route("/")
def index():
    return send_from_directory("static", "index.html")


@app.route("/api/examples")
def examples():
    out = []
    for n in EXAMPLE_IDS:
        path = os.path.join(ROOT, "inputs", f"input{n}.txt")
        if os.path.exists(path):
            with open(path, encoding="utf-8") as f:
                out.append({"id": n,
                            "name": EXAMPLE_NAMES.get(n, f"input{n}"),
                            "code": f.read()})
    return jsonify(out)


@app.route("/api/compile", methods=["POST"])
def compile_code():
    data = request.get_json(silent=True) or {}
    code = data.get("code", "")
    if not code.strip():
        return jsonify({"success": False, "phase": None,
                        "error": "No hay código para compilar.",
                        "tokens": [], "ast": None, "asm": None, "run": None})

    err = construir_compilador()
    if err:
        return jsonify({"success": False, "phase": "interno",
                        "error": "No se pudo construir el compilador:\n" + err,
                        "tokens": [], "ast": None, "asm": None, "run": None})

    with tempfile.TemporaryDirectory() as tmp:
        src = os.path.join(tmp, "programa.txt")
        with open(src, "w", encoding="utf-8") as f:
            f.write(code)

        # ---- Compilar (modo --json) ----
        try:
            r = subprocess.run([COMPILER, src, "--json"],
                               capture_output=True, text=True,
                               timeout=TIMEOUT_TOOL)
            resultado = json.loads(r.stdout)
        except subprocess.TimeoutExpired:
            return jsonify({"success": False, "phase": "interno",
                            "error": "El compilador excedió el tiempo límite.",
                            "tokens": [], "ast": None, "asm": None, "run": None})
        except (json.JSONDecodeError, ValueError):
            return jsonify({"success": False, "phase": "interno",
                            "error": "Salida inesperada del compilador:\n" +
                                     (r.stderr or r.stdout)[:2000],
                            "tokens": [], "ast": None, "asm": None, "run": None})

        resultado["run"] = None
        if not resultado.get("success"):
            return jsonify(resultado)

        # ---- Ensamblar con gcc ----
        asm_path = os.path.join(tmp, "programa.s")
        exe_path = os.path.join(tmp, "programa")
        r = subprocess.run(["gcc", "-no-pie", "-o", exe_path, asm_path],
                           capture_output=True, text=True, timeout=TIMEOUT_TOOL)
        if r.returncode != 0:
            resultado["run"] = {"output": None, "exitCode": None,
                                "error": "Error al ensamblar:\n" + r.stderr[:2000]}
            return jsonify(resultado)

        # ---- Ejecutar con límite de tiempo ----
        try:
            r = subprocess.run([exe_path], capture_output=True, text=True,
                               timeout=TIMEOUT_RUN)
            resultado["run"] = {"output": r.stdout, "exitCode": r.returncode,
                                "error": r.stderr[:2000] if r.stderr else None}
        except subprocess.TimeoutExpired:
            resultado["run"] = {"output": None, "exitCode": None,
                                "error": f"El programa excedió el límite de "
                                         f"{TIMEOUT_RUN} segundos (¿bucle infinito?)."}
        return jsonify(resultado)


if __name__ == "__main__":
    err = construir_compilador()
    if err:
        print("[server] ERROR al compilar el compilador:\n" + err)
    # En la nube (Render/Railway/etc.) el puerto llega en la variable PORT;
    # en local se usa 5001. host 0.0.0.0 permite conexiones externas.
    puerto = int(os.environ.get("PORT", "5001"))
    app.run(host="0.0.0.0", port=puerto, debug=False)
