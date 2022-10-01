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
	
GameLoop: 

# Recebe do teclado
	call Tec
	
# Desenha o personagem
	call DrawChar
	
# Verifica se pode abrir o portao
	call OpenGate
	
# Verifica a flag de combustivel
	call DecreaseFuel
	
# Verifica a flag de vida
	call DecreaseHearts

# Inverte o frame
	li t0, 0xFF200604
	lh s0, 0(t0)
	xori s0, s0, 1
	sw s0, 0(t0)
	
# Apaga o rastro
	DrawImageInHiddenFrame(tile, oldCharPos)
		
# Volta pro loop do jogo	
	j GameLoop

DecreaseHearts:

# Verifica a flag para diminuir
	la t0, decHearts
	lh t1, 0(t0)
	beq t1, zero, DecreaseHeartsRet	

	DebugInt(decHearts, "decHearts = ")
	
# Seta a flag para zero
	sh zero, 0(t0)

# Diminue a quantidade de vidas em um
	la t0, heartsCur
	lh t1, 0(t0)
	addi t1, t1, -1
	sh t1, 0(t0)
	
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
	
	DebugInt(fuelCur, "fuel = ")

# Diminue um do combustivel
	la t0, fuelCur
	lh t1, 0(t0)
	addi t1, t1, -1
	sh t1, 0(t0)
	
	bgt t1, zero, DecreaseFuelRet

# Se o combustivel for 0 -> ativa flag para diminuir uma vida		
	la t0, decHearts
	li t1, 1
	sh t1, 0(t0)

	DecreaseFuelRet: ret

OpenGate:

# Verifica se a vida do portao é zero
	la t0, gateLifeCur
	lb t1, 0(t0)
	bgt t1, zero, OpenGateRet

# Se a vida for zero, então pode abrir o portão

# Para não precisar abrir a cada loop, deixa o portao com -1 de vida
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

#Carrega a direção do personagem em t0
	la t0, charDir		
	lb t0, 0(t0)
	
#testa se está para direita
	li t1, 0
	la a0,charDireita				
	beq t0, t1, DrawCharContinue

#testa se está para cima
	li t1,1						
	la a0,charCima				
	beq t0, t1, DrawCharContinue

#testa se está para esquerda
	li t1,2						
	la a0,charEsquerda			
	beq t0, t1, DrawCharContinue

#Testa se está para baixo
	la a0,charBaixo
	
DrawCharContinue:
	
	#a0 = endereço da imagem certa
	la t0, charPos
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0xFF200604
	lw a3, 0(a3)
	xori a3, a3, 1
	
	PRINT()
	
	ret			

UpdateChar:

	la t0, charPos				#Carrega o endereço do personagem
	
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
	li t1,0xFF000000			#Endereço base
       	lh t2,0(t0)				#Carrega o x atual
       	add t1,t1,t2				#t1 = endereço base + x
        add t1,t1,t3				#add o movimento de x em t1
       	lh t2,2(t0)				#carrega o y
       	add t2,t2,t4				#add o movimento do y
       	li t5, 320				#largura da tela
       	mul t2,t2,t5				#320y
       	add t1,t1,t2				#endereço base + x + incx + 320 * (y + incy)
       	lb t2,0(t1)				#carrega a cor que tá naquela posição
       	la t5, corFundo				#pega o endereço da cor do fundo
       	lb t5,0(t5)				#Carrega a cor do fundo
        bne t2,t5, UpdateCharRet		#se for parede, entao nao anda
        
# Coleta as chaves
        addi t1,t1,1				#pega exatamente a direita
	lb t2,0(t1)				#pega a cor que está naquela posição
	la t5,gateLifeCur			#pega o endereço da vida do portao
	lb t1,0(t5)				#carrega a vida do portao
	sub t1,t1,t2				#remove o numero da posição
	sb t1,0(t5)				#salva a nova vida

# Altera a direção
	la t0,charDir				#carrega a direção atual
	sb t6,0(t0)				#salva a nova direção

# Carrega as posições
	la t0,charPos				#carrega o endereço da posição atual
        la t1,oldCharPos			#carrega o endereço da posiçõ antiga

# Altera a posição old
       	lw t2,0(t0)				#Carrega a posição atual
       	sw t2,0(t1)				#Salva a posição atual em OLD_CHAR_POS

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
	li t6, 1				# Nova direção
	beq t1,t0, UpdateChar			# se tecla pressionada for 'w', move pra cima
		
	li t0,'a'
	li t3,-16				# add em x para ir pra esq			
	li t4,0					# add em y para ir pra esq
	li t6, 2				# Nova direção do personagem
	beq t1,t0,UpdateChar			# se tecla pressionada for 'a', move pra esquerda
		
	li t0,'s'
	li t3,0					# add em x para descer
	li t4,16				# add em y para descer
	li t6,3					# Nova direção
	beq t1,t0,UpdateChar			# se tecla pressionada for 's', move para descer
		
	li t0,'d'
	li t3,16				# add em x para ir pra direita
	li t4,0					# add em y pra ir pra direita
	li t6,0					# Nova direção
	beq t1,t0,UpdateChar			# se tecla pressionada for 'd', move para direita
	
FIM:	ret					# retorna

#################################################
#	a0 = endereço imagem			#
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
PRINT_LINHA:	
	lw t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
	sw t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
	addi t0,t0,4			# incrementa endereco do bitmap
	addi t1,t1,4			# incrementa endereco da imagem
	addi t3,t3,4			# incrementa contador de coluna
	blt t3,t4,PRINT_LINHA		# se contador da coluna < largura, continue imprimindo
	addi t0,t0,320			# t0 += 320
	sub t0,t0,t4			# t0 -= largura da imagem
	# ^ isso serve pra "pular" de linha no bitmap display
	mv t3,zero			# zera t3 (contador de coluna)
	addi t2,t2,1			# incrementa contador de linha
	bgt t5,t2,PRINT_LINHA		# se altura > contador de linha, continue imprimindo


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

.text
.include "SYSTEMv21.s"
