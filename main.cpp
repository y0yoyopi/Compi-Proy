// =============================================================================
// main.cpp — Punto de entrada del compilador
// =============================================================================
// Flujo de compilación:
//   1. Leer el archivo fuente
//   2. Scanner  → token stream
//   3. Parser   → AST
//   4. TypeChecker (dentro de GenCodeVisitor::generar)  → análisis semántico
//   5. GenCodeVisitor → emite código x86-64 AT&T en un archivo .s
//
// Uso:
//   ./compilador <archivo>            modo normal: genera <archivo>.s
//   ./compilador <archivo> --json     modo app: además imprime por stdout un
//                                     JSON con tokens, AST, asm y errores
//
// El modo --json siempre termina con exit code 0 (el resultado va en el campo
// "success" del JSON); así el backend distingue "error del programa fuente"
// de "error del compilador".
// =============================================================================

#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include "ast.h"

#include "json_output.h"
#include "parser.h"
#include "scanner.h"
#include "visitor.h"

// -----------------------------------------------------------------------------
// compilarJson — pipeline completo en modo --json
// -----------------------------------------------------------------------------
// Ejecuta cada fase por separado para poder reportar en qué fase falló:
//   léxico (tokens) → sintáctico (AST) → semántico + codegen (asm)
// El .s se escribe igualmente cuando la compilación es exitosa.
// -----------------------------------------------------------------------------
static int compilarJson(const std::string &input, const std::string &outputFile) {
    std::string fase, error;

    // ---- Fase léxica: tokens (corta en el primer error léxico) ----
    std::string lexError;
    std::string tokensJson = tokensToJson(input, lexError);
    if (!lexError.empty()) {
        fase = "lexico";
        error = lexError;
    }

    // ---- Fase sintáctica: AST ----
    Program *program = nullptr;
    std::string astJson = "null";
    if (error.empty()) {
        try {
            Scanner scanner(input.c_str());
            Parser parser(&scanner);
            program = parser.parseProgram();
            astJson = astToJson(program);
        } catch (const std::exception &e) {
            fase = "sintactico";
            error = e.what();
        }
    }

    // ---- Fase semántica + generación de código ----
    std::string asmCode;
    if (error.empty() && program) {
        try {
            ConstantVisitor opt1;
            opt1.plegado(program);
            LabelVisitor opt2;
            opt2.etiquetado(program);

            std::ostringstream ss;
            GenCodeVisitor codegen(ss);
            codegen.generar(program);
            asmCode = ss.str();

            std::ofstream outfile(outputFile);
            if (outfile.is_open()) {
                outfile << asmCode;
                outfile.close();
            }
        } catch (const std::exception &e) {
            fase = "semantico";
            error = e.what();
        }
    }

    // ---- Emitir el JSON por stdout ----
    bool ok = error.empty();
    std::cout << "{\"success\":" << (ok ? "true" : "false");
    if (ok) {
        std::cout << ",\"phase\":null,\"error\":null";
    } else {
        std::cout << ",\"phase\":\"" << fase << "\",\"error\":\""
                  << jsonEscape(error) << "\"";
    }
    std::cout << ",\"tokens\":" << tokensJson;
    std::cout << ",\"ast\":" << astJson;
    std::cout << ",\"asm\":";
    if (ok) std::cout << "\"" << jsonEscape(asmCode) << "\"";
    else    std::cout << "null";
    std::cout << "}" << std::endl;

    delete program;
    return 0;
}

int main(int argc, const char* argv[]) {
    // ---- Validar argumentos ----
    if (argc < 2 || argc > 3) {
        std::cerr << "Uso: " << argv[0] << " <archivo_de_entrada> [--json]\n";
        return 1;
    }
    bool jsonMode = (argc == 3 && std::string(argv[2]) == "--json");

    // ---- Leer archivo fuente ----
    std::ifstream infile(argv[1]);
    if (!infile.is_open()) {
        std::cerr << "Error: no se pudo abrir el archivo '" << argv[1] << "'\n";
        return 1;
    }

    std::string input, line;
    while (std::getline(infile, line))
        input += line + '\n';
    infile.close();

    // ---- Construir nombre del archivo de salida ----
    std::string inputFile(argv[1]);
    size_t dotPos = inputFile.find_last_of('.');
    std::string baseName   = (dotPos == std::string::npos) ? inputFile
                                                           : inputFile.substr(0, dotPos);
    std::string outputFile = baseName + ".s";

    // ---- Modo JSON (para la aplicación web) ----
    if (jsonMode)
        return compilarJson(input, outputFile);

    // ---- Modo normal ----
    // El constructor del Parser tokeniza toda la entrada, así que los errores
    // léxicos también se lanzan ahí: ambos van dentro del try.
    Scanner scanner(input.c_str());

    Program* program = nullptr;
    try {
        Parser parser(&scanner);
        program = parser.parseProgram();
    } catch (const std::exception& e) {
        std::cerr << e.what() << "\n";
        return 1;
    }

    std::ofstream outfile(outputFile);
    if (!outfile.is_open()) {
        std::cerr << "Error: no se pudo crear el archivo de salida '" << outputFile << "'\n";
        delete program;
        return 1;
    }

    // ---- Optimización: plegado de constantes ----
    ConstantVisitor opt1;
    opt1.plegado(program);
    LabelVisitor opt2;
    opt2.etiquetado(program);
    // ---- Análisis semántico + generación de código ----
    try {
        std::cout << "Generando codigo ensamblador en '" << outputFile << "'...\n";
        GenCodeVisitor codegen(outfile);
        codegen.generar(program);
        std::cout << "Compilación exitosa.\n";
    } catch (const std::exception& e) {
        std::cerr << e.what() << "\n";
        outfile.close();
        delete program;
        return 1;
    }

    outfile.close();
    delete program;
    return 0;
}
