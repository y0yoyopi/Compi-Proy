.data
print_fmt: .string "%ld \n"
print_str_fmt: .string "%s\n"
print_float_fmt: .string "%f \n"
itoa_fmt: .string "%ld"
ftoa_fmt: .string "%f"
__str_17: .string "*** FIN ESTUDIANTES ***"
__str_14: .string "Aprobado justo"
__str_13: .string "Notable"
__str_0: .string "*** "
__str_11: .string "-- Ranking (id : puntaje) --"
__str_1: .string "ESTUDIANTES"
__str_4: .string "-- Mejor y peor nota1 --"
__str_5: .string "-- Promedio e1 --"
__str_12: .string "Sobresaliente"
__str_15: .string "-- Veces que cabe 11 en suma e3 --"
__str_2: .string " ***"
__str_6: .string "-- Notas del curso --"
__str_3: .string "-- Suma de notas por estudiante --"
__str_7: .string "-- Aprobados (>=11) --"
__str_16: .string "Curso procesado"
__str_8: .string "-- Suma y promedio del curso --"
__str_9: .string "-- Tablon de notas 3x3 --"
__str_10: .string "-- Asistencia 2x5 --"

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
  subq $336, %rsp
  leaq __str_0(%rip), %rax
  pushq %rax
  leaq __str_1(%rip), %rax
  pushq %rax
  leaq __str_2(%rip), %rax
  movq %rax, %rsi
  popq %rdi
  call __runtime_concat
  movq %rax, %rsi
  popq %rdi
  call __runtime_concat
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $1, %rax
  pushq %rax
  movq $14, %rax
  pushq %rax
  movq $16, %rax
  pushq %rax
  movq $12, %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call crearEst
  movq %rax, -40(%rbp)
  movq $2, %rax
  pushq %rax
  movq $8, %rax
  pushq %rax
  movq $10, %rax
  pushq %rax
  movq $9, %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call crearEst
  movq %rax, -48(%rbp)
  movq $3, %rax
  pushq %rax
  movq $18, %rax
  pushq %rax
  movq $15, %rax
  pushq %rax
  movq $20, %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call crearEst
  movq %rax, -56(%rbp)
  movq -48(%rbp), %rax
  pushq %rax
  movq $3, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call curvar
  leaq __str_3(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -40(%rbp), %rax
  pushq %rax
  popq %rdi
  call sumaNotas
  pushq %rax
  popq %rdi
  call out_int
  movq -48(%rbp), %rax
  pushq %rax
  popq %rdi
  call sumaNotas
  pushq %rax
  popq %rdi
  call out_int
  movq -56(%rbp), %rax
  pushq %rax
  popq %rdi
  call sumaNotas
  pushq %rax
  popq %rdi
  call out_int
  leaq __str_4(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $1, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $1, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $1, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call mejor_int
  pushq %rax
  popq %rsi
  popq %rdi
  call mejor_int
  pushq %rax
  popq %rdi
  call out_int
  movq $1, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $1, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $1, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call peor_int
  pushq %rax
  popq %rsi
  popq %rdi
  call peor_int
  pushq %rax
  popq %rdi
  call out_int
  movq -40(%rbp), %rax
  pushq %rax
  popq %rdi
  call sumaNotas
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
  movq $3, %rax
  addq $8, %rsp
  cvtsi2sdq %rax, %xmm0
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  divsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -64(%rbp)
  leaq __str_5(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -64(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  movq $10, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -72(%rbp)
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
  movq $7, %rcx
  imulq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -16(%rbp), %rax
  movq $7, %rcx
  imulq %rcx, %rax
  movq $21, %rcx
  cqto
  idivq %rcx
  movq $21, %rcx
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
  movq -72(%rbp), %rax
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
  movq -32(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_1
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -72(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call out_int
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_1
endwhile_1:
  movq $0, %rax
  movq %rax, -80(%rbp)
  leaq -80(%rbp), %rax
  movq %rax, -88(%rbp)
  movq -72(%rbp), %rax
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
  call contarAprob
  leaq __str_7(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -80(%rbp), %rax
  pushq %rax
  popq %rdi
  call out_int
  movq $0, %rax
  movq %rax, -96(%rbp)
  movq $0, %rax
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
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -72(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, %rcx
  movq -96(%rbp), %rax
  addq %rcx, %rax
  movq %rax, -96(%rbp)
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_2
endwhile_2:
  movq -96(%rbp), %rax
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
  leaq __str_8(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -96(%rbp), %rax
  pushq %rax
  popq %rdi
  call out_int
  movq -104(%rbp), %rax
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
  movq %rax, -112(%rbp)
  movq $1, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -112(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $2, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -112(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $3, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -112(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $1, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $1, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -112(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $2, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $1, %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -112(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $3, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $1, %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -112(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $1, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $2, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -112(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $2, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $2, %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -112(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $3, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  movq $2, %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -112(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_9(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
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
  pushq %rax
  movq -24(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  movq -112(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call out_int
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
  movq $2, %rax
  movq %rax, -120(%rbp)
  movq $5, %rax
  movq %rax, -128(%rbp)
  movq -120(%rbp), %rax
  movq -128(%rbp), %rcx
  imulq %rcx, %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -136(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_5:
  movq -16(%rbp), %rax
  movq -120(%rbp), %rcx
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
  movq -128(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_6
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  imulq %rcx, %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq -128(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -136(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
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
  leaq __str_10(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_7:
  movq -16(%rbp), %rax
  movq -120(%rbp), %rcx
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
  movq -128(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_8
  movq -16(%rbp), %rax
  movq -128(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  movq -136(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call out_int
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
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -144(%rbp)
  movq $3, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -144(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -56(%rbp), %rax
  pushq %rax
  popq %rdi
  call sumaNotas
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -144(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -152(%rbp)
  movq $1, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -152(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -40(%rbp), %rax
  pushq %rax
  popq %rdi
  call sumaNotas
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -152(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -160(%rbp)
  movq $2, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -160(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -48(%rbp), %rax
  pushq %rax
  popq %rdi
  call sumaNotas
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -160(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -152(%rbp), %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -144(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -160(%rbp), %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -152(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_11(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -144(%rbp), %rax
  movq %rax, -168(%rbp)
  movq $1, %rax
  movq %rax, -176(%rbp)
while_9:
  movq -176(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_9
  movq $0, %rdi
  movq -168(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call out_int
  movq $1, %rdi
  movq -168(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call out_int
  movq -176(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_10
  movq $2, %rdi
  movq -168(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -168(%rbp)
  jmp endif_10
else_10:
endif_10:
  movq -176(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -176(%rbp)
  jmp while_9
endwhile_9:
  movq -64(%rbp), %rax
  movq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movabsq $4625759767262920704, %rax
  movq %rax, %xmm0
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  movq %xmm0, %rax
  cmpq $0, %rax
  je else_11
  movq $1, %rax
  movq %rax, -184(%rbp)
  jmp endif_11
else_11:
  movq -64(%rbp), %rax
  movq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movabsq $4624070917402656768, %rax
  movq %rax, %xmm0
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  movq %xmm0, %rax
  cmpq $0, %rax
  je else_12
  movq $2, %rax
  movq %rax, -184(%rbp)
  jmp endif_12
else_12:
  movq $3, %rax
  movq %rax, -184(%rbp)
endif_12:
endif_11:
  movq -184(%rbp), %rax
  movq %rax, %r10
  movq $1, %rax
  cmpq %rax, %r10
  je case_13_1
  movq $2, %rax
  cmpq %rax, %r10
  je case_13_2
  jmp default_13
case_13_1:
  leaq __str_12(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_13
  jmp endswitch_13
case_13_2:
  leaq __str_13(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_13
  jmp endswitch_13
default_13:
  leaq __str_14(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
endswitch_13:
  movq -56(%rbp), %rax
  pushq %rax
  popq %rdi
  call sumaNotas
  movq %rax, -192(%rbp)
  movq $0, %rax
  movq %rax, -200(%rbp)
dowhile_14:
  movq -192(%rbp), %rax
  movq $11, %rcx
  subq %rcx, %rax
  movq %rax, -192(%rbp)
  movq -200(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -200(%rbp)
  movq -192(%rbp), %rax
  movq $11, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setge %al
  movzbq %al, %rax
  cmpq $0, %rax
  jne dowhile_14
endwhile_14:
  leaq __str_15(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -200(%rbp), %rax
  pushq %rax
  popq %rdi
  call out_int
  movq -80(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  pushq %rax
  subq $8, %rsp
  movq -96(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  andq %rcx, %rax
  cmpq $0, %rax
  je else_15
  leaq __str_16(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endif_15
else_15:
endif_15:
  leaq __str_17(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  jmp .end_main
.end_main:
  leave
  ret

.globl crearEst
crearEst:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq %rcx, -32(%rbp)
  movq $32, %rdi
  call malloc@PLT
  movq %rax, -40(%rbp)
  movq -8(%rbp), %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -16(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -24(%rbp), %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -32(%rbp), %rax
  pushq %rax
  movq $3, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -40(%rbp), %rax
  jmp .end_crearEst
.end_crearEst:
  leave
  ret

.globl sumaNotas
sumaNotas:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq $1, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  subq $8, %rsp
  movq $2, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq $3, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  jmp .end_sumaNotas
.end_sumaNotas:
  leave
  ret

.globl curvar
curvar:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -8(%rbp), %rax
  addq $8, %rax
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
  jmp .end_curvar
.end_curvar:
  leave
  ret

.globl contarAprob
contarAprob:
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
  jmp .end_contarAprob
  jmp endif_16
else_16:
endif_16:
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq $11, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setge %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_17
  movq -32(%rbp), %rax
  movq (%rax), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -32(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  jmp endif_17
else_17:
endif_17:
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
  call contarAprob
  movq $0, %rax
  jmp .end_contarAprob
.end_contarAprob:
  leave
  ret

.globl peor_int
peor_int:
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
  je else_18
  movq -8(%rbp), %rax
  jmp .end_peor_int
  jmp endif_18
else_18:
endif_18:
  movq -16(%rbp), %rax
  jmp .end_peor_int
.end_peor_int:
  leave
  ret

.globl mejor_int
mejor_int:
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
  jmp .end_mejor_int
  jmp endif_19
else_19:
endif_19:
  movq -16(%rbp), %rax
  jmp .end_mejor_int
.end_mejor_int:
  leave
  ret

.globl out_int
out_int:
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
  jmp .end_out_int
.end_out_int:
  leave
  ret

.section .note.GNU-stack,"",@progbits
