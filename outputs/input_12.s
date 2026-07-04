.data
print_fmt: .string "%ld \n"
print_str_fmt: .string "%s\n"
print_float_fmt: .string "%f \n"
itoa_fmt: .string "%ld"
ftoa_fmt: .string "%f"
__str_22: .string "Revisar red"
__str_19: .string "Todo normal"
__str_18: .string "Alerta amarilla"
__str_15: .string "-- Suma de codigos --"
__str_13: .string "-- Historial 3x4 --"
__str_23: .string "#### FIN RED DE SENSORES ####"
__str_0: .string "#### "
__str_8: .string "-- Suma de lecturas --"
__str_10: .string "-- Lectura promedio --"
__str_20: .string "-- Ciclos de descarga --"
__str_14: .string "-- Eventos (lista enlazada) --"
__str_2: .string " ####"
__str_11: .string "-- Lectura ajustada s2 --"
__str_3: .string "-- Lecturas --"
__str_1: .string "RED DE SENSORES"
__str_9: .string "-- Alarmas (>40) --"
__str_4: .string "-- Max y Min lectura --"
__str_21: .string "Sistema operativo"
__str_5: .string "-- Tras swap --"
__str_6: .string "-- Tras doble puntero --"
__str_17: .string "ALERTA ROJA"
__str_7: .string "-- Lecturas del arreglo --"
__str_16: .string "-- Fib(12) de control --"
__str_12: .string "-- Matriz de correlacion 3x3 --"

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
  subq $352, %rsp
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
  movq -8(%rbp), %rax
  movq %rax, %rdi
  call strlen@PLT
  movq %rax, %rsi
  leaq print_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $1, %rax
  pushq %rax
  movq $40, %rax
  pushq %rax
  movq $50, %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call crearSensor
  movq %rax, -40(%rbp)
  movq $2, %rax
  pushq %rax
  movq $65, %rax
  pushq %rax
  movq $50, %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call crearSensor
  movq %rax, -48(%rbp)
  movq $3, %rax
  pushq %rax
  movq $30, %rax
  pushq %rax
  movq $50, %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call crearSensor
  movq %rax, -56(%rbp)
  movq -40(%rbp), %rax
  pushq %rax
  movq $15, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call calibrar
  leaq __str_3(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $1, %rdi
  movq -40(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  movq $1, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  movq $1, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emitir_int
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
  call maxG_int
  pushq %rax
  popq %rsi
  popq %rdi
  call maxG_int
  pushq %rax
  popq %rdi
  call emitir_int
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
  call minG_int
  pushq %rax
  popq %rsi
  popq %rdi
  call minG_int
  pushq %rax
  popq %rdi
  call emitir_int
  movq $100, %rax
  movq %rax, -64(%rbp)
  movq $200, %rax
  movq %rax, -72(%rbp)
  leaq -64(%rbp), %rax
  pushq %rax
  leaq -72(%rbp), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call intercambiar
  leaq __str_5(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -64(%rbp), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  movq -72(%rbp), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  leaq -64(%rbp), %rax
  movq %rax, -80(%rbp)
  leaq -80(%rbp), %rax
  movq %rax, -88(%rbp)
  movq $999, %rax
  pushq %rax
  movq -88(%rbp), %rax
  movq (%rax), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  leaq __str_6(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -64(%rbp), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  movq $12, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -96(%rbp)
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
  movq $13, %rcx
  imulq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -16(%rbp), %rax
  movq $13, %rcx
  imulq %rcx, %rax
  movq $47, %rcx
  cqto
  idivq %rcx
  movq $47, %rcx
  imulq %rcx, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  movq %rax, %rcx
  movq $20, %rax
  addq %rcx, %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -96(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_0
endwhile_0:
  leaq __str_7(%rip), %rax
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
  movq -96(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_1
endwhile_1:
  movq $0, %rax
  movq %rax, -104(%rbp)
  movq $0, %rax
  movq %rax, -112(%rbp)
  leaq -104(%rbp), %rax
  movq %rax, -120(%rbp)
  leaq -112(%rbp), %rax
  movq %rax, -128(%rbp)
  movq -96(%rbp), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  movq -120(%rbp), %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call sumaLecturas
  movq -96(%rbp), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  movq $40, %rax
  pushq %rax
  movq -128(%rbp), %rax
  pushq %rax
  popq %r8
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call contarAlarmas
  leaq __str_8(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -104(%rbp), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  leaq __str_9(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -112(%rbp), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  movq -104(%rbp), %rax
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
  movq %rax, -136(%rbp)
  leaq __str_10(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -136(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  movabsq $4608083138725491507, %rax
  movq %rax, %xmm0
  movq %rax, -144(%rbp)
  movq $1, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  cvtsi2sdq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movq -144(%rbp), %rax
  movq %rax, %xmm0
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  mulsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -152(%rbp)
  leaq __str_11(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -152(%rbp), %rax
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
  movq %rax, -160(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_2:
  movq -16(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_2
  movq $0, %rax
  movq %rax, -24(%rbp)
while_3:
  movq -24(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_3
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_4
  movq $1, %rax
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
  movq -160(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  jmp endif_4
else_4:
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
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
  movq -160(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
endif_4:
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -24(%rbp)
  jmp while_3
endwhile_3:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_2
endwhile_2:
  leaq __str_12(%rip), %rax
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
  movq -160(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emitir_int
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
  movq $3, %rax
  movq %rax, -168(%rbp)
  movq $4, %rax
  movq %rax, -176(%rbp)
  movq -168(%rbp), %rax
  movq -176(%rbp), %rcx
  imulq %rcx, %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -184(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_7:
  movq -16(%rbp), %rax
  movq -168(%rbp), %rcx
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
  movq -176(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_8
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq $10, %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq -176(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -184(%rbp), %rax
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
  leaq __str_13(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_9:
  movq -16(%rbp), %rax
  movq -168(%rbp), %rcx
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
  movq -176(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_10
  movq -16(%rbp), %rax
  movq -176(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  movq -184(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emitir_int
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
  movq %rax, -192(%rbp)
  movq $501, %rax
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
  movq $502, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -200(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -208(%rbp)
  movq $503, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -208(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -216(%rbp)
  movq $504, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -216(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -200(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -192(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -208(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -200(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -216(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -208(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_14(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -240(%rbp)
  movq -192(%rbp), %rax
  movq %rax, -224(%rbp)
  movq $1, %rax
  movq %rax, -232(%rbp)
while_11:
  movq -232(%rbp), %rax
  movq $4, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_11
  movq $0, %rdi
  movq -224(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  movq $0, %rdi
  movq -224(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, %rcx
  movq -240(%rbp), %rax
  addq %rcx, %rax
  movq %rax, -240(%rbp)
  movq -232(%rbp), %rax
  movq $4, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_12
  movq $1, %rdi
  movq -224(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -224(%rbp)
  jmp endif_12
else_12:
endif_12:
  movq -232(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -232(%rbp)
  jmp while_11
endwhile_11:
  leaq __str_15(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -240(%rbp), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  leaq __str_16(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $12, %rax
  pushq %rax
  popq %rdi
  call fib
  pushq %rax
  popq %rdi
  call emitir_int
  movq -112(%rbp), %rax
  movq $6, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setge %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_13
  movq $1, %rax
  movq %rax, -248(%rbp)
  jmp endif_13
else_13:
  movq -112(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setge %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_14
  movq $2, %rax
  movq %rax, -248(%rbp)
  jmp endif_14
else_14:
  movq $3, %rax
  movq %rax, -248(%rbp)
endif_14:
endif_13:
  movq -248(%rbp), %rax
  movq %rax, %r10
  movq $1, %rax
  cmpq %rax, %r10
  je case_15_1
  movq $2, %rax
  cmpq %rax, %r10
  je case_15_2
  jmp default_15
case_15_1:
  leaq __str_17(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_15
  jmp endswitch_15
case_15_2:
  leaq __str_18(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_15
  jmp endswitch_15
default_15:
  leaq __str_19(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
endswitch_15:
  movq -104(%rbp), %rax
  movq %rax, -256(%rbp)
  movq $0, %rax
  movq %rax, -264(%rbp)
dowhile_16:
  movq -256(%rbp), %rax
  movq $100, %rcx
  subq %rcx, %rax
  movq %rax, -256(%rbp)
  movq -264(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -264(%rbp)
  movq -256(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  cmpq $0, %rax
  jne dowhile_16
endwhile_16:
  leaq __str_20(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -264(%rbp), %rax
  pushq %rax
  popq %rdi
  call emitir_int
  movq -112(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  pushq %rax
  subq $8, %rsp
  movq -104(%rbp), %rax
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
  je else_17
  leaq __str_21(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endif_17
else_17:
endif_17:
  movq -248(%rbp), %rax
  movq $1, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  pushq %rax
  subq $8, %rsp
  movq -240(%rbp), %rax
  movq $2000, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  orq %rcx, %rax
  cmpq $0, %rax
  je else_18
  leaq __str_22(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endif_18
else_18:
endif_18:
  leaq __str_23(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  jmp .end_main
.end_main:
  leave
  ret

.globl crearSensor
crearSensor:
  pushq %rbp
  movq %rsp, %rbp
  subq $48, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -32(%rbp)
  movq -8(%rbp), %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -16(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -24(%rbp), %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -32(%rbp), %rax
  jmp .end_crearSensor
.end_crearSensor:
  leave
  ret

.globl calibrar
calibrar:
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
  jmp .end_calibrar
.end_calibrar:
  leave
  ret

.globl intercambiar
intercambiar:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -8(%rbp), %rax
  movq (%rax), %rax
  movq %rax, -24(%rbp)
  movq -16(%rbp), %rax
  movq (%rax), %rax
  pushq %rax
  movq -8(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq -24(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq $0, %rax
  jmp .end_intercambiar
.end_intercambiar:
  leave
  ret

.globl sumaLecturas
sumaLecturas:
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
  je else_19
  movq $0, %rax
  jmp .end_sumaLecturas
  jmp endif_19
else_19:
endif_19:
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
  call sumaLecturas
  movq $0, %rax
  jmp .end_sumaLecturas
.end_sumaLecturas:
  leave
  ret

.globl contarAlarmas
contarAlarmas:
  pushq %rbp
  movq %rsp, %rbp
  subq $48, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq %rcx, -32(%rbp)
  movq %r8, -40(%rbp)
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_20
  movq $0, %rax
  jmp .end_contarAlarmas
  jmp endif_20
else_20:
endif_20:
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
  je else_21
  movq -40(%rbp), %rax
  movq (%rax), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -40(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  jmp endif_21
else_21:
endif_21:
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
  movq -40(%rbp), %rax
  pushq %rax
  popq %r8
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call contarAlarmas
  movq $0, %rax
  jmp .end_contarAlarmas
.end_contarAlarmas:
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
  je else_22
  movq -8(%rbp), %rax
  jmp .end_fib
  jmp endif_22
else_22:
endif_22:
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

.globl minG_int
minG_int:
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
  je else_23
  movq -8(%rbp), %rax
  jmp .end_minG_int
  jmp endif_23
else_23:
endif_23:
  movq -16(%rbp), %rax
  jmp .end_minG_int
.end_minG_int:
  leave
  ret

.globl maxG_int
maxG_int:
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
  je else_24
  movq -8(%rbp), %rax
  jmp .end_maxG_int
  jmp endif_24
else_24:
endif_24:
  movq -16(%rbp), %rax
  jmp .end_maxG_int
.end_maxG_int:
  leave
  ret

.globl emitir_int
emitir_int:
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
  jmp .end_emitir_int
.end_emitir_int:
  leave
  ret

.section .note.GNU-stack,"",@progbits
