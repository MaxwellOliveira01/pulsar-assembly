DecreaseHearts:
# Verifica a flag para diminuir
	la t0, decHearts
	lh t1, 0(t0)
	beq t1, zero, DecreaseHeartsRet	
	
# Seta a flag para zero
	sh zero, 0(t0)

# Seta a flag de redesenhar para 1
	la t0, shouldBeRedrawn
	li t1, 1
	sb t1, 0(t0)

# Diminue a quantidade de vidas em um
	la t0, heartsCur
	lh t1, 0(t0)
	addi t1, t1, -1
	sh t1, 0(t0)
	
# Se a quantidade de vidas for zero, vai para gameover!!!
	beq t1, zero, GameOver

	DecreaseHeartsRet: ret
	
UpdateVisualHearts:

# Numero a ser printado
	la a0, heartsCur
	lh a0, 0(a0)
	
# Coluna e linha
	li a1, 72
	li a2, 220
# Cor do texto
	li a3, 0x0FF
# Frame
	li a4, 0xFF200604
	lh a4, 0(a4)
	xori a4, a4, 1
# Ecall
	li a7, 101
	
	ecall
	
	ret
