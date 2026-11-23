# CE119 Lab03 - TN1: sua loi mat dia chi tro ve bang khung ngan xep
# Sinh vien: Vo Minh Quan - MSSV 25521513
.data
msg: .asciiz "Ket qua: "
.text
.globl main
main:
    li   $a0, 5          # x = 5
    jal  outer           # v0 = outer(5)
    move $s0, $v0
    li   $v0, 4
    la   $a0, msg
    syscall
    move $a0, $s0
    li   $v0, 1
    syscall
    li   $v0, 10
    syscall

# outer: tra ve inner(x) + 1 (thu tuc KHONG LA)
# Tham so  : $a0 = x
# Tra ve   : $v0 = 2x + 1
# Thanh ghi: $ra (cat vao khung 1 word - khung nho nhat du dung), $v0
outer:
    addi $sp, $sp, -4    # mo dau: cap khung 1 word
    sw   $ra, 0($sp)     # cat dia chi tro ve main
    jal  inner           # v0 = inner(x)  (jal ghi de $ra)
    addi $v0, $v0, 1
    lw   $ra, 0($sp)     # ket thuc: nap lai $ra
    addi $sp, $sp, 4     # thu hoi khung
    jr   $ra

# inner: thu tuc la, tra ve 2x
# Tham so  : $a0 = x
# Tra ve   : $v0 = 2x
# Thanh ghi: $v0 (khong goi ai, khong dung $s nen khong can khung)
inner:
    add  $v0, $a0, $a0
    jr   $ra
