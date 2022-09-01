.data
.text
main:
ori $1, $0, 0x1234
sw $1, 0x0($0)

ori $2, $0, 0x1234
ori $1, $0, 0x0

lw $1, 0x0($0)

beq $1, $2, Label
nop

ori $1, $0, 0x4567
nop

Label:
ori $1, $0, 0x89ab
nop

_loop:
j _loop
nop



exit:
li $v0,10
syscall