SetupShoot:

# Marca o tiro como ativo no jogo
	la t0, shootAlive
	li t1, 1
	sh t1, 0(t0)

# Dependendo da direção do personagem, seta o incremento do tiro
	la t0, incShoot
	
	la t1, charDir
	lh t1, 0(t1)
	


	ret