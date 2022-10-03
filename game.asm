.include "macros.asm"
.include "MACROSv21.s"
.data
.include "data.asm"
.text
	DrawImageInBothFrames(map, coordsMap)
	DrawImageInBothFrames(key00,coordsKey0)
	DrawImageInBothFrames(key01,coordsKey1)
	DrawImageInBothFrames(porta,coordsGate)
	DrawImageInBothFrames(charDireita,charPos)
	DrawImageInBothFrames(inimigo1Direita, enemy1Pos)
	DrawImageInBothFrames(inimigo2Direita, enemy2Pos)
	DrawString(fuelStr, 220, 96)
	DrawString(lifeStr, 220, 16)

GameLoop: 
# Recebe do teclado
	call Tec

Sleep()
# Desenha o personagem
	call DrawChar

# Apaga o rastro do personagem
	DrawImageInBothFrames(tile, oldCharPos)

Sleep()
# Verifica se pode abrir o portao
	call OpenGate

Sleep()	
# Verifica a flag de combustivel
	call DecreaseFuel

Sleep()
# Verifica a flag de vida
	call DecreaseHearts

Sleep()
# Recarrega o contador de combustivel na tela
	call UpdateVisualFuel 
	
Sleep()
# Recarrega o contador de vida na tela
	call UpdateVisualHearts

Sleep()

	la t0, countingCycles
	lb t0, 0(t0)
	bne t0, zero, NoEnemyMoving

# Atualiza a posi��o do inimigo 1
	call UpdateEnemy1

NoEnemyMoving:
Sleep()
# Desenha o inimigo 1
	call DrawEnemy1

# Apaga o rastro do inimigo 1
	DrawImageInBothFrames(tile, oldEnemy1Pos)

	call DamageEnemy1

Sleep()
# Inverte o frame
	li t0, 0xFF200604
	lh s0, 0(t0)
	xori s0, s0, 1
	sw s0, 0(t0)

Sleep()
# Sleep pro inimigo1
	la t0, countingCycles
	lb t0, 0(t0)
	addi t0, t0, 1
	li t1, 8
	rem t0, t0, t1
	la t1, countingCycles
	sb t0, 0(t1)

# Volta pro loop do jogo
	j GameLoop

DamageEnemy1:
	
# Carrega a posição do inimigo1

	la t0, charPos
	lh t1, 0(t0) # x do personagem
	lh t2, 2(t0) # y do personagem
	
	la t0, enemy1Pos
	lh t3, 0(t0) # x do inimigo
	lh t4, 2(t0) # y do inimigo
	
	sub t1, t1, t3 # diferença em x
	sub t2, t2, t4 # diferença em y
	
	li t3, 16
	div t1, t1, t3 # divide a diferença por 16 (tamanho do bloco do jogo)
	div t2, t2, t3
				
	mul t1, t1, t1
	mul t2, t2, t2
	
	add t1, t1, t2	# soma dos quadrados das diferencas
	
	li t2, 1
	
	# Diferença > 1, entao segue a vida
	bgt t1, t2, DamageEnemy1Ret
	
	# Retirar t1 do combustivel
	la t2, fuelCur
	lh t3, 0(t2)
	addi t3, t3, -1
	sh t3, 0(t2)
	
	# Liga a flag do combustivel
	la t0, decFuel
	li t1, 1
	sh t1, 0(t0)
	
	DamageEnemy1Ret: ret

DrawEnemy1:
# Responsavel por desenhar o inimigo1 no frame invertido
#Carrega a dire��o do inimigo em t0
	la t0, enemy1Dir		
	lb t0, 0(t0)
	
#testa se est� para direita
	li t1, 0
	la a0,inimigo1Direita				
	beq t0, t1, DrawEnemy1Continue
#testa se est� para cima
	li t1,1						
	la a0,inimigo1Cima				
	beq t0, t1, DrawEnemy1Continue
#testa se est� para esquerda
	li t1,2						
	la a0,inimigo1Esquerda			
	beq t0, t1, DrawEnemy1Continue
#Testa se est� para baixo
	la a0,inimigo1Baixo
	
DrawEnemy1Continue:
	
	#a0 = endere�o da imagem certa
	la t0, enemy1Pos
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0xFF200604
	lw a3, 0(a3)
	
	PRINT()
	
	xori a3, a3, 1
	
	PRINT()
	
	ret	

UpdateEnemy1:

	li a7, 42
	li a0, 0
	li a1, 15000000
	ecall
	li t0, 10000000
	
	blt a0, t0, OkUpdateDirEnemy1

	la t0, enemy1Dir
	lb t0, 0(t0)
	add a0, t0, zero

