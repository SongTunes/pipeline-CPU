# initial
addi $17, $0, 0x00000007
addi $2, $0, 0x00000002
addi $3, $0, 0x00000006
addi $4, $0, 0x00000004
addi $5, $0, 0x00000005
addi $6, $0, 0x00000008
addi $7, $0, 0x00000003
addi $8, $0, 0x00000001
addi $9, $0, 0x00000000
addi $12, $0, 0x00000009 #$10存储空位位置
addi $15, $0, 0x00000000 #胜利标志

lui $14, 0x00001234
ori $14, $14, 0x00005678

VGAOUTPUT:
	addi $16, $17, 0x00010000
	sw $16, 0xbfaf9028($0)
	addi $16, $2, 0x00020000
	sw $16, 0xbfaf9004($0)
	addi $16, $3, 0x00030000
	sw $16, 0xbfaf9008($0)
	addi $16, $4, 0x00040000
	sw $16, 0xbfaf900c($0)
	addi $16, $5, 0x00050000
	sw $16, 0xbfaf9010($0)
	addi $16, $6, 0x00060000
	sw $16, 0xbfaf9014($0)
	addi $16, $7, 0x00070000
	sw $16, 0xbfaf9018($0)
	addi $16, $8, 0x00080000
	sw $16, 0xbfaf901c($0)
	addi $16, $9, 0x00090000
	sw $16, 0xbfaf9020($0)
	addi $16, $15, 0x000a0000
	sw $16, 0xbfaf9024($0)	

