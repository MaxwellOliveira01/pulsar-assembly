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