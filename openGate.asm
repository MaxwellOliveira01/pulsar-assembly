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