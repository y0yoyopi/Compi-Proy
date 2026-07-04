.data
print_fmt: .string "%ld \n"
print_str_fmt: .string "%s\n"
print_float_fmt: .string "%f \n"
itoa_fmt: .string "%ld"
ftoa_fmt: .string "%f"
__str_22: .string "Recursion verificada"
__str_21: .string "-- Divisiones entre 3 --"
__str_23: .string "&& FIN RECURSION &&"
__str_20: .string "Recursion ligera"
__str_18: .string "Recursion profunda"
__str_17: .string "-- Llamadas registradas --"
__str_15: .string "-- Potencias 2x4 --"
__str_19: .string "Recursion media"
__str_14: .string "-- Triangulo (combinatoria) 3x3 --"
__str_0: .string "&& "
__str_1: .string "RECURSION"
__str_2: .string " &&"
__str_3: .string "-- Fibonacci 0..8 --"
__str_7: .string "-- Suma digitos 12345 --"
__str_10: .string "-- Fib en arreglo --"
__str_4: .string "-- Factoriales 1..6 --"
__str_16: .string "-- Memo (n : fib) --"
__str_5: .string "-- gcd(48,18) --"
__str_13: .string "-- Razon fib[9]/fib[8] --"
__str_8: .string "-- 3^7 --"
__str_6: .string "-- Hanoi(5) movimientos --"
__str_9: .string "-- Suma 1..100 --"
__str_11: .string "-- Mayor Fib y suma --"
__str_12: .string "-- Promedio Fib --"

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
  leaq __str_3(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_0:
  movq -16(%rbp), %rax
  movq $8, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_0
  movq -16(%rbp), %rax
  pushq %rax
  popq %rdi
  call fib
  pushq %rax
  popq %rdi
  call px_int
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_0
endwhile_0:
  leaq __str_4(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $1, %rax
  movq %rax, -16(%rbp)
while_1:
  movq -16(%rbp), %rax
  movq $6, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_1
  movq -16(%rbp), %rax
  pushq %rax
  popq %rdi
  call factorial
  pushq %rax
  popq %rdi
  call px_int
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_1
endwhile_1:
  leaq __str_5(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $48, %rax
  pushq %rax
  movq $18, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call gcd
  pushq %rax
  popq %rdi
  call px_int
  leaq __str_6(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $5, %rax
  pushq %rax
  popq %rdi
  call hanoi
  pushq %rax
  popq %rdi
  call px_int
  leaq __str_7(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $12345, %rax
  pushq %rax
  popq %rdi
  call sumaDigitos
  pushq %rax
  popq %rdi
  call px_int
  leaq __str_8(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $3, %rax
  pushq %rax
  movq $7, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call potencia
  pushq %rax
  popq %rdi
  call px_int
  movq $0, %rax
  movq %rax, -40(%rbp)
  leaq -40(%rbp), %rax
  movq %rax, -48(%rbp)
  movq $100, %rax
  pushq %rax
  movq -48(%rbp), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call sumaHasta
  leaq __str_9(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -40(%rbp), %rax
  pushq %rax
  popq %rdi
  call px_int
  movq $10, %rax
  movq %rax, -32(%rbp)
  movq -32(%rbp), %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -56(%rbp)
  movq -56(%rbp), %rax
  pushq %rax
  movq $0, %rax
  pushq %rax
  movq -32(%rbp), %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call llenarFib
  leaq __str_10(%rip), %rax
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
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call px_int
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_2
endwhile_2:
  movq $0, %rax
  movq %rax, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -64(%rbp)
  movq $0, %rax
  movq %rax, -72(%rbp)
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
  movq -64(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call grande_int
  movq %rax, -64(%rbp)
  movq -16(%rbp), %rax
  movq %rax, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, %rcx
  movq -72(%rbp), %rax
  addq %rcx, %rax
  movq %rax, -72(%rbp)
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_3
endwhile_3:
  leaq __str_11(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -64(%rbp), %rax
  pushq %rax
  popq %rdi
  call px_int
  movq -72(%rbp), %rax
  pushq %rax
  popq %rdi
  call px_int
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
  movq %rax, -80(%rbp)
  leaq __str_12(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -80(%rbp), %rax
  movq %rax, %xmm0
  leaq print_float_fmt(%rip), %rdi
  movq $1, %rax
  call printf@PLT
  movq $9, %rax
  movq %rax, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
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
  movq %rax, -88(%rbp)
  movq -88(%rbp), %rax
  movq %rax, %xmm0
  subq $8, %rsp
  movsd %xmm0, (%rsp)
  subq $8, %rsp
  movq $8, %rax
  movq %rax, %rdi
  movq -56(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
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
  addq $8, %rsp
  movsd %xmm0, %xmm1
  movsd (%rsp), %xmm0
  addq $8, %rsp
  divsd %xmm1, %xmm0
  movq %xmm0, %rax
  movq %rax, -88(%rbp)
  leaq __str_13(%rip), %rax
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
  movq -24(%rbp), %rax
  movq -16(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_6
  movq -24(%rbp), %rax
  pushq %rax
  popq %rdi
  call factorial
  pushq %rax
  subq $8, %rsp
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rdi
  call factorial
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  imulq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -16(%rbp), %rax
  pushq %rax
  popq %rdi
  call factorial
  addq $8, %rsp
  popq %rcx
  cqto
  idivq %rcx
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
  movq -96(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  jmp endif_6
else_6:
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
  movq -96(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
endif_6:
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
  leaq __str_14(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_7:
  movq -16(%rbp), %rax
  movq $3, %rcx
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
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_8
  movq -16(%rbp), %rax
  pushq %rax
  movq -24(%rbp), %rax
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
  call px_int
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
  movq $2, %rax
  movq %rax, -104(%rbp)
  movq $4, %rax
  movq %rax, -112(%rbp)
  movq -104(%rbp), %rax
  movq -112(%rbp), %rcx
  imulq %rcx, %rax
  movq $8, %rcx
  imulq %rcx, %rax
  movq %rax, %rdi
  call malloc@PLT
  movq %rax, -120(%rbp)
  movq $0, %rax
  movq %rax, -16(%rbp)
while_9:
  movq -16(%rbp), %rax
  movq -104(%rbp), %rcx
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
  movq -112(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_10
  movq -16(%rbp), %rax
  movq $2, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -24(%rbp), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call potencia
  pushq %rax
  movq -16(%rbp), %rax
  movq -112(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -120(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
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
  leaq __str_15(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rax
  movq %rax, -16(%rbp)
while_11:
  movq -16(%rbp), %rax
  movq -104(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_11
  movq $0, %rax
  movq %rax, -24(%rbp)
while_12:
  movq -24(%rbp), %rax
  movq -112(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_12
  movq -16(%rbp), %rax
  movq -112(%rbp), %rcx
  imulq %rcx, %rax
  movq -24(%rbp), %rcx
  addq %rcx, %rax
  movq %rax, %rdi
  movq -120(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call px_int
  movq -24(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -24(%rbp)
  jmp while_12
endwhile_12:
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -16(%rbp)
  jmp while_11
endwhile_11:
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -128(%rbp)
  movq $5, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -128(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $5, %rax
  pushq %rax
  popq %rdi
  call fib
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -128(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -136(%rbp)
  movq $7, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -136(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $7, %rax
  pushq %rax
  popq %rdi
  call fib
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -136(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $24, %rdi
  call malloc@PLT
  movq %rax, -144(%rbp)
  movq $9, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -144(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq $9, %rax
  pushq %rax
  popq %rdi
  call fib
  pushq %rax
  movq $1, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -144(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -136(%rbp), %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -128(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -144(%rbp), %rax
  pushq %rax
  movq $2, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -136(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  leaq __str_16(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -128(%rbp), %rax
  movq %rax, -152(%rbp)
  movq $1, %rax
  movq %rax, -160(%rbp)
while_13:
  movq -160(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setle %al
  movzbq %al, %rax
  cmpq $0, %rax
  je endwhile_13
  movq $0, %rdi
  movq -152(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call px_int
  movq $1, %rdi
  movq -152(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call px_int
  movq -160(%rbp), %rax
  movq $3, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setl %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_14
  movq $2, %rdi
  movq -152(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  movq %rax, -152(%rbp)
  jmp endif_14
else_14:
endif_14:
  movq -160(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  movq %rax, -160(%rbp)
  jmp while_13
endwhile_13:
  movq $8, %rdi
  call malloc@PLT
  movq %rax, -168(%rbp)
  movq $0, %rax
  pushq %rax
  movq $0, %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -168(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -168(%rbp), %rax
  pushq %rax
  movq $10, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call registrar
  movq -168(%rbp), %rax
  pushq %rax
  movq $5, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call registrar
  leaq __str_17(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq $0, %rdi
  movq -168(%rbp), %rax
  movq (%rax, %rdi, 8), %rax
  pushq %rax
  popq %rdi
  call px_int
  movq -64(%rbp), %rax
  movq $30, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setge %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_15
  movq $1, %rax
  movq %rax, -176(%rbp)
  jmp endif_15
else_15:
  movq -64(%rbp), %rax
  movq $10, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  setge %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_16
  movq $2, %rax
  movq %rax, -176(%rbp)
  jmp endif_16
else_16:
  movq $3, %rax
  movq %rax, -176(%rbp)
endif_16:
endif_15:
  movq -176(%rbp), %rax
  movq %rax, %r10
  movq $1, %rax
  cmpq %rax, %r10
  je case_17_1
  movq $2, %rax
  cmpq %rax, %r10
  je case_17_2
  jmp default_17
case_17_1:
  leaq __str_18(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_17
  jmp endswitch_17
case_17_2:
  leaq __str_19(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endswitch_17
  jmp endswitch_17
default_17:
  leaq __str_20(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
endswitch_17:
  movq -40(%rbp), %rax
  movq %rax, -184(%rbp)
  movq $0, %rax
  movq %rax, -192(%rbp)
dowhile_18:
  movq -184(%rbp), %rax
  movq $3, %rcx
  cqto
  idivq %rcx
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
  jne dowhile_18
endwhile_18:
  leaq __str_21(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  movq -192(%rbp), %rax
  pushq %rax
  popq %rdi
  call px_int
  movq -40(%rbp), %rax
  movq $5050, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  pushq %rax
  subq $8, %rsp
  movq -64(%rbp), %rax
  movq $34, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  andq %rcx, %rax
  cmpq $0, %rax
  je else_19
  leaq __str_22(%rip), %rax
  movq %rax, %rsi
  leaq print_str_fmt(%rip), %rdi
  movq $0, %rax
  call printf@PLT
  jmp endif_19
else_19:
endif_19:
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
  je else_20
  movq $1, %rax
  jmp .end_factorial
  jmp endif_20
else_20:
endif_20:
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

.globl potencia
potencia:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -16(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_21
  movq $1, %rax
  jmp .end_potencia
  jmp endif_21
else_21:
endif_21:
  movq -8(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call potencia
  movq %rax, %rcx
  movq -8(%rbp), %rax
  imulq %rcx, %rax
  jmp .end_potencia
.end_potencia:
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

.globl registrar
registrar:
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
  jmp .end_registrar
.end_registrar:
  leave
  ret

.globl gcd
gcd:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -16(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_23
  movq -8(%rbp), %rax
  jmp .end_gcd
  jmp endif_23
else_23:
endif_23:
  movq -16(%rbp), %rax
  pushq %rax
  movq -8(%rbp), %rax
  movq -16(%rbp), %rcx
  cqto
  idivq %rcx
  movq -16(%rbp), %rcx
  imulq %rcx, %rax
  movq %rax, %rcx
  movq -8(%rbp), %rax
  subq %rcx, %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call gcd
  jmp .end_gcd
.end_gcd:
  leave
  ret

.globl hanoi
hanoi:
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
  je else_24
  movq $0, %rax
  jmp .end_hanoi
  jmp endif_24
else_24:
endif_24:
  movq -8(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  pushq %rax
  popq %rdi
  call hanoi
  movq %rax, %rcx
  movq $2, %rax
  imulq %rcx, %rax
  movq $1, %rcx
  addq %rcx, %rax
  jmp .end_hanoi
.end_hanoi:
  leave
  ret

.globl sumaDigitos
sumaDigitos:
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
  je else_25
  movq $0, %rax
  jmp .end_sumaDigitos
  jmp endif_25
else_25:
endif_25:
  movq -8(%rbp), %rax
  movq $10, %rcx
  cqto
  idivq %rcx
  movq $10, %rcx
  imulq %rcx, %rax
  movq %rax, %rcx
  movq -8(%rbp), %rax
  subq %rcx, %rax
  pushq %rax
  subq $8, %rsp
  movq -8(%rbp), %rax
  movq $10, %rcx
  cqto
  idivq %rcx
  pushq %rax
  popq %rdi
  call sumaDigitos
  addq $8, %rsp
  movq %rax, %rcx
  popq %rax
  addq %rcx, %rax
  jmp .end_sumaDigitos
.end_sumaDigitos:
  leave
  ret

.globl sumaHasta
sumaHasta:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq -8(%rbp), %rax
  movq $0, %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_26
  movq $0, %rax
  jmp .end_sumaHasta
  jmp endif_26
else_26:
endif_26:
  movq -16(%rbp), %rax
  movq (%rax), %rax
  movq -8(%rbp), %rcx
  addq %rcx, %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rcx
  popq %rax
  movq %rax, (%rcx)
  movq -8(%rbp), %rax
  movq $1, %rcx
  subq %rcx, %rax
  pushq %rax
  movq -16(%rbp), %rax
  pushq %rax
  popq %rsi
  popq %rdi
  call sumaHasta
  movq $0, %rax
  jmp .end_sumaHasta
.end_sumaHasta:
  leave
  ret

.globl llenarFib
llenarFib:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  movq %rdx, -24(%rbp)
  movq -16(%rbp), %rax
  movq -24(%rbp), %rcx
  cmpq %rcx, %rax
  movq $0, %rax
  sete %al
  movzbq %al, %rax
  cmpq $0, %rax
  je else_27
  movq $0, %rax
  jmp .end_llenarFib
  jmp endif_27
else_27:
endif_27:
  movq -16(%rbp), %rax
  pushq %rax
  popq %rdi
  call fib
  pushq %rax
  movq -16(%rbp), %rax
  movq %rax, %rdi
  popq %rax
  movq %rax, %rcx
  movq -8(%rbp), %rax
  movq %rcx, (%rax, %rdi, 8)
  movq -8(%rbp), %rax
  pushq %rax
  movq -16(%rbp), %rax
  movq $1, %rcx
  addq %rcx, %rax
  pushq %rax
  movq -24(%rbp), %rax
  pushq %rax
  popq %rdx
  popq %rsi
  popq %rdi
  call llenarFib
  movq $0, %rax
  jmp .end_llenarFib
.end_llenarFib:
  leave
  ret

.globl grande_int
grande_int:
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
  je else_28
  movq -8(%rbp), %rax
  jmp .end_grande_int
  jmp endif_28
else_28:
endif_28:
  movq -16(%rbp), %rax
  jmp .end_grande_int
.end_grande_int:
  leave
  ret

.globl px_int
px_int:
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
  jmp .end_px_int
.end_px_int:
  leave
  ret

.section .note.GNU-stack,"",@progbits
