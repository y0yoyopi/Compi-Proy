cmake_minimum_required(VERSION 3.16)
project(CompiladorX86)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(.)

add_executable(compilador
        ast.cpp
        ast.h
        environment.h
        main.cpp
        parser.cpp
        parser.h
        scanner.cpp
        scanner.h
        semantic_types.h
        token.cpp
        token.h
        visitor.cpp
        visitor.h)
