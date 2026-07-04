.data
print_fmt: .string "%ld \n"
print_str_fmt: .string "%s\n"
print_float_fmt: .string "%f \n"
itoa_fmt: .string "%ld"
ftoa_fmt: .string "%f"
__str_20: .string "Hay bloques por ejecutar"
__str_18: .string "-- Tras doble puntero --"
__str_17: .string "-- Tras swap de duraciones --"
__str_16: .string "-- Bloques de 20 --"
__str_13: .string "Cola activa"
__str_15: .string "Estado invalido"
__str_14: .string "Cola pausada"
__str_0: .string "[[ "
__str_5: .string "-- Duraciones --"
__str_19: .string "Planificacion critica"
__str_7: .string "-- Duracion promedio --"
__str_4: .string "-- Prioridad maxima --"
__str_1: .string "PLANIFICADOR"
__str_9: .string "-- Asignacion 3x3 --"
__str_2: .string " ]]"
__str_8: .string "-- Estimado con holgura --"
__str_3: .string "-- Cola (id : prioridad) --"
__str_6: .string "-- Duracion total --"
__str_12: .string "Cola vacia"
__str_21: .string "[[ FIN PLANIFICADOR ]]"
__str_10: .string "-- Grid aplanado 2x3 --"
__str_11: .string "-- Cuenta atras desde 7 --"

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
  subq $304, %rsp
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
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -40(%rbp)
  movq $1, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $5, %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -48(%rbp)
  movq $2, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -48(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $3, %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -48(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -56(%rbp)
  movq $3, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $8, %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -64(%rbp)
  movq $4, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -64(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $1, %rax
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -64(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -48(%rbp), %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -40(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -56(%rbp), %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -48(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -64(%rbp), %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -48(%rbp), %rax
  pushq %rax
  movq $4, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call subirPrioridad
  leaq __str_3(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -80(%rbp)
  movq -40(%rbp), %rax
  movq %rax, -72(%rbp)
  movq $1, %rax
  movq %rax, -88(%rbp)
while_0:
  movq -88(%rbp), %rax
  movq $4, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_0
  movq $0, %rdi
  movq -72(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call ver_int
  movq $1, %rdi
  movq -72(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call ver_int
  movq -80(%rbp), %rax
  pushq %rax
  movq $1, %rdi
  movq -72(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call top_int
  movq %rax, -80(%rbp)
  movq -88(%rbp), %rax
  movq $4, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_1
  movq $2, %rdi
  movq -72(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -72(%rbp)
  jmp endif_1
else_1:
endif_1:
  movq -88(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -88(%rbp)
  jmp while_0
endwhile_0:
  leaq __str_4(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -80(%rbp), %rax
  pushq %rax
  popq %rdi
  call ver_int
  movq $6, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
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
  movq $1, %rcx
  addq %rcx, %rax
  movq $3, %rcx
  imulq %rcx, %rax
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
  jmp while_2
endwhile_2:
  leaq __str_5(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_3:
  movq -16(%rbp), %rax
  movq -32(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_3
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -96(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call ver_int
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_3
endwhile_3:
  movq $0, %rax
  movq %rax, -104(%rbp)
  leaq -104(%rbp), %rax
  movq %rax, -112(%rbp)
  movq -96(%rbp), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  movq -112(%rbp), %rax
  pushq %rax
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi
  call sumaPrio
  leaq __str_6(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -104(%rbp), %rax
  pushq %rax
  popq %rdi
  call ver_int
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
  movq %rax, -120(%rbp)
  leaq __str_7(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -120(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  movabsq $4608308318706860032, %rax
  movq %rax, %xmm0
  movq %rax, -128(%rbp)
  movq -104(%rbp), %rax
  cvtsi2sdq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movq -128(%rbp), %rax
  movq %rax, %xmm0
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  mulsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -136(%rbp)
  leaq __str_8(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -136(%rbp), %rax
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
  movq %rax, -144(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_4:
  movq -16(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_4
  movq $0, %rax
  movq %rax, -24(%rbp)
while_5:
  movq -24(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_5
  movq -16(%rbp), %rax
  movq $3, %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq $1, %rcx
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
  movq -144(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -24(%rbp)
  jmp while_5
endwhile_5:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_4
endwhile_4:
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
  movq -144(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call ver_int
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
  movq $2, %rax
  movq %rax, -152(%rbp)
  movq $3, %rax
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
while_8:
  movq -16(%rbp), %rax
  movq -152(%rbp), %rcx
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
  movq -160(%rbp), %rcx
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
  movq -152(%rbp), %rcx
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
  movq -160(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_11
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
  call ver_int
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
  leaq __str_11(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $7, %rax
  pushq %rax
  popq %rdi
  call cuentaAtras
  pushq %rax
  popq %rdi
  call ver_int
  movq $2, %rax
  movq %rax, -176(%rbp)
  movq -176(%rbp), %rax
  movq %rax, %r10
  movq $1, %rax
  cmpq %rax, %r10
  je case_12_1
  movq $2, %rax
  cmpq %rax, %r10
  je case_12_2
  movq $3, %rax
  cmpq %rax, %r10
  je case_12_3
  jmp default_12
case_12_1:
  leaq __str_12(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_12
  jmp endswitch_12
case_12_2:
  leaq __str_13(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_12
  jmp endswitch_12
case_12_3:
  leaq __str_14(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_12
  jmp endswitch_12
default_12:
  leaq __str_15(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
endswitch_12:
  movq -104(%rbp), %rax
  movq %rax, -184(%rbp)
  movq $0, %rax
  movq %rax, -192(%rbp)
dowhile_13:
  movq -184(%rbp), %rax
  movq $20, %rcx
  subq %rcx, %rax
  movq %rax, -184(%rbp)
  movq -192(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -192(%rbp)
  movq -184(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setg %al
  movzbq %al, %rax
  cmpq $0, %rax
  jne dowhile_13
endwhile_13:
  leaq __str_16(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -192(%rbp), %rax
  pushq %rax
  popq %rdi
  call ver_int
  movq $0, %rax
  movq %rax, %rdi
  movq -96(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -200(%rbp)
  movq $5, %rax
  movq %rax, %rdi
  movq -96(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -208(%rbp)
  leaq -200(%rbp), %rax
  pushq %rax
  leaq -208(%rbp), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call intercambiar
  leaq __str_17(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -200(%rbp), %rax
  pushq %rax
  popq %rdi
  call ver_int
  movq -208(%rbp), %rax
  pushq %rax
  popq %rdi
  call ver_int
  leaq -200(%rbp), %rax
  movq %rax, -216(%rbp)
  leaq -216(%rbp), %rax
  movq %rax, -224(%rbp)
  movq $42, %rax
  pushq %rax
  movq -224(%rbp), %rax
  movq (%rax), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  leaq __str_18(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -200(%rbp), %rax
  pushq %rax
  popq %rdi
  call ver_int
  movq -80(%rbp), %rax
  movq $8, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setge %al
  movzbq %al, %rax
  pushq %rax
  subq $8, %rsp
  movq -104(%rbp), %rax
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
  leaq __str_19(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endif_14
else_14:
endif_14:
  movq -192(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je not_true_16
  movq $0, %rax
  jmp not_end_16
not_true_16:
  movq $1, %rax
not_end_16:
  cmpq $0, %rax
  je else_15
  leaq __str_20(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endif_15
else_15:
endif_15:
  leaq __str_21(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  jmp .end_main
.end_main:
  leave
  ret

.globl subirPrioridad
subirPrioridad:
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
  jmp .end_subirPrioridad
.end_subirPrioridad:
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

.globl sumaPrio
sumaPrio:
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
  jmp .end_sumaPrio
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
  call sumaPrio
  movq $0, %rax
  jmp .end_sumaPrio
.end_sumaPrio:
  leave
  ret

.globl cuentaAtras
cuentaAtras:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq -8(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_18
  movq $0, %rax
  jmp .end_cuentaAtras
  jmp endif_18
else_18:
endif_18:
  movq -8(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rdi
  call cuentaAtras
  movq %rax, %rcx
  movq $1, %rax
  addq %rcx, %rax
  jmp .end_cuentaAtras
.end_cuentaAtras:
  leave
  ret

.globl top_int
top_int:
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
  jmp .end_top_int
  jmp endif_19
else_19:
endif_19:
  movq -16(%rbp), %rax
  jmp .end_top_int
.end_top_int:
  leave
  ret

.globl ver_int
ver_int:
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
  jmp .end_ver_int
.end_ver_int:
  leave
  ret

.section .note.GNU-stack,"",@progbits
