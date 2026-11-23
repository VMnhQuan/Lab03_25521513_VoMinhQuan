# CE119 Lab03 - TN2, Buoc 2.3: main goi TRUC TIEP reverse_words voi S(d), d = 3
# (cac thu tuc strlen, rev_range, reverse_words giong het file TN2)
.data
sd:   .asciiz "thanh ghi s phai duoc bao toan"
bar:  .asciiz "|"
.text
.globl main
main:
    la   $a0, sd
    jal  reverse_words
    li   $v0, 4
    la   $a0, bar
    syscall
    la   $a0, sd
    syscall
    la   $a0, bar
    syscall
    li   $v0, 10
    syscall
# ------------------------------------------------------------------
# strlen: dem so ky tu truoc byte 0 (thu tuc la, khong dung ngan xep)
# Tham so  : $a0 = dia chi chuoi .asciiz
# Tra ve   : $v0 = do dai chuoi
# Thanh ghi: $t0, $t1, $v0
strlen:
    move $t0, $a0               # t0 = con tro duyet
sl_loop:
    lbu  $t1, 0($t0)
    beq  $t1, $zero, sl_done
    addiu $t0, $t0, 1
    j    sl_loop
sl_done:
    subu $v0, $t0, $a0          # v0 = dia chi byte 0 - dia chi dau
    jr   $ra

# ------------------------------------------------------------------
# rev_range: dao tai cho doan [$a0, $a1] (tinh ca hai dau)
# (thu tuc la, khong dung ngan xep, khong tra gia tri)
# Neu $a1 < $a0 (doan rong) thi khong lam gi.
# Tham so  : $a0 = dia chi ky tu dau, $a1 = dia chi ky tu cuoi
# Thanh ghi: $a0, $a1, $t0, $t1, $t2
rev_range:
    sltu $t2, $a0, $a1          # dia chi la so khong dau -> sltu
    beq  $t2, $zero, rr_done    # doan rong / 1 ky tu: khong lam gi
rr_loop:                        # (vong lap kiem tra o cuoi: lenh dau cua
    lbu  $t0, 0($a0)            #  rev_range chi chay 1 lan moi loi goi)
    lbu  $t1, 0($a1)
    sb   $t1, 0($a0)
    sb   $t0, 0($a1)
    addiu $a0, $a0, 1
    addiu $a1, $a1, -1
    sltu $t2, $a0, $a1
    bne  $t2, $zero, rr_loop
rr_done:
    jr   $ra

# ------------------------------------------------------------------
# reverse_words: dao thu tu cac tu cua chuoi tai cho (thu tuc KHONG LA)
#   B1: dao toan bo chuoi; B2: dao lai tung tu.
# Tham so  : $a0 = dia chi chuoi
# Tra ve   : khong
# Thanh ghi: $s0 = con tro duyet, $s1 = dia chi dau tu hien tai,
#            $s2 = dia chi byte 0 (cuoi chuoi), $ra; $t0, $t1 tam
# Khung 16 byte: 12($sp)=$ra, 8($sp)=$s0, 4($sp)=$s1, 0($sp)=$s2
reverse_words:
    addi $sp, $sp, -16          # mo dau
    sw   $ra, 12($sp)
    sw   $s0, 8($sp)
    sw   $s1, 4($sp)
    sw   $s2, 0($sp)

    move $s0, $a0               # s0 = dau chuoi (giu qua jal strlen)
    jal  strlen                 # v0 = len
    beq  $v0, $zero, rw_exit    # chuoi rong: khong lam gi (van qua phan ket thuc)
    addu $s2, $s0, $v0          # s2 = dia chi byte 0
    move $a0, $s0
    addiu $a1, $s2, -1
    jal  rev_range              # B1: dao toan bo chuoi
    move $s1, $s0               # s1 = dau tu dau tien
rw_scan:
    beq  $s0, $s2, rw_word      # het chuoi -> ket thuc tu cuoi
    lbu  $t0, 0($s0)
    li   $t1, 32                # ' '
    beq  $t0, $t1, rw_word
    addiu $s0, $s0, 1
    j    rw_scan
rw_word:
    move $a0, $s1               # B2: dao tu [s1, s0-1]
    addiu $a1, $s0, -1
    jal  rev_range
    beq  $s0, $s2, rw_exit      # tu cuoi cung da xu ly
    addiu $s0, $s0, 1           # bo qua dau cach
    move $s1, $s0               # dau tu tiep theo
    j    rw_scan
rw_exit:
    lw   $s2, 0($sp)            # ket thuc: nap lai dung offset
    lw   $s1, 4($sp)
    lw   $s0, 8($sp)
    lw   $ra, 12($sp)
    addi $sp, $sp, 16
    jr   $ra
