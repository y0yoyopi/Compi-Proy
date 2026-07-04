.data
print_fmt: .string "%ld \n"
print_str_fmt: .string "%s\n"
print_float_fmt: .string "%f \n"
itoa_fmt: .string "%ld"
ftoa_fmt: .string "%f"
__str_16: .string "== FIN CALCULADORA"
__str_14: .string "-- Raiz entera aprox de la suma --"
__str_13: .string "-- Historial (lista) --"
__str_0: .string "== "
__str_1: .string "CALCULADORA"
__str_7: .string "-- Suma y mayor de la serie --"
__str_2: .string "-- Operaciones --"
__str_11: .string "-- Matriz aplanada de potencias --"
__str_15: .string "Verificacion OK"
__str_3: .string "-- Potencias (pow) --"
__str_4: .string "-- 2^8 recursivo --"
__str_5: .string "-- Factorial 6 y Fib 10 --"
__str_6: .string "-- Serie 2^i --"
__str_8: .string "-- Media de la serie --"
__str_9: .string "-- Capital con tasa --"
__str_10: .string "-- Tabla de potencias 3x3 --"
__str_12: .string "-- Operacion registrada --"

.text

.globl __runtime_concat
__runtime_concat:
  pushq %rbp
  movq %rsp, %rbp
  pushq %rdi
  pushq %rsi
  call strlen@PLT
  movq %rax, %r12
  movq -16(%rbp), %rdi
  call strlen@PLT
  addq %rax, %r12
  addq $1, %r12
  movq %r12, %rdi
  call malloc@PLT
  movq %rax, %r13
  movq %r13, %rdi
  movq -8(%rbp), %rsi
  call strcpy@PLT
  movq %r13, %rdi
  movq -16(%rbp), %rsi
  call strcat@PLT
  movq %r13, %rax
  leave
  ret


.globl __itoa
__itoa:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq $32, %rdi
  call malloc@PLT
  movq %rax, %r13
  movq %r13, %rdi
  movq $32, %rsi
  leaq itoa_fmt(%rip), %rdx
  movq -8(%rbp), %rcx
  movq $0, %rax
  call snprintf@PLT
  movq %r13, %rax
  leave
  ret


.globl __ftoa
__ftoa:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movsd %xmm0, -8(%rbp)
  movq $32, %rdi
  call malloc@PLT
  movq %rax, %r13
  movq %r13, %rdi
  movq $32, %rsi
  leaq ftoa_fmt(%rip), %rdx
  movsd -8(%rbp), %xmm0
  movq $1, %rax
  call snprintf@PLT
  movq %r13, %rax
  leave
  ret


