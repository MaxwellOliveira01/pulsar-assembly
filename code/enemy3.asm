DamageEnemy3:
	
# Se nao estiver vivo, faz nada aqui
	la t0, enemy3Alive
	lh t0, 0(t0)
	beq t0, zero, DamageEnemy3Ret
	
# Carrega a posição do inimigo2
	la t0, charPos
	lh t1, 0(t0) # x do personagem
	lh t2, 2(t0) # y do personagem
	
	la t0, enemy3Pos
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
	bgt t1, t2, DamageEnemy3Ret
	
	# Retirar t1 do combustivel
	#la t2, fuelCur
	#lh t3, 0(t2)
	#addi t3, t3, -1
	#sh t3, 0(t2)
	
	# Liga a flag do combustivel
	la t0, decFuel
	li t1, 1
	sh t1, 0(t0)
	
	DamageEnemy3Ret: ret

DrawEnemy3:
# Se o inimigo não estiver vivo, nao faz nada aqui
	la t0, enemy3Alive
	lh t0, 0(t0)
	beq t0, zero, DrawEnemy3Ret

# Responsavel por desenhar o inimigo2 no frame invertido
#Carrega a dire��o do inimigo em t0
	la t0, enemy3Dir		
	lb t0, 0(t0)
	
#testa se est� para direita
	li t1, 0
	la a0,inimigo3Direita				
	beq t0, t1, DrawEnemy3Continue
#testa se est� para cima
	li t1,1						
	la a0,inimigo3Cima				
	beq t0, t1, DrawEnemy3Continue
#testa se est� para esquerda
	li t1,2						
	la a0,inimigo3Esquerda			
	beq t0, t1, DrawEnemy3Continue
#Testa se est� para baixo
	la a0,inimigo3Baixo
	
DrawEnemy3Continue:
	#a0 = endere�o da imagem certa
	la t0, enemy3Pos
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0xFF200604
	lw a3, 0(a3)
	
	PRINT()
	
	xori a3, a3, 1
	
	PRINT()
	
	DrawEnemy3Ret: ret	

UpdateEnemy3:

# Se nao estiver vivo, faz nada
	la t0, enemy3Alive
	lh t0, 0(t0)
	beq t0, zero, UpdateEnemy3Ret

# Pega um numero aleatorio usando o ecall
	li a7, 42
	li a0, 0
	li a1, 15000000
	ecall
	li t0, 10000000
	
	blt a0, t0, OkUpdateDirEnemy3

	la t0, enemy3Dir
	lb t0, 0(t0)
	add a0, t0, zero

OkUpdateDirEnemy3:
	
	li t0, 4
	rem a0, a0, t0

	#a0 � uma dire��o aleat�ria
	
	la t0, enemy3Dir
	lb t0, 0(t0)
	bne t0, a0, NotSameEnemy3Dir

	# Testa se a dire��o � direita
	li t3, 16
	li t4, 0
	li t0, 0
	beq a0, t0, UpdateEnemy3Continue

	# Testa se a dire��o � cima
	li t3, 0
	li t4, -16
	li t0, 1
	beq a0, t0, UpdateEnemy3Continue

	# Testa se a dire��o � esquerda
	li t3, -16
	li t4, 0
	li t0, 2
	beq a0, t0, UpdateEnemy3Continue

	# Testa se a dire��o � baixo
	li t3, 0
	li t4, 16
	li t0, 3
	beq a0, t0, UpdateEnemy3Continue

UpdateEnemy3Continue:

	la t0, enemy3Pos			#Carrega o endere�o do inimigo2

	# Impede de entrar nas bordas
	lh t1,0(t0)				#Testando se ele vai sair pela esquerda
        add t1,t1,t3
        blt t1,zero,UpdateEnemy3Ret
	li t2, 320				#Testando se ele vai sair pela direita
       	bge t1,t2,UpdateEnemy3Ret 
        lh t1,2(t0)				#Testando se ele vai sair por cima
        add t1,t1,t4
        blt t1,zero,UpdateEnemy3Ret
       	li t2, 240				#Testando se ele vai sair por baixo
        bge t1,t2,UpdateEnemy3Ret

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
        bne t2,t5, UpdateEnemy3Ret		#se for parede, entao nao anda

	# Impede do inimigo pegar as chaves
        addi t1,t1,1				#pega exatamente a direita
	lb t2,0(t1)				#pega a cor que est� naquela posi��o
	bne t2, zero, UpdateEnemy3Ret

# Carrega as posi��es
	la t0,enemy3Pos				#carrega o endere�o da posi��o atual
        la t1,oldEnemy3Pos			#carrega o endere�o da posi�� antiga

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

NotSameEnemy3Dir:

# Altera a dire��o
	la t0,enemy3Dir				#carrega a dire��o atual
	sb a0,0(t0)				#salva a nova dire��o

	UpdateEnemy3Ret: ret

# Seta o oldEnem2Pos para o canto da tela para nao deixar nada piscando
HideOldEnemy3Pos:
	la t0, oldEnemy3Pos
	li t1, 304
	sh t1, 0(t0)
	li t1, 226
	sh t1, 2(t0)
	
	ret