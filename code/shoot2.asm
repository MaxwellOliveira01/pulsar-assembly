.text
SetupShoot2:

# Se tiver algum tiro2 no mapa, entao nao processa este outro
	la t0, shoot2Alive
	lh t0, 0(t0)
	li t1, 1
	beq t0, t1, SetupShoot2Ret
	
	# Checa se o inimigo 2 está vivo
	la t0, enemy2Alive
	lb t0, 0(t0)
	beq t0, zero, SetupShoot2Ret
	
	# Decide se será disparado
	li a7, 42
	li a0, 0
	li a1, 1000000
	ecall
	li t0, 10000
	
	bge a0, t0, SetupShoot2Ret


# Marca o tiro2 como ativo no jogo
	la t0, shoot2Alive
	li t1, 1
	sh t1, 0(t0)

# Toca o som de disparo
	li a7, 31
	li a0, 108
	li a1, 1000
	li a2, 118
	li a3, 100
	ecall

# Marca a posiï¿½ï¿½o inicial do tiro2 como a do enemy2
	la t0, shoot2Pos
	la t1, enemy2Pos
	lh t2, 0(t1)
	sh t2, 0(t0)
	lh t2, 2(t1)
	sh t2, 2(t0)

# Dependendo da direÃ§Ã£o do personagem, seta o incremento do tiro2
	la t0, enemy2Dir
	lh t0, 0(t0)
	
# Testa se estï¿½ para direita
	li t1, 0
	li t2, 16
	li t3, 0
	beq t0, t1, SetupShoot2Continue
	
# Testa se estï¿½ para cima
	li t1, 1
	li t2, 0
	li t3, -16								
	beq t0, t1, SetupShoot2Continue
	
# Testa se estï¿½ para esquerda
	li t1, 2
	li t2, -16
	li t3, 0									
	beq t0, t1, SetupShoot2Continue
	
# Testa se estï¿½ para baixo
	li t2, 0
	li t3, 16

# Armazena o incremento correto de shot
SetupShoot2Continue:
	la t0, incShoot2
	sh t2, 0(t0)
	sh t3, 2(t0)
	
	SetupShoot2Ret: ret

Shoot2Process:
# Checa se precisa processar
	la t0, shoot2Alive
	lb t0, 0(t0)
	#beq t0, zero, HideOldShoot2Pos
	beq t0, zero, Shoot2ProcessRet

# Testa se a posição atual é a mesma do inimigo2
	la t0, shoot2Pos
	la t1, enemy2Pos
	lh t2, 0(t0)
	lh t3, 0(t1)
	bne t2, t3, AlrightShoot2Process
	
	lh t2, 2(t0)
	lh t3, 2(t1)
	bne t2, t3, AlrightShoot2Process
	
	j NotAlrightShoot2Process

AlrightShoot2Process:
# Passa shoot2Pos para oldShoot2Pos
	la t1, oldShoot2Pos
	lh t2, 0(t0)
	sh t2, 0(t1)
	lh t2, 2(t0)
	sh t2, 2(t1)

NotAlrightShoot2Process:
# Adiciona incShoot2 ï¿½ posiï¿½ï¿½o
	la t0, shoot2Pos
	la t1, incShoot2
	
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

	la t0, shoot2Pos
	lh t1, 0(t0) # x do tiro
	lh t2, 2(t0) # y do tiro

	la t0, charPos
	lh t3, 0(t0) # x do char
	lh t4, 2(t0) # y do char
	
	#if t1 != t3 || t2 != t4 -> char fica vivo
	
	bne t1, t3, CharStillAlive
	bne t2, t4, CharStillAlive
	
	DebugString("O tiro acertou o personagem")
	
	la t0, decHearts
	li t1, 1
	sb t1, 0(t0)
	
	j Shoot2ProcessRet
	
CharStillAlive:	

#Aqui vamos checar se acertou o portão

	la t0, shoot2Pos
	lh t1, 0(t0) # x do tiro
	lh t2, 2(t0) # y do tiro

	la t0, coordsGate
	lh t3, 0(t0) # x do inimigo
	lh t4, 2(t0) # y do inimigo
	
	bne t1, t3, DidNotHitGate2
	bne t2, t4, DidNotHitGate2
	
	# Mata o tiro
	la t0, shoot2Alive
	li t1, 0
	sb t1, 0(t0)
	
	j Shoot2ProcessRet
	

DidNotHitGate2:

# Checa se acertou um obstï¿½culo
	# Carrega shootPos em t0
	la t0, shoot2Pos
	
	# Carrega a cor da posiï¿½ï¿½o do tiro + 1 em t0
	li t1, 0xFF000000			#Endereï¿½o base
       	lh t2, 0(t0)				#Carrega o x atual
       	add t1, t1, t2				#t1 = endereï¿½o base + x
       	lh t2, 2(t0)				#carrega o y
       	li t3, 320				#largura da tela
       	mul t2, t2, t3				#320y
       	add t1, t1, t2				#endereï¿½o base + x + incx + 320 * (y + incy)
       	addi t1, t1, 1
       	lb t0, 0(t1)				# Carrega a cor
	
	# Carrega a cor do fundo
	la t1, corFundo
	lb t1, 0(t1)
	
	# Compara para ver se acertou um obstï¿½culo
	beq t0, t1, Shoot2ProcessRet
	
	# Mata o tiro2
	la t0, shoot2Alive
	li t1, 0
	sb t1, 0(t0)
	
Shoot2ProcessRet:
	ret

DrawShoot2:
	# Verifica se precisa desenhar o tiro2
	la t0, shoot2Alive
	lb t0, 0(t0)
	beq t0, zero, DrawShoot2Ret
	
	# Desenha o tiro
	la t0, shoot2Pos
	la a0, shot
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0xFF200604
	lw a3, 0(a3)
	
	PRINT()
	
	xori a3, a3, 1
	
	PRINT()

DrawShoot2Ret:
	ret

HideOldShoot2Pos:
	# Seta o oldshoot2pos para o canto da tela para nao deixar nada piscando
	la t0, oldShoot2Pos
	li t1, 304
	sh t1, 0(t0)
	li t1, 226
	sh t1, 2(t0)
	
	ret
