 .org 0x0
    .set noat
    .set noreorder
    .set nomacro
    .global _start
_start:

#add\addu\addi\addiu\sub\subu
	addi $1,$0,1	#$1=1
	addi $2,$0,10	#$2=10
    	add $3,$1,$2	#$3=b
    	addu $4,$1,$2   #$4=b
    	addi $1,$0,8    #$1=8
    	addiu $2,$0,1   #$2=1
    	sub $4,$1,$2    #$4=7
    	subu $5,$1,$0   #$5=8
    
#and\nor\or\xor\xori\lu\ori
	addi  $4,$4,100
   	and   $6,$4,$5    #6=8
    	or    $7,$4,$5    #7=6b
   	xor   $8,$4,$5    #8=63
    	nor   $9,$4,$5    #9=0ffff94
    	lui $1,0xbcaa
   	ori $1,$1,0xbd27
    	xori $2,$2,0xbd27

#SLL SRL SRLV SRAV
    	sll  $8,$5,2
    	srl  $6,$2,2
    	srlv $1,$2,$3
    	srav $1,$2,$3
#slt slti sltu sltiu clz clo
     	lui $1,0x1234
	slt $6,$1,$2 
#beq bne j
	addiu $1,$0,8
	addiu $2,$0,1
    	beq $1,$2,next
   	j hello
#slt slti sltu sltiu clz clo
     	lui $1,0x1234
	slt $6,$1,$2
	slti $6,$1,8

hello:
     	lui $1,0xbcaa
     	ori $1,$1,0xbd27
     	lui $2,0xbcaa
     	ori $2,$2,0xbd27
     	bne $1,$2,error
     	
     	lui $1,0xbcaa
     	ori $1,$1,0xbd27
     	lui $2,0x82a7
     	ori $2,$2,0x7a9d
     	bne $1,$2,error
     	
#slt slti sltu sltiu clz clo
     	lui $1,0x1234
	slt $6,$1,$2 
next:
	add $3,$1,$5
	sub $4,$2,$1
error:
        sw $2 0x00002000($8)
	lw $4 0x00002000($8)
	
#slt slti sltu sltiu clz clo
     	lui $1,0x1234
	slt $6,$3,$4 
	slti $7,$3,8
	sltu $8,$3,$4
	sltiu $9,$4,10
	clz $1,$2
	clo $1,$2
