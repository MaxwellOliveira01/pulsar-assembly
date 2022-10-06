#################################################
#	a0 = frequência				#
#	a1 = duração				#
#	a2 = timbre				#
#	a3 = volume				#
#	a4 = endereço do som			#
#################################################

PlaySong:
	# Quantidade de notas
	lh t0, 0(a4)
	
	addi a4, a4, 4

	# Conta quantas notas já foram processadas
	li t1, 0
	
	
	PlaySongLoop:
	beq t0, t1, FimDoSom
	
	li a7, 31
	lh a0, 0(a4)
	lh a1, 2(a4)
	lh a2, 4(a4)
	lh a3, 6(a4)
	ecall
	
	li a7, 32
	lh a0, 2(a4)
	ecall
	
	addi a4, a4, 8
	addi t1, t1, 1
	j PlaySongLoop

	FimDoSom: ret