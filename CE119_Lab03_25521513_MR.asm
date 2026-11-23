# CE119 Lab03 - Mo rong: fib_opt kiem tra truong hop co so TRUOC khi cap khung
# Sinh vien: Vo Minh Quan - MSSV 25521513  (d = 3, n(d) = 14)
# Doi "jal fib_opt" thanh "jal fib_rec" / "jal fib_iter" de so sanh.
.data
n:     .word 20
s_f:   .asciiz "F("
s_eq:  .asciiz ") = "
.text
.globl main
main:
    lw   $s0, n                 # s0 = n (giu qua loi goi)
    move $a0, $s0
    jal  fib_opt                # v0 = F(n)
    move $s1, $v0
    li   $v0, 4
    la   $a0, s_f
    syscall                     # "F("
    li   $v0, 1
    move $a0, $s0
    syscall                     # n
    li   $v0, 4
    la   $a0, s_eq
    syscall                     # ") = "
    li   $v0, 1
    move $a0, $s1
    syscall                     # F(n)
    li   $v0, 10
    syscall

# ------------------------------------------------------------------
# fib_opt: nhu fib_rec nhung xu ly truong hop co so (n < 2) TRUOC khi cap khung.
#   Loi goi co so tro thanh "la": khong cham vao ngan xep, chi 4 lenh.
# Tham so  : $a0 = n (n >= 0)
# Tra ve   : $v0 = F(n)
# Thanh ghi: $s0 = n, $s1 = F(n-1) (cat vao khung khi de quy), $ra, $t0
# Khung 12 byte (chi khi n >= 2): 8($sp)=$ra, 4($sp)=$s0, 0($sp)=$s1
fib_opt:
    slti $t0, $a0, 2
    beq  $t0, $zero, fo_rec
    move $v0, $a0               # co so: F(n) = n, khong can khung
    jr   $ra
fo_rec:
    addi $sp, $sp, -12          # mo dau
    sw   $ra, 8($sp)
    sw   $s0, 4($sp)
    sw   $s1, 0($sp)
    move $s0, $a0
    addi $a0, $s0, -1
    jal  fib_opt                # v0 = F(n-1)
    move $s1, $v0
    addi $a0, $s0, -2
    jal  fib_opt                # v0 = F(n-2)
    addu $v0, $s1, $v0
    lw   $s1, 0($sp)            # ket thuc
    lw   $s0, 4($sp)
    lw   $ra, 8($sp)
    addi $sp, $sp, 12
    jr   $ra

# ------------------------------------------------------------------
# fib_rec: tinh F(n) de quy theo dinh nghia (thu tuc KHONG LA, de quy)
# Tham so  : $a0 = n (n >= 0)
# Tra ve   : $v0 = F(n)
# Thanh ghi: $s0 = n, $s1 = F(n-1) (deu duoc cat vao khung), $ra, $t0
# Khung 12 byte: 8($sp)=$ra, 4($sp)=$s0, 0($sp)=$s1
fib_rec:
    addi $sp, $sp, -12          # mo dau
    sw   $ra, 8($sp)
    sw   $s0, 4($sp)
    sw   $s1, 0($sp)
    move $s0, $a0               # s0 = n
    slti $t0, $s0, 2
    beq  $t0, $zero, fr_rec
fr_base:                        # truong hop co so: n < 2 -> F(n) = n
    move $v0, $s0
    j    fr_exit                # van di qua phan ket thuc
fr_rec:
    addi $a0, $s0, -1
    jal  fib_rec                # v0 = F(n-1)
    move $s1, $v0
    addi $a0, $s0, -2
    jal  fib_rec                # v0 = F(n-2)
    addu $v0, $s1, $v0          # F(n) = F(n-1) + F(n-2)
fr_exit:
    lw   $s1, 0($sp)            # ket thuc
    lw   $s0, 4($sp)
    lw   $ra, 8($sp)
    addi $sp, $sp, 12
    jr   $ra

# ------------------------------------------------------------------
# fib_iter: tinh F(n) bang vong lap (cap san)
# Tham so : $a0 = n   Tra ve : $v0 = F(n)
# Thanh ghi: $t0-$t3 (thu tuc la)
fib_iter:
    move $v0, $zero             # a = F(0)
    li   $t0, 1                 # b = F(1)
    move $t1, $zero             # i = 0
fi_loop:
    slt  $t2, $t1, $a0
    beq  $t2, $zero, fi_done
    addu $t3, $v0, $t0          # a + b
    move $v0, $t0
    move $t0, $t3
    addiu $t1, $t1, 1
    j    fi_loop
fi_done:
    jr   $ra
