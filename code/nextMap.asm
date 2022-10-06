NextMap:
	
	# Pega a posição do personagem
	la t0, charPos
	lh t1, 0(t0) # x
	lh t2, 2(t0) # y
	
	# Pega a posição do portao
	la t0, coordsGate
	lh t3, 0(t0) # x
	lh t4, 2(t0) # y	
	
	# Verifica se sao iguais
	bne t1, t3, nextMapRet
	bne t2, t4, nextMapRet
	
	# São iguais, trocar o mapa
	
	# Verifica em qual fase estamos agora
	la t0, Fase
	lh t0, 0(t0)
	
	li t1, 1
	bne t0, t1, TurnOnWinFlag
	
	# Se a fase atual é 1, carregar a 2.
	
	# Muda para 2 a fase atual
	li t1, 2
	la t0, Fase
	sb t1, 0(t0)
	
	# Reinicia as variaveis e desenha outra vez
	la t0, shouldBeRedrawn
	li t1, 1
	sh t1, 0(t0)
	
	j nextMapRet
	
TurnOnWinFlag:
	
	# Se a fase atual é 2, entao o player ganhou
	# Ativa a flag e retorna
	
	li t1, 1
	la t0, winFlag
	sb t1, 0(t0)
	
	nextMapRet: ret
