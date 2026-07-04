import os
import subprocess
import shutil
import glob
import time
import csv

# =============================================================================
# benchmark_mi_compilador.py
#
# Compila NUESTRO compilador (main.cpp + ...) una sola vez. Luego, para cada
# input:
#   1) lo pasa por nuestro compilador -> genera el .s
#   2) ensambla el .s con gcc -no-pie -> genera el binario final
#   3) ejecuta ese binario REP veces y promedia el tiempo de ejecucion
#      (NO se mide el tiempo de compilar ni de ensamblar, solo la ejecucion
#      del programa ya compilado, igual que el benchmark que le hicimos a g++)
#
# Al final escribe benchmark_mi_compilador.csv con el detalle de cada test.
#
# Uso:
#   python3 benchmark_mi_compilador.py
# =============================================================================

# ---------------- Configuracion ----------------
PROGRAMA = ["main.cpp", "scanner.cpp", "token.cpp", "parser.cpp", "ast.cpp", "visitor.cpp"]
INPUT_DIR = "inputs"
OUTPUT_DIR = "outputs"
REP = 5                                   # repeticiones por test
CSV_OUT = "benchmark_mi_compilador.csv"
TIMEOUT_EJEC = 5                          # segundos maximos por ejecucion
# -------------------------------------------------

EXECUTABLE = "a.exe" if os.name == "nt" else "a.out"


def numkey(p):
    d = "".join(c for c in os.path.basename(p) if c.isdigit())
    return int(d) if d else 0


def compilar_nuestro_compilador():
    cmd = ["g++", "-std=c++14"] + PROGRAMA
    print("Compilando nuestro compilador:", " ".join(cmd))
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print("Error compilando el compilador:\n", r.stderr)
        raise SystemExit(1)
    print("Compilacion del compilador OK\n")


def generar_asm(input_path):
    """Corre nuestro compilador sobre input_path. Devuelve la ruta del .s o None si falla."""
    r = subprocess.run([os.path.join(".", EXECUTABLE), input_path],
                        capture_output=True, text=True)
    if r.returncode != 0:
        print(f"  [NO COMPILA] {r.stderr.strip().splitlines()[:1]}")
        return None

    stem = os.path.splitext(os.path.basename(input_path))[0]
    s_file = os.path.join(INPUT_DIR, f"{stem}.s")
    if not os.path.isfile(s_file):
        print("  [SIN .s]")
        return None
    return s_file


def ensamblar(s_file, exe_out):
    r = subprocess.run(["gcc", "-no-pie", "-o", exe_out, s_file],
                        capture_output=True, text=True)
    if r.returncode != 0:
        print(f"  [NO ENSAMBLA] {r.stderr.strip().splitlines()[:1]}")
        return False
    return True


def medir_ejecucion(binario):
    t0 = time.perf_counter()
    try:
        p = subprocess.run([binario], capture_output=True, timeout=TIMEOUT_EJEC)
    except subprocess.TimeoutExpired:
        return None, "TIMEOUT"
    t1 = time.perf_counter()
    if p.returncode != 0:
        return None, f"exit={p.returncode}"
    return t1 - t0, "OK"


def promedio_ejec(binario, rep=REP):
    tiempos = []
    for _ in range(rep):
        t, estado = medir_ejecucion(binario)
        if t is None:
            return None, None, None, estado
        tiempos.append(t)
    return sum(tiempos) / len(tiempos), min(tiempos), max(tiempos), "OK"


def main():
    compilar_nuestro_compilador()
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    filas = []
    print(f"{'Test':<12}{'Promedio (ms)':>16}{'Min (ms)':>12}{'Max (ms)':>12}   Estado")
    print("-" * 70)

    for filepath in sorted(glob.glob(os.path.join(INPUT_DIR, "input*.txt")), key=numkey):
        filename = os.path.basename(filepath)
        stem = os.path.splitext(filename)[0]
        n = stem.replace("input", "")

        s_file = generar_asm(filepath)
        if s_file is None:
            filas.append((stem, None, None, None, "NO COMPILA"))
            print(f"{stem:<12}{'--':>16}{'--':>12}{'--':>12}   NO COMPILA")
            continue

        exe_out = os.path.join(OUTPUT_DIR, f"prog_{n}")
        if not ensamblar(s_file, exe_out):
            shutil.move(s_file, os.path.join(OUTPUT_DIR, f"input_{n}.s"))
            filas.append((stem, None, None, None, "NO ENSAMBLA"))
            print(f"{stem:<12}{'--':>16}{'--':>12}{'--':>12}   NO ENSAMBLA")
            continue

        avg, mn, mx, estado = promedio_ejec(exe_out)
        shutil.move(s_file, os.path.join(OUTPUT_DIR, f"input_{n}.s"))

        if avg is None:
            filas.append((stem, None, None, None, estado))
            print(f"{stem:<12}{'--':>16}{'--':>12}{'--':>12}   {estado}")
            continue

        filas.append((stem, avg, mn, mx, "OK"))
        print(f"{stem:<12}{avg*1000:>14.3f}{mn*1000:>12.3f}{mx*1000:>12.3f}   OK")

    with open(CSV_OUT, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["Test", "Promedio (s)", "Min (s)", "Max (s)", "Estado"])
        for stem, avg, mn, mx, estado in filas:
            w.writerow([
                stem,
                f"{avg:.6f}" if avg is not None else "",
                f"{mn:.6f}" if mn is not None else "",
                f"{mx:.6f}" if mx is not None else "",
                estado,
            ])

    ok = [f for f in filas if f[4] == "OK"]
    print("-" * 70)
    if ok:
        prom_global = sum(a for _, a, _, _, _ in ok) / len(ok) * 1000
        print(f"Promedio global: {prom_global:.3f} ms  ({len(ok)}/{len(filas)} tests OK)")
    else:
        print("Ningun test se pudo medir.")
    print(f"CSV guardado en {CSV_OUT}")


if __name__ == "__main__":
    main()
