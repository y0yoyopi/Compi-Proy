.data
print_fmt: .string "%ld \n"
print_str_fmt: .string "%s\n"
print_float_fmt: .string "%f \n"
itoa_fmt: .string "%ld"
ftoa_fmt: .string "%f"
__str_19: .string "### FIN ESTADISTICA"
__str_17: .string "Desconocido"
__str_15: .string "Dataset mediano"
__str_13: .string "-- Total serie --"
__str_0: .string "### "
__str_14: .string "Dataset pequeno"
__str_1: .string "ESTADISTICA"
__str_18: .string "-- Pasos para reducir suma bajo 10 --"
__str_2: .string "-- Dataset --"
__str_3: .string "-- Max y Min --"
__str_4: .string "-- Rango --"
__str_6: .string "-- Media y media de cuadrados --"
__str_8: .string "-- Cuantos superan la media redondeada --"
__str_7: .string "-- Varianza (E[x^2]-E[x]^2) --"
__str_9: .string "-- Muestras (valor*peso) --"
__str_16: .string "Dataset grande"
__str_12: .string "-- Serie (lista enlazada) --"
__str_10: .string "-- Matriz de frecuencias --"
__str_5: .string "-- Suma y suma de cuadrados --"
__str_11: .string "-- Histograma aplanado 2x5 --"

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
  subq $320, %rsp
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
  movq -8(%rbp), %rax
  movq %rax, %rdi
  call strlen@PLT
  movq %rax, %rsi
  leaq print_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $10, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -40(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_0:
  movq -16(%rbp), %rax
  movq -32(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_0
  movq -16(%rbp), %rax
  movq -16(%rbp), %rcx
  imulq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq $3, %rax
  movq -16(%rbp), %rcx
  imulq %rcx, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  movq $5, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_0
endwhile_0:
  leaq __str_2(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_1:
  movq -16(%rbp), %rax
  movq -32(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_1
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_1
endwhile_1:
  movq $0, %rax
  movq %rax, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -48(%rbp)
  movq $0, %rax
  movq %rax, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -56(%rbp)
  movq $1, %rax
  movq %rax, -16(%rbp)
while_2:
  movq -16(%rbp), %rax
  movq -32(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_2
  movq -48(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call mayor_int
  movq %rax, -48(%rbp)
  movq -56(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call menor_int
  movq %rax, -56(%rbp)
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_2
endwhile_2:
  leaq __str_3(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -48(%rbp), %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq -56(%rbp), %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  leaq __str_4(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -48(%rbp), %rax
  movq -56(%rbp), %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq $0, %rax
  movq %rax, -64(%rbp)
  movq $0, %rax
  movq %rax, -72(%rbp)
  leaq -64(%rbp), %rax
  movq %rax, -80(%rbp)
  leaq -72(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -40(%rbp), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  movq -80(%rbp), %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call sumaSerie
  movq -40(%rbp), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  movq -88(%rbp), %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call sumaCuadrados
  leaq __str_5(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -64(%rbp), %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq -72(%rbp), %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq -64(%rbp), %rax
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
  movq -32(%rbp), %rax
  addq $8, %rsp
  cvtsi2sdq %rax, %xmm0
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  divsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -96(%rbp)
  movq -72(%rbp), %rax
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
  movq -32(%rbp), %rax
  addq $8, %rsp
  cvtsi2sdq %rax, %xmm0
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  divsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -104(%rbp)
  leaq __str_6(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -96(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  movq -104(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  movq -104(%rbp), %rax
  movq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movq -96(%rbp), %rax
  movq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movq -96(%rbp), %rax
  movq %rax, %xmm0
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  mulsd %xmm1, %xmm0
  movq %xmm0, %rax
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  subsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -112(%rbp)
  leaq __str_7(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -112(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  leaq __str_8(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -40(%rbp), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  movq -48(%rbp), %rax
  movq $2, %rcx
  cqto
  idivq %rcx
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call contarMayores
  pushq %rax
  popq %rdi
  call imprimir_int
  movq $10, %rax
  pushq %rax
  movq $2, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call crearMuestra
  movq %rax, -120(%rbp)
  movq $20, %rax
  pushq %rax
  movq $3, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call crearMuestra
  movq %rax, -128(%rbp)
  movq $30, %rax
  pushq %rax
  movq $5, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call crearMuestra
  movq %rax, -136(%rbp)
  movq -128(%rbp), %rax
  pushq %rax
  movq $5, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call ajustar
  leaq __str_9(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rdi
  movq -120(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  subq $8, %rsp
  movq $1, %rdi
  movq -120(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  imulq %rcx, %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq $0, %rdi
  movq -128(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  subq $8, %rsp
  movq $1, %rdi
  movq -128(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  imulq %rcx, %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq $0, %rdi
  movq -136(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  subq $8, %rsp
  movq $1, %rdi
  movq -136(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  imulq %rcx, %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq $3, %rax
  pushq %rax
  movq $3, %rax
  popq %rcx
  imulq %rcx, %rax
  salq $3, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -144(%rbp)
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
  movq %rax, -24(%rbp)
while_4:
  movq -24(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_4
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq $2, %rcx
  imulq %rcx, %rax
  pushq %rax
  movq -16(%rbp), %rax
  pushq %rax
  movq -24(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -144(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -24(%rbp)
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
  movq %rax, -24(%rbp)
while_6:
  movq -24(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_6
  movq -16(%rbp), %rax
  pushq %rax
  movq -24(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  movq -144(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -24(%rbp)
  jmp while_6
endwhile_6:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_5
endwhile_5:
  movq $2, %rax
  movq %rax, -152(%rbp)
  movq $5, %rax
  movq %rax, -160(%rbp)
  movq -152(%rbp), %rax
  movq -160(%rbp), %rcx
  imulq %rcx, %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -168(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_7:
  movq -16(%rbp), %rax
  movq -152(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_7
  movq $0, %rax
  movq %rax, -24(%rbp)
while_8:
  movq -24(%rbp), %rax
  movq -160(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_8
  movq -16(%rbp), %rax
  movq -160(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq -160(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -168(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -24(%rbp)
  jmp while_8
endwhile_8:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_7
endwhile_7:
  leaq __str_11(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_9:
  movq -16(%rbp), %rax
  movq -152(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_9
  movq $0, %rax
  movq %rax, -24(%rbp)
while_10:
  movq -24(%rbp), %rax
  movq -160(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_10
  movq -16(%rbp), %rax
  movq -160(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  movq -168(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -24(%rbp)
  jmp while_10
endwhile_10:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_9
endwhile_9:
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -176(%rbp)
  movq $3, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -176(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -184(%rbp)
  movq $6, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -184(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -192(%rbp)
  movq $9, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -192(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -200(%rbp)
  movq $12, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -200(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -184(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -176(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -192(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -184(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -200(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -192(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_12(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -216(%rbp)
  movq -176(%rbp), %rax
  movq %rax, -208(%rbp)
  movq $1, %rax
  movq %rax, -224(%rbp)
while_11:
  movq -224(%rbp), %rax
  movq $4, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_11
  movq $0, %rdi
  movq -208(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq $0, %rdi
  movq -208(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, %rcx
  movq -216(%rbp), %rax
  addq %rcx, %rax
  movq %rax, -216(%rbp)
  movq -224(%rbp), %rax
  movq $4, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_12
  movq $1, %rdi
  movq -208(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -208(%rbp)
  jmp endif_12
else_12:
endif_12:
  movq -224(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -224(%rbp)
  jmp while_11
endwhile_11:
  leaq __str_13(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -216(%rbp), %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  movq $2, %rax
  movq %rax, -232(%rbp)
  movq -232(%rbp), %rax
  movq %rax, %r10
  movq $1, %rax
  cmpq %rax, %r10
  je case_13_1
  movq $2, %rax
  cmpq %rax, %r10
  je case_13_2
  movq $3, %rax
  cmpq %rax, %r10
  je case_13_3
  jmp default_13
case_13_1:
  leaq __str_14(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_13
  jmp endswitch_13
case_13_2:
  leaq __str_15(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_13
  jmp endswitch_13
case_13_3:
  leaq __str_16(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_13
  jmp endswitch_13
default_13:
  leaq __str_17(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
endswitch_13:
  movq -64(%rbp), %rax
  movq %rax, -240(%rbp)
  movq $0, %rax
  movq %rax, -248(%rbp)
dowhile_14:
  movq -240(%rbp), %rax
  movq $2, %rcx
  cqto
  idivq %rcx
  movq %rax, -240(%rbp)
  movq -248(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -248(%rbp)
  movq -240(%rbp), %rax
  movq $10, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setge %al
  movzbq %al, %rax
  cmpq $0, %rax
  jne dowhile_14
endwhile_14:
  leaq __str_18(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -248(%rbp), %rax
  pushq %rax
  popq %rdi
  call imprimir_int
  leaq __str_19(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  jmp .end_main
.end_main:
  leave
  ret

.globl crearMuestra
crearMuestra:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -24(%rbp)
  movq -8(%rbp), %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -16(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -24(%rbp), %rax
  jmp .end_crearMuestra
.end_crearMuestra:
  leave
  ret

.globl ajustar
ajustar:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -24(%rbp)
  movq -24(%rbp), %rax
  movq (%rax), %rax
  movq -16(%rbp), %rcx
  addq %rcx, %rax
  pushq %rax
  movq -24(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq $0, %rax
  jmp .end_ajustar
.end_ajustar:
  leave
  ret

.globl sumaSerie
sumaSerie:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq %rcx, -32(%rbp)
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_15
  movq $0, %rax
  jmp .end_sumaSerie
  jmp endif_15
else_15:
endif_15:
  movq -32(%rbp), %rax
  movq (%rax), %rax
  pushq %rax
  subq $8, %rsp
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  movq -32(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq -8(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -24(%rbp), %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call sumaSerie
  movq $0, %rax
  jmp .end_sumaSerie
.end_sumaSerie:
  leave
  ret

.globl sumaCuadrados
sumaCuadrados:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq %rcx, -32(%rbp)
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_16
  movq $0, %rax
  jmp .end_sumaCuadrados
  jmp endif_16
else_16:
endif_16:
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  subq $8, %rsp
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  imulq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -32(%rbp), %rax
  movq (%rax), %rax
  addq $8, %rsp
  popq %rcx
  addq %rcx, %rax
  pushq %rax
  movq -32(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq -8(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -24(%rbp), %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call sumaCuadrados
  movq $0, %rax
  jmp .end_sumaCuadrados
.end_sumaCuadrados:
  leave
  ret

.globl contarMayores
contarMayores:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq %rcx, -32(%rbp)
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_17
  movq $0, %rax
  jmp .end_contarMayores
  jmp endif_17
else_17:
endif_17:
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq -32(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_18
  movq -8(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -24(%rbp), %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call contarMayores
  movq %rax, %rcx
  movq $1, %rax
  addq %rcx, %rax
  jmp .end_contarMayores
  jmp endif_18
else_18:
endif_18:
  movq -8(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -24(%rbp), %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call contarMayores
  jmp .end_contarMayores
.end_contarMayores:
  leave
  ret

.globl menor_int
menor_int:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -8(%rbp), %rax
  movq -16(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_19
  movq -8(%rbp), %rax
  jmp .end_menor_int
  jmp endif_19
else_19:
endif_19:
  movq -16(%rbp), %rax
  jmp .end_menor_int
.end_menor_int:
  leave
  ret

.globl mayor_int
mayor_int:
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
  je else_20
  movq -8(%rbp), %rax
  jmp .end_mayor_int
  jmp endif_20
else_20:
endif_20:
  movq -16(%rbp), %rax
  jmp .end_mayor_int
.end_mayor_int:
  leave
  ret

.globl imprimir_int
imprimir_int:
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
  jmp .end_imprimir_int
.end_imprimir_int:
  leave
  ret

.section .note.GNU-stack,"",@progbits