OkUpdateDirEnemy1:
	
	li t0, 4
	rem a0, a0, t0

	#a0 � uma dire��o aleat�ria
	
	la t0, enemy1Dir
	lb t0, 0(t0)
	bne t0, a0, NotSameEnemy1Dir

	# Testa se a dire��o � direita
	li t3, 16
	li t4, 0
	li t0, 0
	beq a0, t0, UpdateEnemy1Continue

	# Testa se a dire��o � cima
	li t3, 0
	li t4, -16
	li t0, 1
	beq a0, t0, UpdateEnemy1Continue

	# Testa se a dire��o � esquerda
	li t3, -16
	li t4, 0
	li t0, 2
	beq a0, t0, UpdateEnemy1Continue

	# Testa se a dire��o � baixo
	li t3, 0
	li t4, 16
	li t0, 3
	beq a0, t0, UpdateEnemy1Continue

UpdateEnemy1Continue:

	la t0, enemy1Pos			#Carrega o endere�o do personagem

	# Impede de entrar nas bordas
	lh t1,0(t0)				#Testando se ele vai sair pela esquerda
        add t1,t1,t3
        blt t1,zero,UpdateEnemy1Ret
	li t2, 320				#Testando se ele vai sair pela direita
       	bge t1,t2,UpdateEnemy1Ret 
        lh t1,2(t0)				#Testando se ele vai sair por cima
        add t1,t1,t4
        blt t1,zero,UpdateEnemy1Ret
       	li t2, 240				#Testando se ele vai sair por baixo
        bge t1,t2,UpdateEnemy1Ret

	# Impede de atravessar paredes
	li t1,0xFF000000			#Endere�o base
       	lh t2,0(t0)				#Carrega o x atual
       	add t1,t1,t2				#t1 = endere�o base + x
        add t1,t1,t3				#add o movimento de x em t1
       	lh t2,2(t0)				#carrega o y
       	add t2,t2,t4				#add o movimento do y
       	li t5, 320				#largura da tela
       	mul t2,t2,t5				#320y
       	add t1,t1,t2				#endere�o base + x + incx + 320 * (y + incy)
       	lb t2,0(t1)				#carrega a cor que t� naquela posi��o
       	la t5, corFundo				#pega o endere�o da cor do fundo
       	lb t5,0(t5)				#Carrega a cor do fundo
        bne t2,t5, UpdateEnemy1Ret		#se for parede, entao nao anda

	# Impede do inimigo pegar as chaves
        addi t1,t1,1				#pega exatamente a direita
	lb t2,0(t1)				#pega a cor que est� naquela posi��o
	bne t2, zero, UpdateEnemy1Ret

# Carrega as posi��es
	la t0,enemy1Pos				#carrega o endere�o da posi��o atual
        la t1,oldEnemy1Pos			#carrega o endere�o da posi�� antiga

# Altera a posi��o old
       	lw t2,0(t0)				#Carrega a posi��o atual
       	sw t2,0(t1)				#Salva a posi��o atual em oldEnemy1Pos

# Add o incremento em x
        lh t1,0(t0)				#Carrega o x em t1
       	add t1,t1,t3				#add o incremento no x
       	sh t1,0(t0)				#Salva o novo x

# Add o icremento em y
       	lh t1,2(t0)				#Carrega o y em t1
        add t1,t1,t4				#add o incremento no t
       	sh t1,2(t0)				#Salva o novo y	

NotSameEnemy1Dir:

# Altera a dire��o
	la t0,enemy1Dir				#carrega a dire��o atual
	sb a0,0(t0)				#salva a nova dire��o


	UpdateEnemy1Ret: ret

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
UpdateVisualFuel:
# Apagar at� 3 digitos do numero anterior
# Podemos substituir esse bloco de codigo por apenas um for, bem mais elegante
# A ideia � desenhar dois tiles pra apapagar os digitos	
	la a0, tile
	li a1, 144
	li a2, 220
	li a3, 0xFF200604
	lh a3, 0(a3)
	xori a3, a3, 1
	
	PRINT()
	
	la a0, tile
	li a1, 160
	li a2, 220
	li a3, 0xFF200604
	lh a3, 0(a3)
	xori a3, a3, 1	
	
	PRINT()	
	
# Numero a ser printado
	la a0, fuelCur
	lh a0, 0(a0)
	
# Coluna e linha
	li a1, 144
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


