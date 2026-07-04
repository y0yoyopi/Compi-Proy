.data
print_fmt: .string "%ld \n"
print_str_fmt: .string "%s\n"
print_float_fmt: .string "%f \n"
itoa_fmt: .string "%ld"
ftoa_fmt: .string "%f"
__str_29: .string "-- Repetir 5 --"
__str_31: .string "~~ FIN TEXTO ~~"
__str_17: .string "-- Longitud promedio --"
__str_10: .string "lexico"
__str_30: .string "Texto verificado"
__str_7: .string "!!!"
__str_6: .string "-- Saludo --"
__str_8: .string "-- Con enfasis --"
__str_5: .string " "
__str_4: .string "Mundo"
__str_12: .string "semantico"
__str_0: .string "~~ "
__str_1: .string "TEXTO"
__str_3: .string "Hola"
__str_19: .string "-- Matriz de frecuencias 3x3 --"
__str_13: .string "codigo"
__str_25: .string "Palabra larga"
__str_22: .string "-- Palabra (long : veces) --"
__str_23: .string "-- Tokens (lista) --"
__str_15: .string "-- Longitud maxima --"
__str_24: .string "-- Total longitud de la frase --"
__str_16: .string "-- Total de caracteres --"
__str_18: .string "-- Estimado ponderado --"
__str_14: .string "-- Longitudes --"
__str_20: .string "-- Posiciones 2x4 --"
__str_2: .string " ~~"
__str_26: .string "Palabra media"
__str_9: .string "compilador"
__str_27: .string "Palabra corta"
__str_11: .string "parser"
__str_21: .string "estructura"
__str_28: .string "-- Lineas de 8 caracteres --"

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
  subq $288, %rsp
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
  movq %rax, -40(%rbp)
  movq -40(%rbp), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  leaq __str_3(%rip), %rax
  movq %rax, -8(%rbp)
  leaq __str_4(%rip), %rax
  movq %rax, -16(%rbp)
  movq -8(%rbp), %rax
  pushq %rax
  leaq __str_5(%rip), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rsi
  popq %rdi
  call __runtime_concat
  movq %rax, %rsi
  popq %rdi
  call __runtime_concat
  movq %rax, -24(%rbp)
  leaq __str_6(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -24(%rbp), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -24(%rbp), %rax
  movq %rax, %rdi
  call strlen@PLT
  pushq %rax
  popq %rdi
  call say_int
  movq -24(%rbp), %rax
  pushq %rax
  leaq __str_7(%rip), %rax
  movq %rax, %rsi
  popq %rdi
  call __runtime_concat
  movq %rax, -32(%rbp)
  leaq __str_8(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -32(%rbp), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -32(%rbp), %rax
  movq %rax, %rdi
  call strlen@PLT
  pushq %rax
  popq %rdi
  call say_int
  movq $5, %rax
  movq %rax, -64(%rbp)
  movq -64(%rbp), %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -72(%rbp)
  leaq __str_9(%rip), %rax
  movq %rax, %rdi
  call strlen@PLT
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -72(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_10(%rip), %rax
  movq %rax, %rdi
  call strlen@PLT
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -72(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_11(%rip), %rax
  movq %rax, %rdi
  call strlen@PLT
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -72(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_12(%rip), %rax
  movq %rax, %rdi
  call strlen@PLT
  pushq %rax
  movq $3, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -72(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_13(%rip), %rax
  movq %rax, %rdi
  call strlen@PLT
  pushq %rax
  movq $4, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -72(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_14(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -48(%rbp)
while_0:
  movq -48(%rbp), %rax
  movq -64(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_0
  movq -48(%rbp), %rax
  movq %rax, %rdi
  movq -72(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call say_int
  movq -48(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -48(%rbp)
  jmp while_0
endwhile_0:
  movq $0, %rax
  movq %rax, %rdi
  movq -72(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -80(%rbp)
  movq $1, %rax
  movq %rax, -48(%rbp)
while_1:
  movq -48(%rbp), %rax
  movq -64(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_1
  movq -80(%rbp), %rax
  pushq %rax
  movq -48(%rbp), %rax
  movq %rax, %rdi
  movq -72(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call maxL_int
  movq %rax, -80(%rbp)
  movq -48(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -48(%rbp)
  jmp while_1
endwhile_1:
  leaq __str_15(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -80(%rbp), %rax
  pushq %rax
  popq %rdi
  call say_int
  movq $0, %rax
  movq %rax, -88(%rbp)
  leaq -88(%rbp), %rax
  movq %rax, -96(%rbp)
  movq -72(%rbp), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq -64(%rbp), %rax
  pushq %rax
  movq -96(%rbp), %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call sumaLens
  leaq __str_16(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -88(%rbp), %rax
  pushq %rax
  popq %rdi
  call say_int
  movq -88(%rbp), %rax
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
  movq -64(%rbp), %rax
  addq $8, %rsp
  cvtsi2sdq %rax, %xmm0
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  divsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -104(%rbp)
  leaq __str_17(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -104(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  movabsq $4609434218613702656, %rax
  movq %rax, %xmm0
  movq %rax, -112(%rbp)
  movq -88(%rbp), %rax
  cvtsi2sdq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movq -112(%rbp), %rax
  movq %rax, %xmm0
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  mulsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -120(%rbp)
  leaq __str_18(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -120(%rbp), %rax
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
  movq %rax, -128(%rbp)
  movq $0, %rax
  movq %rax, -48(%rbp)
while_2:
  movq -48(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_2
  movq $0, %rax
  movq %rax, -56(%rbp)
while_3:
  movq -56(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_3
  movq -48(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -56(%rbp), %rax
  movq $2, %rcx
  addq %rcx, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  imulq %rcx, %rax
  pushq %rax
  movq -48(%rbp), %rax
  pushq %rax
  movq -56(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  popq %rcx
  movq -128(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -56(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -56(%rbp)
  jmp while_3
endwhile_3:
  movq -48(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -48(%rbp)
  jmp while_2
endwhile_2:
  leaq __str_19(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -48(%rbp)
while_4:
  movq -48(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_4
  movq $0, %rax
  movq %rax, -56(%rbp)
while_5:
  movq -56(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_5
  movq -48(%rbp), %rax
  pushq %rax
  movq -56(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  movq -128(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call say_int
  movq -56(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -56(%rbp)
  jmp while_5
endwhile_5:
  movq -48(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -48(%rbp)
  jmp while_4
endwhile_4:
  movq $2, %rax
  movq %rax, -136(%rbp)
  movq $4, %rax
  movq %rax, -144(%rbp)
  movq -136(%rbp), %rax
  movq -144(%rbp), %rcx
  imulq %rcx, %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -152(%rbp)
  movq $0, %rax
  movq %rax, -48(%rbp)
while_6:
  movq -48(%rbp), %rax
  movq -136(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_6
  movq $0, %rax
  movq %rax, -56(%rbp)
while_7:
  movq -56(%rbp), %rax
  movq -144(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_7
  movq -48(%rbp), %rax
  movq -144(%rbp), %rcx
  imulq %rcx, %rax
  movq -56(%rbp), %rcx
  addq %rcx, %rax
  pushq %rax
  movq -48(%rbp), %rax
  movq -144(%rbp), %rcx
  imulq %rcx, %rax
  movq -56(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -152(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -56(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -56(%rbp)
  jmp while_7
endwhile_7:
  movq -48(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -48(%rbp)
  jmp while_6
endwhile_6:
  leaq __str_20(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -48(%rbp)
while_8:
  movq -48(%rbp), %rax
  movq -136(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_8
  movq $0, %rax
  movq %rax, -56(%rbp)
while_9:
  movq -56(%rbp), %rax
  movq -144(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_9
  movq -48(%rbp), %rax
  movq -144(%rbp), %rcx
  imulq %rcx, %rax
  movq -56(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  movq -152(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call say_int
  movq -56(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -56(%rbp)
  jmp while_9
endwhile_9:
  movq -48(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -48(%rbp)
  jmp while_8
endwhile_8:
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -160(%rbp)
  leaq __str_21(%rip), %rax
  movq %rax, %rdi
  call strlen@PLT
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -160(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $2, %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -160(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -160(%rbp), %rax
  pushq %rax
  movq $3, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call incVeces
  leaq __str_22(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rdi
  movq -160(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call say_int
  movq $1, %rdi
  movq -160(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call say_int
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -168(%rbp)
  movq $4, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -168(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -176(%rbp)
  movq $5, %rax
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
  movq $3, %rax
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
  movq $6, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -192(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -176(%rbp), %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -168(%rbp), %rax
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
  leaq __str_23(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -208(%rbp)
  movq -168(%rbp), %rax
  movq %rax, -200(%rbp)
  movq $1, %rax
  movq %rax, -216(%rbp)
while_10:
  movq -216(%rbp), %rax
  movq $4, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_10
  movq $0, %rdi
  movq -200(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call say_int
  movq $0, %rdi
  movq -200(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, %rcx
  movq -208(%rbp), %rax
  addq %rcx, %rax
  movq %rax, -208(%rbp)
  movq -216(%rbp), %rax
  movq $4, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_11
  movq $1, %rdi
  movq -200(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -200(%rbp)
  jmp endif_11
else_11:
endif_11:
  movq -216(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -216(%rbp)
  jmp while_10
endwhile_10:
  leaq __str_24(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -208(%rbp), %rax
  pushq %rax
  popq %rdi
  call say_int
  movq -80(%rbp), %rax
  movq $10, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setge %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_12
  movq $1, %rax
  movq %rax, -224(%rbp)
  jmp endif_12
else_12:
  movq -80(%rbp), %rax
  movq $6, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setge %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_13
  movq $2, %rax
  movq %rax, -224(%rbp)
  jmp endif_13
else_13:
  movq $3, %rax
  movq %rax, -224(%rbp)
endif_13:
endif_12:
  movq -224(%rbp), %rax
  movq %rax, %r10
  movq $1, %rax
  cmpq %rax, %r10
  je case_14_1
  movq $2, %rax
  cmpq %rax, %r10
  je case_14_2
  jmp default_14
case_14_1:
  leaq __str_25(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_14
  jmp endswitch_14
case_14_2:
  leaq __str_26(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_14
  jmp endswitch_14
default_14:
  leaq __str_27(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
endswitch_14:
  movq -88(%rbp), %rax
  movq %rax, -232(%rbp)
  movq $0, %rax
  movq %rax, -240(%rbp)
dowhile_15:
  movq -232(%rbp), %rax
  movq $8, %rcx
  subq %rcx, %rax
  movq %rax, -232(%rbp)
  movq -240(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -240(%rbp)
  movq -232(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  cmpq $0, %rax
  jne dowhile_15
endwhile_15:
  leaq __str_28(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -240(%rbp), %rax
  pushq %rax
  popq %rdi
  call say_int
  leaq __str_29(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $5, %rax
  pushq %rax
  popq %rdi
  call repetir
  pushq %rax
  popq %rdi
  call say_int
  movq -32(%rbp), %rax
  movq %rax, %rdi
  call strlen@PLT
  movq $13, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  pushq %rax
  subq $8, %rsp
  movq -88(%rbp), %rax
  movq $37, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  andq %rcx, %rax
  cmpq $0, %rax
  je else_16
  leaq __str_30(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endif_16
else_16:
endif_16:
  leaq __str_31(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  jmp .end_main
.end_main:
  leave
  ret

.globl incVeces
incVeces:
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
  jmp .end_incVeces
.end_incVeces:
  leave
  ret

.globl sumaLens
sumaLens:
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
  jmp .end_sumaLens
  jmp endif_17
else_17:
endif_17:
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
  call sumaLens
  movq $0, %rax
  jmp .end_sumaLens
.end_sumaLens:
  leave
  ret

.globl repetir
repetir:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_18
  movq $0, %rax
  jmp .end_repetir
  jmp endif_18
else_18:
endif_18:
  movq -8(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rdi
  call repetir
  movq %rax, %rcx
  movq $1, %rax
  addq %rcx, %rax
  jmp .end_repetir
.end_repetir:
  leave
  ret

.globl maxL_int
maxL_int:
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
  jmp .end_maxL_int
  jmp endif_19
else_19:
endif_19:
  movq -16(%rbp), %rax
  jmp .end_maxL_int
.end_maxL_int:
  leave
  ret

.globl say_int
say_int:
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
  jmp .end_say_int
.end_say_int:
  leave
  ret

.section .note.GNU-stack,"",@progbits
