# =============================================================================
# Dockerfile — despliegue de la app web del compilador
# Imagen con g++ (para construir el compilador), gcc (para ensamblar los
# programas del usuario) y Python/Flask (backend).
# =============================================================================
FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends g++ gcc libc6-dev python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages flask

WORKDIR /proyecto
COPY . .

# Construir el compilador dentro de la imagen
RUN g++ -std=c++14 -o compilador ast.cpp main.cpp parser.cpp scanner.cpp \
    token.cpp visitor.cpp json_output.cpp

EXPOSE 5001
CMD ["python3", "app/server.py"]