GameOver:
# Encerra o programa
	li a7, 10
	ecall
	
DecreaseFuel:
	
# Verifica a flag para diminuir
	la t0, decFuel
	lh t1, 0(t0)	
	beqz t1, DecreaseFuelRet
# Seta a flag para zero
	sw zero, 0(t0)
	
# Diminue um do combustivel
	la t0, fuelCur
	lh t1, 0(t0)
	addi t1, t1, -1
	sh t1, 0(t0)
	
	DebugInt("Diminuindo combustivel, restam = ", fuelCur)
	
	bgt t1, zero, DecreaseFuelRet
# Se o combustivel for 0 -> ativa flag para diminuir uma vida		
	la t0, decHearts
	li t1, 1
	sh t1, 0(t0)
	DecreaseFuelRet: ret
	
OpenGate:
# Verifica se a vida do portao � zero
	la t0, gateLifeCur
	lb t1, 0(t0)
	bne t1, zero, OpenGateRet
# Se a vida for zero, ent�o pode abrir o port�o
# Para n�o precisar abrir a cada loop, deixa o portao com -1 de vida
	addi t1, t1, -1
	sb t1, 0(t0)
# Abre o portao	
	la a0, tile
	la t0, coordsGate
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0
	PRINT()
	li a3, 1
	PRINT()
		
	OpenGateRet: ret
	
DrawChar:
# Responsavel por desenhar o personagem no frame invertido
#Carrega a dire��o do personagem em t0
	la t0, charDir		
	lb t0, 0(t0)
	
#testa se est� para direita
	li t1, 0
	la a0,charDireita				
	beq t0, t1, DrawCharContinue
#testa se est� para cima
	li t1,1						
	la a0,charCima				
	beq t0, t1, DrawCharContinue
#testa se est� para esquerda
	li t1,2						
	la a0,charEsquerda			
	beq t0, t1, DrawCharContinue
#Testa se est� para baixo
	la a0,charBaixo
	
DrawCharContinue:
	
	#a0 = endere�o da imagem certa
	la t0, charPos
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0xFF200604
	lw a3, 0(a3)
	
	PRINT()
	
	xori a3, a3, 1
	
	PRINT()
	
	ret			
UpdateChar:
	la t0, charDir
	lb t0, 0(t0)
	bne t0, t6, NotSameCharDir

	la t0, charPos				#Carrega o endere�o do personagem
	
	
# Impede de entrar nas bordas
	lh t1,0(t0)				#Testando se ele vai sair pela esquerda
        add t1,t1,t3
        blt t1,zero,UpdateCharRet
	li t2, 320				#Testando se ele vai sair pela direita
       	bge t1,t2,UpdateCharRet 
        lh t1,2(t0)				#Testando se ele vai sair por cima
        add t1,t1,t4
        blt t1,zero,UpdateCharRet
       	li t2, 240				#Testando se ele vai sair por baixo
        bge t1,t2,UpdateCharRet
	
# Impede de atravessar paredes
	li t1,0xFF000000			#Endere�o base
       	lh t2,0(t0)				#Carrega o x atual
       	add t1,t1,t2				#t1 = endere�o base + x
        add t1,t1,t3				#add o movimento de x em t1
       	lh t2,2(t0)				#carrega o y
       	add t2,t2,t4				#add o movimento do y
       	li t5, 320				#largura da tela
       	mul t2,t2,t5				#320y
       	add t1,t1,t2				#endere�o base + x + incx + 320 * (y + incy)
       	lb t2,0(t1)				#carrega a cor que t� naquela posi��o
       	la t5, corFundo				#pega o endere�o da cor do fundo
       	lb t5,0(t5)				#Carrega a cor do fundo
        bne t2,t5, UpdateCharRet		#se for parede, entao nao anda
        
# Coleta as chaves
        addi t1,t1,1				#pega exatamente a direita
	lb t2,0(t1)				#pega a cor que est� naquela posi��o
	la t5,gateLifeCur			#pega o endere�o da vida do portao
	lb t1,0(t5)				#carrega a vida do portao
	sub t1,t1,t2				#remove o numero da posi��o
	sb t1,0(t5)				#salva a nova vida
# Carrega as posi��es
	la t0,charPos				#carrega o endere�o da posi��o atual
        la t1,oldCharPos			#carrega o endere�o da posi�� antiga
# Altera a posi��o old
       	lw t2,0(t0)				#Carrega a posi��o atual
       	sw t2,0(t1)				#Salva a posi��o atual em OLD_CHAR_POS
