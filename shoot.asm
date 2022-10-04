.text
SetupShoot:

# Se tiver algum tiro no mapa, entao nao processa este outro
	la t0, shootAlive
	lh t0, 0(t0)
	li t1, 1
	beq t0, t1, SetupShotRet

# Marca o tiro como ativo no jogo
	la t0, shootAlive
	li t1, 1
	sh t1, 0(t0)

# Marca a posi��o inicial do tiro como a do personagem
	la t0, shootPos
	la t1, charPos
	lh t2, 0(t1)
	sh t2, 0(t0)
	lh t2, 2(t1)
	sh t2, 2(t0)

# Dependendo da direção do personagem, seta o incremento do tiro
	la t0, charDir
	lh t0, 0(t0)
	
# Testa se est� para direita
	li t1, 0
	li t2, 16
	li t3, 0
	beq t0, t1, SetupShootContinue
	
# Testa se est� para cima
	li t1, 1
	li t2, 0
	li t3, -16								
	beq t0, t1, SetupShootContinue
	
# Testa se est� para esquerda
	li t1, 2
	li t2, -16
	li t3, 0									
	beq t0, t1, SetupShootContinue
	
# Testa se est� para baixo
	li t2, 0
	li t3, 16

# Armazena o incremento correto de shot
SetupShootContinue:
	la t0, incShoot
	sh t2, 0(t0)
	sh t3, 2(t0)
	
	SetupShotRet: ret

ShootProcess:
# Checa se precisa processar
	la t0, shootAlive
	lb t0, 0(t0)
	beq t0, zero, HideOldShootPos

# Passa shootPos para oldShootPos
	la t0, shootPos
	la t1, oldShootPos
	lh t2, 0(t0)
	sh t2, 0(t1)
	lh t2, 2(t0)
	sh t2, 2(t1)

# Adiciona incShoot � posi��o
	la t0, shootPos
	la t1, incShoot
	
	# Muda o x
	lh t2, 0(t0)
	lh t3, 0(t1)
	add t2, t2, t3
	sh t2, 0(t0)
	
	# Muda o y
	lh t2, 2(t0)
	lh t3, 2(t1)
	add t2, t2, t3
	sh t2, 2(t0)

# Aqui vamos checar se acertou um inimigo

	la t0, shootPos
	lh t1, 0(t0) # x do tiro
	lh t2, 2(t0) # y do tiro

	la t0, enemy1Pos
	lh t3, 0(t0) # x do inimigo
	lh t4, 2(t0) # y do inimigo
	
	#if t1 != t3 || t2 != t4 -> enemy1 fica vivo
	
	bne t1, t3, Enemy1StillAlive
	bne t2, t4, Enemy1StillAlive
	
	DebugString("O tiro acertou o inimigo1")
	
	la t0, enemy1Alive
	sh zero, 0(t0)
	
	# Setar o old dele lá para o canto pro char nao piscar
	la t0, oldEnemy1Pos
	li t1, 304
	sh t1, 0(t0)
	li t1, 226
	sh t1, 2(t0)
	
	# Usa a macro pra cobrir o inimigo com tile
	
	la a0, tile
	la t0, enemy1Pos
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0
	
	PRINT()
	
	li a3, 1
	
	PRINT()
	
Enemy1StillAlive:	

# Checa se acertou um obst�culo
	# Carrega shootPos em t0
	la t0, shootPos
	
	# Carrega a cor da posi��o do tiro em t0
	li t1, 0xFF000000			#Endere�o base
       	lh t2, 0(t0)				#Carrega o x atual
       	add t1, t1, t2				#t1 = endere�o base + x
       	lh t2, 2(t0)				#carrega o y
       	li t3, 320				#largura da tela
       	mul t2, t2, t3				#320y
       	add t1, t1, t2				#endere�o base + x + incx + 320 * (y + incy)
       	lb t0, 0(t1)				# Carrega a cor
	
	# Carrega a cor do fundo
	la t1, corFundo
	lb t1, 0(t1)
	
	# Compara para ver se acertou um obst�culo
	beq t0, t1, ShootProcessRet
	
	# Mata 0 tiro
	la t0, shootAlive
	li t1, 0
	sb t1, 0(t0)
	
	j ShootProcessRet
	
HideOldShootPos:
	# Seta o oldshootpos para o canto da tela para nao deixar o char piscando
	la t0, oldShootPos
	li t1, 304
	sh t1, 0(t0)
	li t1, 226
	sh t1, 2(t0)

ShootProcessRet:
	ret

DrawShoot:
	# Verifica se precisa desenhar o tiro
	la t0, shootAlive
	lb t0, 0(t0)
	beq t0, zero, DrawShootRet
	
	# Desenha o tiro
	la t0, shootPos
	la a0, shot
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0xFF200604
	lw a3, 0(a3)
	
	PRINT()
	
	xori a3, a3, 1
	
	PRINT()

DrawShootRet:
	ret
