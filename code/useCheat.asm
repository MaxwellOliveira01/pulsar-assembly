UseCheat:
	la t0, Fase
	lh t1, 0(t0)
	addi t1, t1, 1
	sh t1, 0(t0)
	
	li t2, 3
	
	DebugInt("Fase = ", Fase)
	
	bne t1, t2, UseCheatRet
	
	# ativa a flag de vitoria
	
	la t0, winFlag
	li t1, 1
	sh t1, 0(t0)
	
	UseCheatRet: 
		j TrampolimReinitialize