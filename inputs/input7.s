.data
print_fmt: .string "%ld \n"
print_str_fmt: .string "%s\n"
print_float_fmt: .string "%f \n"
itoa_fmt: .string "%ld"
ftoa_fmt: .string "%f"
__str_0: .string "-- Resultado strength reduction intensivo --"

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
  subq $48, %rsp
  movq $3, %rax
  movq %rax, -8(%rbp)
  movq $5, %rax
  movq %rax, -16(%rbp)
  movq $7, %rax
  movq %rax, -24(%rbp)
  movq $0, %rax
  movq %rax, -32(%rbp)
  movq $0, %rax
  movq %rax, -40(%rbp)
while_0:
  movq -40(%rbp), %rax
  movq $2000000, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_0
  movq -8(%rbp), %rax
  imulq %rax, %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -8(%rbp), %rax
  imulq %rax, %rax
  imulq %rax, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq $8, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -16(%rbp), %rax
  pushq %rax
  movq $3, %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, %rdi
  movq %rcx, %rsi
  call potencia
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -24(%rbp), %rax
  pushq %rax
  movq $5, %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, %rdi
  movq %rcx, %rsi
  call potencia
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq $81, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -16(%rbp), %rax
  imulq %rax, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -24(%rbp), %rax
  imulq %rax, %rax
  imulq %rax, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -8(%rbp), %rax
  imulq %rax, %rax
  movq $2, %rcx
  imulq %rcx, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -16(%rbp), %rax
  imulq %rax, %rax
  imulq %rax, %rax
  movq $5, %rcx
  cqto
  idivq %rcx
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  movq %rax, -32(%rbp)
  movq -40(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -40(%rbp)
  jmp while_0
endwhile_0:
  leaq __str_0(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -32(%rbp), %rax
  movq %rax, %rsi
  leaq print_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  jmp .end_main
.end_main:
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
