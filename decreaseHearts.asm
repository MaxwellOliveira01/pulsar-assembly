DecreaseHearts:
# Verifica a flag para diminuir
	la t0, decHearts
	lh t1, 0(t0)
	beq t1, zero, DecreaseHeartsRet	
	
# Seta a flag para zero
	sh zero, 0(t0)
	
# Diminue a quantidade de vidas em um
	la t0, heartsCur
	lh t1, 0(t0)
	addi t1, t1, -1
	sh t1, 0(t0)
	
	#DebugInt("Diminuindo vida, restam = ", heartsCur)
	
# Se a quantidade de vidas for zero, vai para gameover!!!
	beq t1, zero, GameOver
	
# Reseta a quantidade de combustivel do personagem
	la t0, fuel
	lh t0, 0(t0)
	la t1, fuelCur
	sh t0, 0(t1)

	DecreaseHeartsRet: ret