# 游戏开始 ，循环
GAMELOOP:
	
	# 移动
	addi $11, $0, 0x00000001
	lw $10, 0xbfaf8010($0) # LEFT按键地址
	beq $10, $11, LEFT
	lw $18, 0xbfaf8014($0)
	beq $18, $11, RIGHT
	lw $19, 0xbfaf8018($0)
	beq $19, $11, UP
	lw $20, 0xbfaf801c($0)
	beq $20, $11, DOWN
	J GAMELOOP
	
	RIGHT:
	# sw $0, 0xbfaf8014($0)
	addi $13, $0, 0x00000002
	beq $12, $13, CHANGERIGHT2
	addi $13, $0, 0x00000003
	beq $12, $13, CHANGERIGHT3
	addi $13, $0, 0x00000005
	beq $12, $13, CHANGERIGHT5
	addi $13, $0, 0x00000006
	beq $12, $13, CHANGERIGHT6
	addi $13, $0, 0x00000008
	beq $12, $13, CHANGERIGHT8
	addi $13, $0, 0x00000009
	beq $12, $13, CHANGERIGHT9
	J RESTARTLOOP
		CHANGERIGHT2:
			add $2, $0, $17
			addi $17, $0, 0x00000000
			addi $12, $0, 0x00000001
			J JUDGE
		CHANGERIGHT3:
			add $3, $0, $2
			addi $2, $0, 0x00000000
			addi $12, $0, 0x00000002
			J JUDGE
		CHANGERIGHT5:
			add $5, $0, $4
			addi $4, $0, 0x00000000
			addi $12, $0, 0x00000004
			J JUDGE
		CHANGERIGHT6:
			add $6, $0, $5
			addi $5, $0, 0x00000000
			addi $12, $0, 0x00000005
			J JUDGE
		CHANGERIGHT8:
			add $8, $0, $7
			addi $7, $0, 0x00000000
			addi $12, $0, 0x00000007
			J JUDGE
		CHANGERIGHT9:
			add $9, $0, $8
			addi $8, $0, 0x00000000
			addi $12, $0, 0x00000008
			J JUDGE
			
	LEFT:
	# sw $0, 0xbfaf8010($0)
	addi $13, $0, 0x00000001
	beq $12, $13, CHANGELEFT1
	addi $13, $0, 0x00000002
	beq $12, $13, CHANGELEFT2
	addi $13, $0, 0x00000004
	beq $12, $13, CHANGELEFT4
	addi $13, $0, 0x00000005
	beq $12, $13, CHANGELEFT5
	addi $13, $0, 0x00000007
	beq $12, $13, CHANGELEFT7
	addi $13, $0, 0x00000008
	beq $12, $13, CHANGELEFT8
	J RESTARTLOOP
	
		CHANGELEFT1:
			add $17, $0, $2
			addi $2, $0, 0x00000000
			addi $12, $0, 0x00000002
			J JUDGE
		CHANGELEFT2:
			add $2, $0, $3
			addi $3, $0, 0x00000000
			addi $12, $0, 0x00000003
			J JUDGE
		CHANGELEFT4:
			add $4, $0, $5
			addi $5, $0, 0x00000000
			addi $12, $0, 0x00000005
			J JUDGE
		CHANGELEFT5:
			add $5, $0, $6
			addi $6, $0, 0x00000000
			addi $12, $0, 0x00000006
			J JUDGE
		CHANGELEFT7:
			add $7, $0, $8
			addi $8, $0, 0x00000000
			addi $12, $0, 0x00000008
			J JUDGE
		CHANGELEFT8:
			add $8, $0, $9
			addi $9, $0, 0x00000000
			addi $12, $0, 0x00000009
			J JUDGE
	UP:
	# sw $0, 0xbfaf8018($0)
	addi $13, $0, 0x00000001
	beq $12, $13, CHANGEUP1
	addi $13, $0, 0x00000002
	beq $12, $13, CHANGEUP2
	addi $13, $0, 0x00000003
	beq $12, $13, CHANGEUP3
	addi $13, $0, 0x00000004
	beq $12, $13, CHANGEUP4
	addi $13, $0, 0x00000005
	beq $12, $13, CHANGEUP5
	addi $13, $0, 0x00000006
	beq $12, $13, CHANGEUP6
	J RESTARTLOOP
	
		CHANGEUP1:
			add $17, $0, $4
			addi $4, $0, 0x00000000
			addi $12, $0, 0x00000004
			J JUDGE
		CHANGEUP2:
			add $2, $0, $5
			addi $5, $0, 0x00000000
			addi $12, $0, 0x00000005
			J JUDGE
		CHANGEUP3:
			add $3, $0, $6
			addi $6, $0, 0x00000000
			addi $12, $0, 0x0000006
			J JUDGE
		CHANGEUP4:
			add $4, $0, $7
			addi $7, $0, 0x00000000
			addi $12, $0, 0x00000007
			J JUDGE
		CHANGEUP5:
			add $5, $0, $8
			addi $8, $0, 0x00000000
			addi $12, $0, 0x00000008
			J JUDGE
		CHANGEUP6:
			add $6, $0, $9
			addi $9, $0, 0x00000000
			addi $12, $0, 0x00000009
			J JUDGE
	DOWN:
	# sw $0, 0xbfaf801c($0)
	addi $13, $0, 0x00000004
	beq $12, $13, CHANGEDOWN4
	addi $13, $0, 0x00000005
	beq $12, $13, CHANGEDOWN5
	addi $13, $0, 0x00000006
	beq $12, $13, CHANGEDOWN6
	addi $13, $0, 0x00000007
	beq $12, $13, CHANGEDOWN7
	addi $13, $0, 0x00000008
	beq $12, $13, CHANGEDOWN8
	addi $13, $0, 0x00000009
	beq $12, $13, CHANGEDOWN9
	J RESTARTLOOP
	
		CHANGEDOWN4:
			add $4, $0, $17
			addi $17, $0, 0x00000000
			addi $12, $0, 0x00000001
			J JUDGE
		CHANGEDOWN5:
			add $5, $0, $2
			addi $2, $0, 0x00000000
			addi $12, $0, 0x00000002
			J JUDGE
		CHANGEDOWN6:
			add $6, $0, $3
			addi $3, $0, 0x00000000
			addi $12, $0, 0x0000003
			J JUDGE
		CHANGEDOWN7:
			add $7, $0, $4
			addi $4, $0, 0x00000000
			addi $12, $0, 0x00000004
			J JUDGE
		CHANGEDOWN8:
			add $8, $0, $5
			addi $5, $0, 0x00000000
			addi $12, $0, 0x00000005
			J JUDGE
		CHANGEDOWN9:
			add $9, $0, $6
			addi $6, $0, 0x00000000
			addi $12, $0, 0x00000006
			J JUDGE
			