.globl main
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $256, %rsp
  leaq __str_0(%rip), %rax
  pushq %rax
  leaq __str_1(%rip), %rax
  movq %rax, %rsi
  popq %rdi
  call __runtime_concat
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  leaq __str_2(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $8, %rax
  pushq %rax
  movq $5, %rax
  pushq %rax
  movq $1, %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call operar
  pushq %rax
  popq %rdi
  call emit_int
  movq $8, %rax
  pushq %rax
  movq $5, %rax
  pushq %rax
  movq $2, %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call operar
  pushq %rax
  popq %rdi
  call emit_int
  movq $8, %rax
  pushq %rax
  movq $5, %rax
  pushq %rax
  movq $3, %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call operar
  pushq %rax
  popq %rdi
  call emit_int
  leaq __str_3(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $2, %rax
  pushq %rax
  movq $10, %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, %rdi
  movq %rcx, %rsi
  call potencia
  pushq %rax
  popq %rdi
  call emit_int
  movq $3, %rax
  pushq %rax
  movq $4, %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, %rdi
  movq %rcx, %rsi
  call potencia
  pushq %rax
  popq %rdi
  call emit_int
  movq $5, %rax
  pushq %rax
  movq $3, %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, %rdi
  movq %rcx, %rsi
  call potencia
  pushq %rax
  popq %rdi
  call emit_int
  movq $1, %rax
  movq %rax, -32(%rbp)
  leaq -32(%rbp), %rax
  movq %rax, -40(%rbp)
  movq $2, %rax
  pushq %rax
  movq $8, %rax
  pushq %rax
  movq -40(%rbp), %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call potenciaRec
  leaq __str_4(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -32(%rbp), %rax
  pushq %rax
  popq %rdi
  call emit_int
  leaq __str_5(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $6, %rax
  pushq %rax
  popq %rdi
  call factorial
  pushq %rax
  popq %rdi
  call emit_int
  movq $10, %rax
  pushq %rax
  popq %rdi
  call fib
  pushq %rax
  popq %rdi
  call emit_int
  movq $6, %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -48(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_0:
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_0
  movq $2, %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, %rdi
  movq %rcx, %rsi
  call potencia
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -48(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_0
endwhile_0:
  leaq __str_6(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_1:
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_1
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emit_int
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_1
endwhile_1:
  movq $0, %rax
  movq %rax, -56(%rbp)
  movq $0, %rax
  movq %rax, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -64(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_2:
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_2
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  addq %rcx, %rax
  movq %rax, -56(%rbp)
  movq -64(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call mayorT_int
  movq %rax, -64(%rbp)
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_2
endwhile_2:
  leaq __str_7(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -56(%rbp), %rax
  pushq %rax
  popq %rdi
  call emit_int
  movq -64(%rbp), %rax
  pushq %rax
  popq %rdi
  call emit_int
  movq -56(%rbp), %rax
  cvtsi2sdq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movabsq $4607182418800017408, %rax
  movq %rax, %xmm0
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  mulsd %xmm1, %xmm0
  movq %xmm0, %rax
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movq -24(%rbp), %rax
  addq $8, %rsp
  cvtsi2sdq %rax, %xmm0
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  divsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -72(%rbp)
  leaq __str_8(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -72(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  movabsq $4607632778762754458, %rax
  movq %rax, %xmm0
  movq %rax, -80(%rbp)
  movq -56(%rbp), %rax
  cvtsi2sdq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movq -80(%rbp), %rax
  movq %rax, %xmm0
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  mulsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -88(%rbp)
  leaq __str_9(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -88(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  movq $3, %rax
  pushq %rax
  movq $3, %rax
  popq %rcx
  imulq %rcx, %rax
  salq $3, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -96(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_3:
  movq -16(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_3
  movq $0, %rax
  movq %rax, -200(%rbp)
while_4:
  movq -200(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_4
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -200(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, %rdi
  movq %rcx, %rsi
  call potencia
  pushq %rax
  movq -16(%rbp), %rax
  pushq %rax
  movq -200(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -96(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -200(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -200(%rbp)
  jmp while_4
endwhile_4:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_3
endwhile_3:
  leaq __str_10(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_5:
  movq -16(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_5
  movq $0, %rax
  movq %rax, -208(%rbp)
while_6:
  movq -208(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_6
  movq -16(%rbp), %rax
  pushq %rax
  movq -208(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  movq -96(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emit_int
  movq -208(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -208(%rbp)
  jmp while_6
endwhile_6:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_5
endwhile_5:
  movq $2, %rax
  movq %rax, -104(%rbp)
  movq $3, %rax
  movq %rax, -112(%rbp)
  movq -104(%rbp), %rax
  movq -112(%rbp), %rcx
  imulq %rcx, %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -136(%rbp)
  movq $0, %rax
  movq %rax, -120(%rbp)
while_7:
  movq -120(%rbp), %rax
  movq -104(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_7
  movq $0, %rax
  movq %rax, -128(%rbp)
while_8:
  movq -128(%rbp), %rax
  movq -112(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_8
  movq -120(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq $10, %rax
  pushq %rax
  movq -128(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, %rdi
  movq %rcx, %rsi
  call potencia
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  imulq %rcx, %rax
  pushq %rax
  movq -120(%rbp), %rax
  movq -112(%rbp), %rcx
  imulq %rcx, %rax
  movq -128(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -136(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -128(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -128(%rbp)
  jmp while_8
endwhile_8:
  movq -120(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -120(%rbp)
  jmp while_7
endwhile_7:
  leaq __str_11(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -120(%rbp)
while_9:
  movq -120(%rbp), %rax
  movq -104(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_9
  movq $0, %rax
  movq %rax, -128(%rbp)
while_10:
  movq -128(%rbp), %rax
  movq -112(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_10
  movq -120(%rbp), %rax
  movq -112(%rbp), %rcx
  imulq %rcx, %rax
  movq -128(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  movq -136(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emit_int
  movq -128(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -128(%rbp)
  jmp while_10
endwhile_10:
  movq -120(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -120(%rbp)
  jmp while_9
endwhile_9:
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -144(%rbp)
  movq $12, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -144(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $8, %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -144(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -144(%rbp), %rax
  pushq %rax
  movq $0, %rdi
  movq -144(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  subq $8, %rsp
  movq $1, %rdi
  movq -144(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  imulq %rcx, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call fijarResultado
  leaq __str_12(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $2, %rdi
  movq -144(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emit_int
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -152(%rbp)
  movq $13, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -152(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -160(%rbp)
  movq $256, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -160(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -168(%rbp)
  movq $720, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -168(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -160(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -152(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -168(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -160(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_13(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -152(%rbp), %rax
  movq %rax, -176(%rbp)
  movq $1, %rax
  movq %rax, -184(%rbp)
while_11:
  movq -184(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_11
  movq $0, %rdi
  movq -176(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emit_int
  movq -184(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_12
  movq $1, %rdi
  movq -176(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -176(%rbp)
  jmp endif_12
else_12:
endif_12:
  movq -184(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -184(%rbp)
  jmp while_11
endwhile_11:
  movq $0, %rax
  movq %rax, -192(%rbp)
dowhile_13:
  movq -192(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -192(%rbp)
  movq -192(%rbp), %rax
  movq -192(%rbp), %rcx
  imulq %rcx, %rax
  movq -56(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  jne dowhile_13
endwhile_13:
  leaq __str_14(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -192(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rdi
  call emit_int
  movq -32(%rbp), %rax
  movq $256, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  pushq %rax
  subq $8, %rsp
  movq -56(%rbp), %rax
  movq $100, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  orq %rcx, %rax
  cmpq $0, %rax
  je else_14
  leaq __str_15(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endif_14
else_14:
endif_14:
  leaq __str_16(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  jmp .end_main
.end_main:
  leave
  ret

.globl fijarResultado
fijarResultado:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -8(%rbp), %rax
  addq $16, %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  pushq %rax
  movq -24(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq $0, %rax
  jmp .end_fijarResultado
.end_fijarResultado:
  leave
  ret

.globl factorial
factorial:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq $1, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_15
  movq $1, %rax
  jmp .end_factorial
  jmp endif_15
else_15:
endif_15:
  movq -8(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rdi
  call factorial
  movq %rax, %rcx
  movq -8(%rbp), %rax
  imulq %rcx, %rax
  jmp .end_factorial
.end_factorial:
  leave
  ret

.globl fib
fib:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq $1, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_16
  movq -8(%rbp), %rax
  jmp .end_fib
  jmp endif_16
else_16:
endif_16:
  movq -8(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rdi
  call fib
  pushq %rax
  subq $8, %rsp
  movq -8(%rbp), %rax
  movq $2, %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rdi
  call fib
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  jmp .end_fib
.end_fib:
  leave
  ret

.globl potenciaRec
potenciaRec:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq -16(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_17
  movq $0, %rax
  jmp .end_potenciaRec
  jmp endif_17
else_17:
endif_17:
  movq -24(%rbp), %rax
  movq (%rax), %rax
  movq -8(%rbp), %rcx
  imulq %rcx, %rax
  pushq %rax
  movq -24(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq -8(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  pushq %rax
  movq -24(%rbp), %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call potenciaRec
  movq $0, %rax
  jmp .end_potenciaRec
.end_potenciaRec:
  leave
  ret

.globl operar
operar:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq -24(%rbp), %rax
  movq %rax, %r10
  movq $1, %rax
  cmpq %rax, %r10
  je case_18_1
  movq $2, %rax
  cmpq %rax, %r10
  je case_18_2
  movq $3, %rax
  cmpq %rax, %r10
  je case_18_3
  jmp default_18
case_18_1:
  movq -8(%rbp), %rax
  movq -16(%rbp), %rcx
  addq %rcx, %rax
  jmp .end_operar
  jmp endswitch_18
case_18_2:
  movq -8(%rbp), %rax
  movq -16(%rbp), %rcx
  subq %rcx, %rax
  jmp .end_operar
  jmp endswitch_18
case_18_3:
  movq -8(%rbp), %rax
  movq -16(%rbp), %rcx
  imulq %rcx, %rax
  jmp .end_operar
  jmp endswitch_18
default_18:
  movq $0, %rax
  jmp .end_operar
endswitch_18:
.end_operar:
  leave
  ret

.globl mayorT_int
mayorT_int:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -8(%rbp), %rax
  movq -16(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_19
  movq -8(%rbp), %rax
  jmp .end_mayorT_int
  jmp endif_19
else_19:
endif_19:
  movq -16(%rbp), %rax
  jmp .end_mayorT_int
.end_mayorT_int:
  leave
  ret

.globl emit_int
emit_int:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, %rsi
  leaq print_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  jmp .end_emit_int
.end_emit_int:
  leave
  ret

.globl potencia
potencia:
  pushq %rbp
  movq %rsp, %rbp
  cmpq $0, %rsi
  je potencia_n_zero
  cmpq $1, %rsi
  je potencia_n_one
  pushq %rdi
  movq %rsi, %rdx
  andq $1, %rdx
  pushq %rdx
  movq %rdi, %rax
  imulq %rdi, %rax
  movq %rax, %rdi
  sarq $1, %rsi
  call potencia
  popq %rdx
  popq %rcx
  cmpq $0, %rdx
  je potencia_end
  imulq %rcx, %rax
  jmp potencia_end
potencia_n_zero:
  movq $1, %rax
  jmp potencia_end
potencia_n_one:
  movq %rdi, %rax
  jmp potencia_end
potencia_end:
  leave
  ret

.section .note.GNU-stack,"",@progbits
