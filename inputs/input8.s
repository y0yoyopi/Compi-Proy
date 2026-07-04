.data
print_fmt: .string "%ld \n"
print_str_fmt: .string "%s\n"
print_float_fmt: .string "%f \n"
itoa_fmt: .string "%ld"
ftoa_fmt: .string "%f"
__str_0: .string "-- Resultado stress total --"

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
  subq $80, %rsp
  movq $2, %rax
  movq %rax, -8(%rbp)
  movq $3, %rax
  movq %rax, -16(%rbp)
  movq $5, %rax
  movq %rax, -24(%rbp)
  movq $7, %rax
  movq %rax, -32(%rbp)
  movq $11, %rax
  movq %rax, -40(%rbp)
  movq $13, %rax
  movq %rax, -48(%rbp)
  movq $0, %rax
  movq %rax, -56(%rbp)
  movq $0, %rax
  movq %rax, -72(%rbp)
while_0:
  movq -72(%rbp), %rax
  movq $100, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_0
  movq $0, %rax
  movq %rax, -80(%rbp)
while_1:
  movq -80(%rbp), %rax
  movq $50000, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_1
  movq $72, %rax
  movq %rax, %rcx
  movq -56(%rbp), %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -40(%rbp), %rax
  movq -48(%rbp), %rcx
  imulq %rcx, %rax
  movq %rax, %rcx
  movq -32(%rbp), %rax
  addq %rcx, %rax
  movq %rax, %rcx
  movq -24(%rbp), %rax
  subq %rcx, %rax
  movq %rax, %rcx
  movq -16(%rbp), %rax
  imulq %rcx, %rax
  movq %rax, %rcx
  movq -8(%rbp), %rax
  addq %rcx, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -8(%rbp), %rax
  imulq %rax, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -16(%rbp), %rax
  imulq %rax, %rax
  imulq %rax, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -24(%rbp), %rax
  imulq %rax, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -32(%rbp), %rax
  imulq %rax, %rax
  imulq %rax, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -8(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  pushq %rax
  movq -24(%rbp), %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call sumar
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -32(%rbp), %rax
  pushq %rax
  movq -40(%rbp), %rax
  pushq %rax
  movq -48(%rbp), %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call sumar
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -8(%rbp), %rax
  movq -16(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  imulq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -32(%rbp), %rax
  movq -40(%rbp), %rcx
  imulq %rcx, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -48(%rbp), %rax
  movq -8(%rbp), %rcx
  imulq %rcx, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq $55, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  subq %rcx, %rax
  movq %rax, -56(%rbp)
  movq -80(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -80(%rbp)
  jmp while_1
endwhile_1:
  movq -72(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -72(%rbp)
  jmp while_0
endwhile_0:
  movq $8, %rax
  pushq %rax
  popq %rdi
  call factorial
  movq %rax, -64(%rbp)
  leaq __str_0(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -56(%rbp), %rax
  movq %rax, %rsi
  leaq print_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -64(%rbp), %rax
  movq %rax, %rsi
  leaq print_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  jmp .end_main
.end_main:
  leave
  ret

.globl sumar
sumar:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq -8(%rbp), %rax
  movq -16(%rbp), %rcx
  addq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  jmp .end_sumar
.end_sumar:
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
  je else_2
  movq $1, %rax
  movq %rax, -16(%rbp)
  jmp endif_2
else_2:
  movq -8(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rdi
  call factorial
  movq %rax, %rcx
  movq -8(%rbp), %rax
  imulq %rcx, %rax
  movq %rax, -16(%rbp)
endif_2:
  movq -16(%rbp), %rax
  jmp .end_factorial
.end_factorial:
  leave
  ret

.section .note.GNU-stack,"",@progbits
