.text
SetupShoot4:

# Se tiver algum tiro4 no mapa, entao nao processa este outro
	la t0, shoot4Alive
	lh t0, 0(t0)
	li t1, 1
	beq t0, t1, SetupShoot4Ret
	
	# Checa se o inimigo 2 est� vivo
	la t0, enemy4Alive
	lb t0, 0(t0)
	beq t0, zero, SetupShoot4Ret
	
	# Decide se ser� disparado
	li a7, 42
	li a0, 0
	li a1, 1000000
	ecall
	li t0, 10000
	
	bge a0, t0, SetupShoot4Ret


# Marca o tiro2 como ativo no jogo
	la t0, shoot4Alive
	li t1, 1
	sh t1, 0(t0)

# Toca o som de disparo
	li a7, 31
	li a0, 108
	li a1, 1000
	li a2, 118
	li a3, 100
	ecall

# Marca a posi��o inicial do tiro2 como a do enemy2
	la t0, shoot4Pos
	la t1, enemy4Pos
	lh t2, 0(t1)
	sh t2, 0(t0)
	lh t2, 2(t1)
	sh t2, 2(t0)

# Dependendo da direção do personagem, seta o incremento do tiro2
	la t0, enemy4Dir
	lh t0, 0(t0)
	
# Testa se est� para direita
	li t1, 0
	li t2, 16
	li t3, 0
	beq t0, t1, SetupShoot4Continue
	
# Testa se est� para cima
	li t1, 1
	li t2, 0
	li t3, -16								
	beq t0, t1, SetupShoot4Continue
	
# Testa se est� para esquerda
	li t1, 2
	li t2, -16
	li t3, 0									
	beq t0, t1, SetupShoot4Continue
	
# Testa se est� para baixo
	li t2, 0
	li t3, 16

# Armazena o incremento correto de shot
SetupShoot4Continue:
	la t0, incShoot4
	sh t2, 0(t0)
	sh t3, 2(t0)
	
	SetupShoot4Ret: ret

Shoot4Process:
# Checa se precisa processar
	la t0, shoot4Alive
	lb t0, 0(t0)
	#beq t0, zero, HideOldShoot2Pos
	beq t0, zero, Shoot4ProcessRet

# Testa se a posi��o atual � a mesma do inimigo2
	la t0, shoot4Pos
	la t1, enemy4Pos
	lh t2, 0(t0)
	lh t3, 0(t1)
	bne t2, t3, AlrightShoot4Process
	
	lh t2, 2(t0)
	lh t3, 2(t1)
	bne t2, t3, AlrightShoot4Process
	
	j NotAlrightShoot4Process

AlrightShoot4Process:
# Passa shoot2Pos para oldShoot2Pos
	la t1, oldShoot4Pos
	lh t2, 0(t0)
	sh t2, 0(t1)
	lh t2, 2(t0)
	sh t2, 2(t1)

NotAlrightShoot4Process:
# Adiciona incShoot2 � posi��o
	la t0, shoot4Pos
	la t1, incShoot4
	
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

# Aqui vamos checar se acertou o char

	la t0, shoot4Pos
	lh t1, 0(t0) # x do tiro
	lh t2, 2(t0) # y do tiro

	la t0, charPos
	lh t3, 0(t0) # x do char
	lh t4, 2(t0) # y do char
	
	#if t1 != t3 || t2 != t4 -> char fica vivo
	
	bne t1, t3, CharStillAlive4
	bne t2, t4, CharStillAlive4
	
	DebugString("O tiro acertou o personagem")
	
	la t0, decHearts
	li t1, 1
	sb t1, 0(t0)
	
	j Shoot4ProcessRet
	
CharStillAlive4:	

#Aqui vamos checar se acertou o port�o

	la t0, shoot4Pos
	lh t1, 0(t0) # x do tiro
	lh t2, 2(t0) # y do tiro

	la t0, coordsGate
	lh t3, 0(t0) # x do inimigo
	lh t4, 2(t0) # y do inimigo
	
	bne t1, t3, DidNotHitGate4
	bne t2, t4, DidNotHitGate4
	
	# Mata o tiro
	la t0, shoot4Alive
	li t1, 0
	sb t1, 0(t0)
	
	j Shoot4ProcessRet
	

DidNotHitGate4:

# Checa se acertou um obst�culo
	# Carrega shootPos em t0
	la t0, shoot4Pos
	
	# Carrega a cor da posi��o do tiro + 1 em t0
	li t1, 0xFF000000			#Endere�o base
       	lh t2, 0(t0)				#Carrega o x atual
       	add t1, t1, t2				#t1 = endere�o base + x
       	lh t2, 2(t0)				#carrega o y
       	li t3, 320				#largura da tela
       	mul t2, t2, t3				#320y
       	add t1, t1, t2				#endere�o base + x + incx + 320 * (y + incy)
       	addi t1, t1, 1
       	lb t0, 0(t1)				# Carrega a cor
	
	# Carrega a cor do fundo
	la t1, corFundo
	lb t1, 0(t1)
	
	# Compara para ver se acertou um obst�culo
	beq t0, t1, Shoot4ProcessRet
	
	# Mata o tiro2
	la t0, shoot4Alive
	li t1, 0
	sb t1, 0(t0)
	
Shoot4ProcessRet:
	ret

DrawShoot4:
	# Verifica se precisa desenhar o tiro2
	la t0, shoot4Alive
	lb t0, 0(t0)
	beq t0, zero, DrawShoot4Ret
	
	# Desenha o tiro
	la t0, shoot4Pos
	la a0, shot
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0xFF200604
	lw a3, 0(a3)
	
	PRINT()
	
	xori a3, a3, 1
	
	PRINT()

DrawShoot4Ret:
	ret

HideOldShoot4Pos:
	# Seta o oldshoot2pos para o canto da tela para nao deixar nada piscando
	la t0, oldShoot4Pos
	li t1, 304
	sh t1, 0(t0)
	li t1, 226
	sh t1, 2(t0)
	
	ret