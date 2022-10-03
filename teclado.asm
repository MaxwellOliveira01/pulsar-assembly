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
	
	li t0, ' '
	beq t1, t0, SetupShoot
	
FIM:	ret					# retorna
