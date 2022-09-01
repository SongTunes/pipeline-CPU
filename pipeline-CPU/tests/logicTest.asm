.data
.text
main:
lui $1, 0x0101
ori $1, $1, 0x0101
ori $2, $1, 0x1100
or $1, $1, $2
andi $3, $1, 0x00fe
and $1, $3, $1
xori $4, $1, 0xff00
nor $1, $4, $1


exit:
li $v0,10
syscall
