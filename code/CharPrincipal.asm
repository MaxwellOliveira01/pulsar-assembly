DrawChar:
# Responsavel por desenhar o personagem no frame invertido
#Carrega a direï¿½ï¿½o do personagem em t0
	la t0, charDir		
	lb t0, 0(t0)
	
#testa se estï¿½ para direita
	li t1, 0
	la a0,charDireita				
	beq t0, t1, DrawCharContinue
#testa se estï¿½ para cima
	li t1,1						
	la a0,charCima				
	beq t0, t1, DrawCharContinue
#testa se estï¿½ para esquerda
	li t1,2						
	la a0,charEsquerda			
	beq t0, t1, DrawCharContinue
#Testa se estï¿½ para baixo
	la a0,charBaixo
	
DrawCharContinue:
	
	#a0 = endereï¿½o da imagem certa
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
# Verifica se Mudou de direção
	la t0, charDir
	lb t0, 0(t0)
	bne t0, t6, NotSameCharDir

	la t0, charPos				#Carrega o endereï¿½o do personagem
	
	
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
	li t1,0xFF000000			#Endereï¿½o base
       	lh t2,0(t0)				#Carrega o x atual
       	add t1,t1,t2				#t1 = endereï¿½o base + x
        add t1,t1,t3				#add o movimento de x em t1
       	lh t2,2(t0)				#carrega o y
       	add t2,t2,t4				#add o movimento do y
       	li t5, 320				#largura da tela
       	mul t2,t2,t5				#320y
       	add t1,t1,t2				#endereï¿½o base + x + incx + 320 * (y + incy)
       	lb t2,0(t1)				#carrega a cor que tï¿½ naquela posiï¿½ï¿½o
       	la t5, corFundo				#pega o endereï¿½o da cor do fundo
       	lb t5,0(t5)				#Carrega a cor do fundo
        bne t2,t5, UpdateCharRet		#se for parede, entao nao anda
        
# Coleta as chaves
        addi t1,t1,1				#pega exatamente a direita
	lb t2,0(t1)				#pega a cor que estï¿½ naquela posiï¿½ï¿½o
	la t5,gateLifeCur			#pega o endereï¿½o da vida do portao
	lb t1,0(t5)				#carrega a vida do portao
	sub t1,t1,t2				#remove o numero da posiï¿½ï¿½o
	sb t1,0(t5)				#salva a nova vida
# Carrega as posiï¿½ï¿½es
	la t0,charPos				#carrega o endereï¿½o da posiï¿½ï¿½o atual
        la t1,oldCharPos			#carrega o endereï¿½o da posiï¿½ï¿½ antiga
# Altera a posiï¿½ï¿½o old
       	lw t2,0(t0)				#Carrega a posiï¿½ï¿½o atual
       	sw t2,0(t1)				#Salva a posiï¿½ï¿½o atual em OLD_CHAR_POS
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
# Altera a direï¿½ï¿½o
	la t0,charDir				#carrega a direï¿½ï¿½o atual
	sb t6,0(t0)				#salva a nova direï¿½ï¿½o

# Avisa que o personagem se moveu
	la t0, charDidMove
	li t1, 1
	sh t1, 0(t0)

        UpdateCharRet: ret