JUDGE:
	add $13, $0, $17
	sll $13, $13, 0x00000004
	add $13, $13, $2
	sll $13, $13, 0x00000004
	add $13, $13, $3
	sll $13, $13, 0x00000004
	add $13, $13, $4
	sll $13, $13, 0x00000004
	add $13, $13, $5
	sll $13, $13, 0x00000004
	add $13, $13, $6
	sll $13, $13, 0x00000004
	add $13, $13, $7
	sll $13, $13, 0x00000004
	add $13, $13, $8

	# 判断
	beq $13, $14, GAMEEND
	#显示
	addi $16, $17, 0x00010000
	sw $16, 0xbfaf9028($0)
	addi $16, $2, 0x00020000
	sw $16, 0xbfaf9004($0)
	addi $16, $3, 0x00030000
	sw $16, 0xbfaf9008($0)
	addi $16, $4, 0x00040000
	sw $16, 0xbfaf900c($0)
	addi $16, $5, 0x00050000
	sw $16, 0xbfaf9010($0)
	addi $16, $6, 0x00060000
	sw $16, 0xbfaf9014($0)
	addi $16, $7, 0x00070000
	sw $16, 0xbfaf9018($0)
	addi $16, $8, 0x00080000
	sw $16, 0xbfaf901c($0)
	addi $16, $9, 0x00090000
	sw $16, 0xbfaf9020($0)
	addi $16, $15, 0x000a0000
	sw $16, 0xbfaf9024($0)	
	
	RESTARTLOOP:
		addi $11, $0, 0x00000001
		beq $10, $11, LEFTRESTART
		beq $18, $11, RIGHTRESTART
		beq $19, $11, UPRESTART
		beq $20, $11, DOWNRESTART
		J GAMELOOP
		LEFTRESTART:
			lw $10, 0xbfaf8010($0) 
			beq $10, $11, LEFTRESTART
			nop
			nop
			nop
			J GAMELOOP
		RIGHTRESTART:			
			lw $18, 0xbfaf8014($0) 
			beq $18, $11, RIGHTRESTART
			nop
			nop
			nop
			J GAMELOOP
		UPRESTART:
			lw $19, 0xbfaf8018($0) 
			beq $19, $11, UPRESTART
			nop
			nop
			nop
			J GAMELOOP
		DOWNRESTART:
			lw $20, 0xbfaf801c($0) 
			beq $20, $11, DOWNRESTART
			nop
			nop
			nop
			J GAMELOOP
	
	

GAMEEND:
	addi $15, $0, 0x00000001
	# 显示
	addi $16, $17, 0x00010000
	sw $16, 0xbfaf9028($0)
	addi $16, $2, 0x00020000
	sw $16, 0xbfaf9004($0)
	addi $16, $3, 0x00030000
	sw $16, 0xbfaf9008($0)
	addi $16, $4, 0x00040000
	sw $16, 0xbfaf900c($0)
	addi $16, $5, 0x00050000
	sw $16, 0xbfaf9010($0)
	addi $16, $6, 0x00060000
	sw $16, 0xbfaf9014($0)
	addi $16, $7, 0x00070000
	sw $16, 0xbfaf9018($0)
	addi $16, $8, 0x00080000
	sw $16, 0xbfaf901c($0)
	addi $16, $9, 0x00090000
	sw $16, 0xbfaf9020($0)
	addi $16, $15, 0x000a0000
	sw $16, 0xbfaf9024($0)
	J GAMEEND
	
    	
	
