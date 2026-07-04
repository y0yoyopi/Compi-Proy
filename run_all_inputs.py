import os
import subprocess
import shutil
import glob

# =============================================================================
# run_all_inputs.py
# Compila el compilador, genera el .s de cada input, lo ENSAMBLA con gcc,
# lo EJECUTA y muestra la salida. Sirve para verificar resultados de un vistazo.
# =============================================================================

# Archivos fuente del compilador
programa = ["main.cpp", "scanner.cpp", "token.cpp", "parser.cpp", "ast.cpp", "visitor.cpp"]

# ---- Compilar el compilador ----
compile_cmd = ["g++", "-std=c++14"] + programa
print("Compilando compilador:", " ".join(compile_cmd))
result = subprocess.run(compile_cmd, capture_output=True, text=True)
if result.returncode != 0:
    print("Error en compilacion:\n", result.stderr)
    exit(1)
print("Compilacion exitosa\n")

executable = "a.exe" if os.name == "nt" else "a.out"

input_dir = "inputs"
output_dir = "outputs"
os.makedirs(output_dir, exist_ok=True)

resumen = []

def numkey(p):
    d = "".join(c for c in os.path.basename(p) if c.isdigit())
    return int(d) if d else 0

for filepath in sorted(glob.glob(os.path.join(input_dir, "input*.txt")), key=numkey):
    filename = os.path.basename(filepath)
    stem = os.path.splitext(filename)[0]
    input_number = stem.replace("input", "")

    print("===== {} =====".format(filename))

    # 1) Generar ensamblador
    gen = subprocess.run([os.path.join(".", executable), filepath],
                         capture_output=True, text=True)
    if gen.returncode != 0:
        print("  [NO COMPILA]", gen.stderr.strip().split("\n")[0])
        resumen.append((filename, "NO COMPILA"))
        continue

    s_file = os.path.join(input_dir, "{}.s".format(stem))
    if not os.path.isfile(s_file):
        print("  [SIN .s]")
        resumen.append((filename, "SIN .s"))
        continue

    # 2) Ensamblar con gcc
    exe_out = os.path.join(output_dir, "prog_{}".format(input_number))
    asm = subprocess.run(["gcc", "-no-pie", "-o", exe_out, s_file],
                         capture_output=True, text=True)
    if asm.returncode != 0:
        print("  [NO ENSAMBLA]", asm.stderr.strip().split("\n")[0])
        resumen.append((filename, "NO ENSAMBLA"))
        shutil.move(s_file, os.path.join(output_dir, "input_{}.s".format(input_number)))
        continue

    # 3) Ejecutar
    try:
        run = subprocess.run([exe_out], capture_output=True, text=True, timeout=5)
        salida = run.stdout.replace("\n", " | ").strip()
        estado = "OK" if run.returncode == 0 else "exit={}".format(run.returncode)
        print("  salida: {}   ({})".format(salida, estado))
        resumen.append((filename, estado))
    except subprocess.TimeoutExpired:
        print("  [TIMEOUT]")
        resumen.append((filename, "TIMEOUT"))

    shutil.move(s_file, os.path.join(output_dir, "input_{}.s".format(input_number)))

print("\n===== RESUMEN =====")
for nombre, estado in resumen:
    print("  {:16s} {}".format(nombre, estado))
