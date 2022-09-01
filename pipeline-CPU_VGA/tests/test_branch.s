    .org 0x0
    .set noat
    .set noreorder
    .set nomacro
    .global _start
_start:
    lui $10, 0x0000
    ori $10, 0x0001     # $10 = 1
    lui $11, 0x0000
    ori $11, 0x0001     # $11 = 1
    
    add $12, $10, $11
    add $13, $11, $12
    add $14, $12, $13

    beq $12, $12, endStart
    add $15, $13, $14


endStart:
    add $16, $13, $14
