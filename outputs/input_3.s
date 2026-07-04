.data
print_fmt: .string "%ld \n"
print_str_fmt: .string "%s\n"
print_float_fmt: .string "%f \n"
itoa_fmt: .string "%ld"
ftoa_fmt: .string "%f"
__str_15: .string "-- Iteraciones para x=0 --"
__str_13: .string "Octante -++"
__str_0: .string ">> "
__str_16: .string "Producto punto en rango"
__str_4: .string "-- Distancias al cuadrado --"
__str_9: .string "-- Matriz identidad 3x3 --"
__str_1: .string "GEOMETRIA 3D"
__str_3: .string "-- B trasladado --"
__str_17: .string ">> FIN GEOMETRIA"
__str_11: .string "-- Polilinea (vertices) --"
__str_14: .string "Otro octante"
__str_5: .string "-- Norma^2 escalada --"
__str_7: .string "-- Vector v --"
__str_6: .string "-- Vector u --"
__str_2: .string "-- Coordenadas de A --"
__str_8: .string "-- Producto punto u.v --"
__str_10: .string "-- Malla aplanada 3x4 --"
__str_12: .string "Octante +++"

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
  movq %rax, %rsi
  popq %rdi
  call __runtime_concat
  movq %rax, -8(%rbp)
  movq -8(%rbp), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call crearPunto
  movq %rax, -40(%rbp)
  movq $3, %rax
  pushq %rax
  movq $4, %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call crearPunto
  movq %rax, -48(%rbp)
  movq $1, %rax
  pushq %rax
  movq $2, %rax
  pushq %rax
  movq $2, %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call crearPunto
  movq %rax, -56(%rbp)
  leaq __str_2(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq $1, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq $2, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq -56(%rbp), %rax
  pushq %rax
  movq $10, %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq $1, %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call trasladar
  leaq __str_3(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq $1, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq $2, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  leaq __str_4(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -40(%rbp), %rax
  pushq %rax
  movq -48(%rbp), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call distanciaSq
  pushq %rax
  popq %rdi
  call show_int
  movq -40(%rbp), %rax
  pushq %rax
  movq -56(%rbp), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call distanciaSq
  pushq %rax
  popq %rdi
  call show_int
  movq -40(%rbp), %rax
  pushq %rax
  movq -48(%rbp), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call distanciaSq
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
  movq %rax, -64(%rbp)
  movabsq $4612811918334230528, %rax
  movq %rax, %xmm0
  movq %rax, -72(%rbp)
  movq -64(%rbp), %rax
  movq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movq -72(%rbp), %rax
  movq %rax, %xmm0
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  mulsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -80(%rbp)
  leaq __str_5(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -80(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  movq $5, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -88(%rbp)
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
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -88(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -32(%rbp), %rax
  movq -16(%rbp), %rcx
  subq %rcx, %rax
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
  movq -88(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_1
endwhile_1:
  leaq __str_7(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
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
  movq -96(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_2
endwhile_2:
  movq $0, %rax
  movq %rax, -104(%rbp)
  leaq -104(%rbp), %rax
  movq %rax, -112(%rbp)
  movq -88(%rbp), %rax
  pushq %rax
  movq -96(%rbp), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  movq -112(%rbp), %rax
  pushq %rax
  popq %r8
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call dotRec
  leaq __str_8(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -104(%rbp), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq $3, %rax
  pushq %rax
  movq $3, %rax
  popq %rcx
  imulq %rcx, %rax
  salq $3, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -120(%rbp)
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
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_5
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
  movq -120(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  jmp endif_5
else_5:
  movq $0, %rax
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
  movq -120(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
endif_5:
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
  leaq __str_9(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_6:
  movq -16(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_6
  movq $0, %rax
  movq %rax, -24(%rbp)
while_7:
  movq -24(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_7
  movq -16(%rbp), %rax
  pushq %rax
  movq -24(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq $3, %rcx
  imulq %rcx, %rax
  addq %rdi, %rax
  movq %rax, %rdi
  movq -120(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -24(%rbp)
  jmp while_7
endwhile_7:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_6
endwhile_6:
  movq $3, %rax
  movq %rax, -128(%rbp)
  movq $4, %rax
  movq %rax, -136(%rbp)
  movq -128(%rbp), %rax
  movq -136(%rbp), %rcx
  imulq %rcx, %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -144(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_8:
  movq -16(%rbp), %rax
  movq -128(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_8
  movq $0, %rax
  movq %rax, -24(%rbp)
while_9:
  movq -24(%rbp), %rax
  movq -136(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_9
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
  movq -136(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -144(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -24(%rbp)
  jmp while_9
endwhile_9:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_8
endwhile_8:
  leaq __str_10(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_10:
  movq -16(%rbp), %rax
  movq -128(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_10
  movq $0, %rax
  movq %rax, -24(%rbp)
while_11:
  movq -24(%rbp), %rax
  movq -136(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_11
  movq -16(%rbp), %rax
  movq -136(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  movq -144(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -24(%rbp)
  jmp while_11
endwhile_11:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_10
endwhile_10:
  movq $16, %rdi
  call malloc@PLT
  movq %rax, -152(%rbp)
  movq $100, %rax
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
  movq $200, %rax
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
  movq $300, %rax
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
  leaq __str_11(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -152(%rbp), %rax
  movq %rax, -176(%rbp)
  movq $1, %rax
  movq %rax, -184(%rbp)
while_12:
  movq -184(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_12
  movq $0, %rdi
  movq -176(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq -184(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_13
  movq $1, %rdi
  movq -176(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -176(%rbp)
  jmp endif_13
else_13:
endif_13:
  movq -184(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -184(%rbp)
  jmp while_12
endwhile_12:
  movq $1, %rax
  movq %rax, -192(%rbp)
  movq -192(%rbp), %rax
  movq %rax, %r10
  movq $1, %rax
  cmpq %rax, %r10
  je case_14_1
  movq $2, %rax
  cmpq %rax, %r10
  je case_14_2
  jmp default_14
case_14_1:
  leaq __str_12(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_14
  jmp endswitch_14
case_14_2:
  leaq __str_13(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_14
  jmp endswitch_14
default_14:
  leaq __str_14(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
endswitch_14:
  movq $0, %rdi
  movq -48(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -200(%rbp)
  movq $0, %rax
  movq %rax, -208(%rbp)
dowhile_15:
  movq -200(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  movq %rax, -200(%rbp)
  movq -208(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -208(%rbp)
  movq -200(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  cmpq $0, %rax
  jne dowhile_15
endwhile_15:
  leaq __str_15(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -208(%rbp), %rax
  pushq %rax
  popq %rdi
  call show_int
  movq -104(%rbp), %rax
  movq $30, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  pushq %rax
  subq $8, %rsp
  movq -104(%rbp), %rax
  movq $40, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  andq %rcx, %rax
  cmpq $0, %rax
  je else_16
  leaq __str_16(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endif_16
else_16:
endif_16:
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

.globl crearPunto
crearPunto:
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
  jmp .end_crearPunto
.end_crearPunto:
  leave
  ret

.globl distanciaSq
distanciaSq:
  pushq %rbp
  movq %rsp, %rbp
  subq $48, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq $0, %rdi
  movq -16(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  subq $8, %rsp
  movq $0, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  movq %rax, -24(%rbp)
  movq $1, %rdi
  movq -16(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  subq $8, %rsp
  movq $1, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  movq %rax, -32(%rbp)
  movq $2, %rdi
  movq -16(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  subq $8, %rsp
  movq $2, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  movq %rax, -40(%rbp)
  movq -24(%rbp), %rax
  imulq %rax, %rax
  pushq %rax
  subq $8, %rsp
  movq -32(%rbp), %rax
  imulq %rax, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -40(%rbp), %rax
  imulq %rax, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  jmp .end_distanciaSq
.end_distanciaSq:
  leave
  ret

.globl trasladar
trasladar:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq %rcx, -32(%rbp)
  movq -8(%rbp), %rax
  movq %rax, -40(%rbp)
  movq -8(%rbp), %rax
  addq $8, %rax
  movq %rax, -48(%rbp)
  movq -8(%rbp), %rax
  addq $16, %rax
  movq %rax, -56(%rbp)
  movq -40(%rbp), %rax
  movq (%rax), %rax
  movq -16(%rbp), %rcx
  addq %rcx, %rax
  pushq %rax
  movq -40(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq -48(%rbp), %rax
  movq (%rax), %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  pushq %rax
  movq -48(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq -56(%rbp), %rax
  movq (%rax), %rax
  movq -32(%rbp), %rcx
  addq %rcx, %rax
  pushq %rax
  movq -56(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq $0, %rax
  jmp .end_trasladar
.end_trasladar:
  leave
  ret

.globl dotRec
dotRec:
  pushq %rbp
  movq %rsp, %rbp
  subq $48, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq %rcx, -32(%rbp)
  movq %r8, -40(%rbp)
  movq -24(%rbp), %rax
  movq -32(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_17
  movq $0, %rax
  jmp .end_dotRec
  jmp endif_17
else_17:
endif_17:
  movq -24(%rbp), %rax
  movq %rax, %rdi
  movq -8(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  subq $8, %rsp
  movq -24(%rbp), %rax
  movq %rax, %rdi
  movq -16(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  imulq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -40(%rbp), %rax
  movq (%rax), %rax
  addq $8, %rsp
  popq %rcx
  addq %rcx, %rax
  pushq %rax
  movq -40(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq -8(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  pushq %rax
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
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
  call dotRec
  movq $0, %rax
  jmp .end_dotRec
.end_dotRec:
  leave
  ret

.globl show_int
show_int:
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
  jmp .end_show_int
.end_show_int:
  leave
  ret

.section .note.GNU-stack,"",@progbits