# Add o incremento em x
        lh t1,0(t0)				#Carrega o x em t1
       	add t1,t1,t3				#add o incremento no x
       	sh t1,0(t0)				#Salva o novo x
# Add o icremento em y
       	lh t1,2(t0)				#Carrega o y em t1
        add t1,t1,t4				#add o incremento no t
       	sh t1,2(t0)				#Salva o novo y	
# Ativa a flag para descontar do combustivel
	la t0, decFuel
	li t1, 1
	sh t1, 0(t0)
	
NotSameCharDir:
# Altera a dire��o
	la t0,charDir				#carrega a dire��o atual
	sb t6,0(t0)				#salva a nova dire��o
        UpdateCharRet: ret
	
Tec:		
	li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
	lw t0,0(t1)				# Le bit de Controle Teclado
	andi t0,t0,0x0001			# mascara o bit menos significativo
   	beq t0,zero,FIM   		   	# Se nao ha tecla pressionada entao vai para FIM
  	lw t1,4(t1)  				# le o valor da tecla tecla
	
	li t0,'w'
	li t3, 0				# add em x para subir
	li t4, -16				# add em y para subir
	li t6, 1				# Nova dire��o
	beq t1,t0, UpdateChar			# se tecla pressionada for 'w', move pra cima
		
	li t0,'a'
	li t3,-16				# add em x para ir pra esq			
	li t4,0					# add em y para ir pra esq
	li t6, 2				# Nova dire��o do personagem
	beq t1,t0,UpdateChar			# se tecla pressionada for 'a', move pra esquerda
		
	li t0,'s'
	li t3,0					# add em x para descer
	li t4,16				# add em y para descer
	li t6,3					# Nova dire��o
	beq t1,t0,UpdateChar			# se tecla pressionada for 's', move para descer
		
	li t0,'d'
	li t3,16				# add em x para ir pra direita
	li t4,0					# add em y pra ir pra direita
	li t6,0					# Nova dire��o
	beq t1,t0,UpdateChar			# se tecla pressionada for 'd', move para direita
	
FIM:	ret					# retorna

#################################################
#	a0 = endere�o imagem			#
#	a1 = x					#
#	a2 = y					#
#	a3 = frame (0 ou 1)			#
#################################################
#	t0 = endereco do bitmap display		#
#	t1 = endereco da imagem			#
#	t2 = contador de linha			#
# 	t3 = contador de coluna			#
#	t4 = largura				#
#	t5 = altura				#
#################################################
Print:
	li t0,0xFF0			# carrega 0xFF0 em t0
	add t0,t0,a3			# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
	slli t0,t0,20			# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
	add t0,t0,a1			# adiciona x ao t0
	li t1,320			# t1 = 320
	mul t1,t1,a2			# t1 = 320 * y
	add t0,t0,t1			# adiciona t1 ao t0
	addi t1,a0,8			# t1 = a0 + 8
	mv t2,zero			# zera t2
	mv t3,zero			# zera t3
	lw t4,0(a0)			# carrega a largura em t4
	lw t5,4(a0)			# carrega a altura em t5
Print_Linha:	
	lw t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
	sw t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
	addi t0,t0,4			# incrementa endereco do bitmap
	addi t1,t1,4			# incrementa endereco da imagem
	addi t3,t3,4			# incrementa contador de coluna
	blt t3,t4,Print_Linha		# se contador da coluna < largura, continue imprimindo
	addi t0,t0,320			# t0 += 320
	sub t0,t0,t4			# t0 -= largura da imagem
	# ^ isso serve pra "pular" de linha no bitmap display
	mv t3,zero			# zera t3 (contador de coluna)
	addi t2,t2,1			# incrementa contador de linha
	bgt t5,t2,Print_Linha		# se altura > contador de linha, continue imprimindo
	ret
.data
.include "sprites/tile.s"
.include "sprites/map.s"
.include "sprites/key00.s"
.include "sprites/key01.s"
.include "sprites/charCima.s"
.include "sprites/charBaixo.s"
.include "sprites/charEsquerda.s"
.include "sprites/charDireita.s"
.include "sprites/porta.s"

.include "sprites/inimigo1Baixo.s"
.include "sprites/inimigo1Cima.s"
.include "sprites/inimigo1Direita.s"
.include "sprites/inimigo1Esquerda.s"

.include "sprites/inimigo2Baixo.s"
.include "sprites/inimigo2Cima.s"
.include "sprites/inimigo2Direita.s"
.include "sprites/inimigo2Esquerda.s"




.text
.include "SYSTEMv21.s"
